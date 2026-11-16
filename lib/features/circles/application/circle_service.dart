import 'dart:async';
import 'dart:developer' show log;

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/features/circles/data/circle_repository.dart';
import 'package:safecircle/features/circles/domain/circle.dart';

final circleServiceProvider = Provider<CircleService>((ref) => CircleService(
      ref.watch(circleRepositoryProvider),
      sendTexts: _sendInviteTextsViaFunction,
    ));

/// Calls the server's texting function with [request] and returns its reply.
typedef InviteTexter = Future<Map<String, dynamic>> Function(Map<String, dynamic> request);

/// Calls the `sendCircleInviteTexts` Cloud Function (functions/index.js),
/// which reads the phone numbers from the circle and sends them via Twilio.
Future<Map<String, dynamic>> _sendInviteTextsViaFunction(Map<String, dynamic> request) async {
  try {
    final result = await FirebaseFunctions.instance
        .httpsCallable('sendCircleInviteTexts')
        .call<Map<String, dynamic>>(request);
    return result.data;
  } on FirebaseFunctionsException catch (e) {
    if (e.code == 'failed-precondition') return {'joined': true};
    rethrow;
  }
}

/// What happened when the owner tapped "Resend invitation".
class ResendResult {
  const ResendResult({
    this.texted = false,
    this.retryAfter = 0,
    this.limited = false,
    this.textFailed = false,
    this.joined = false,
    this.hasAccount = false,
  });

  final bool texted;
  /// Seconds until this number may be texted again (resend was too soon).
  final int retryAfter;
  final bool limited;
  final bool textFailed;
  final bool joined;
  /// They have a SafeCircle account, so the in-app invitation reaches them.
  final bool hasAccount;

  String message(String firstName) {
    if (joined) return '$firstName already joined this circle.';
    if (texted) return 'Invitation texted to $firstName again.';
    if (retryAfter > 0) {
      final minutes = (retryAfter / 60).ceil();
      return 'You just texted $firstName. Try again in $minutes ${minutes == 1 ? 'minute' : 'minutes'}.';
    }
    if (limited) return 'Daily text limit reached. Try again tomorrow.';
    final inApp = hasAccount ? ' The in-app invitation is still waiting for them.' : '';
    if (textFailed) return 'Could not text $firstName.$inApp';
    if (hasAccount) return 'In-app invitation sent to $firstName again.';
    return 'No SafeCircle account yet for $firstName. Add a phone number to text them.';
  }
}

class CircleService {
  CircleService(this._circles, {InviteTexter? sendTexts}) : _sendTexts = sendTexts;

  final CircleRepository _circles;
  final InviteTexter? _sendTexts;

  Future<List<String>> saveAndInvite(Circle circle, {required bool isNew}) async {
    if (isNew) {
      await _circles.createCircle(circle);
    } else {
      await _circles.updateCircle(circle);
    }
    final missing = <String>[];
    for (final m in circle.members) {
      final email = m.email ?? '';
      if (email.isEmpty) continue;
      if (!await _circles.sendInvite(circle: circle, toEmail: email)) missing.add(email);
    }
    return missing;
  }

  /// Texts an invitation to the circle's members who have a phone number.
  /// Never throws: texting is a bonus on top of the in-app invitation, so a
  /// failure (no network, function not deployed yet…) only returns 0.
  Future<int> sendInviteTexts(Circle circle) async {
    final id = circle.id;
    final send = _sendTexts;
    if (id == null || send == null || !circle.members.any((m) => m.digits.isNotEmpty)) return 0;
    try {
      final reply = await send({'circleId': id}).timeout(const Duration(seconds: 20));
      return (reply['sent'] as num?)?.toInt() ?? 0;
    } catch (e) {
      log('Invite texts failed: $e', name: 'SafeCircle');
      return 0;
    }
  }

  /// Sends [person]'s invitation again: the in-app invitation (if they have
  /// an account) and a new text (if they have a phone number).
  Future<ResendResult> resendInvitation(Circle circle, Person person) async {
    final id = circle.id;
    final email = person.email ?? '';
    final hasAccount =
        id != null && email.isNotEmpty && await _circles.sendInvite(circle: circle, toEmail: email);
    final send = _sendTexts;
    if (id == null || send == null || person.digits.isEmpty) return ResendResult(hasAccount: hasAccount);
    try {
      final reply = await send({
        'circleId': id,
        'resend': {'countryCode': person.countryCode, 'digits': person.digits},
      }).timeout(const Duration(seconds: 20));
      if (reply['joined'] == true) return const ResendResult(joined: true);
      return ResendResult(
        texted: ((reply['sent'] as num?) ?? 0) > 0,
        retryAfter: (reply['retryAfter'] as num?)?.toInt() ?? 0,
        limited: ((reply['limited'] as num?) ?? 0) > 0,
        textFailed: ((reply['failed'] as num?) ?? 0) > 0,
        hasAccount: hasAccount,
      );
    } catch (e) {
      log('Resend text failed: $e', name: 'SafeCircle');
      return ResendResult(textFailed: true, hasAccount: hasAccount);
    }
  }

  Future<void> removeMember(Circle circle, Person member) async {
    circle.members.remove(member);
    await _circles.removeMember(circle, member);
  }
}
