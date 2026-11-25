import 'dart:async';
import 'dart:developer' show log;

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/features/circles/data/circle_repository.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/l10n/l10n.dart';

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
    if (e.code == 'failed-precondition') {
      return e.message == 'no-consent' ? {'noConsent': true} : {'joined': true};
    }
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
    this.noConsent = false,
  });

  final bool texted;
  /// Seconds until this number may be texted again (resend was too soon).
  final int retryAfter;
  final bool limited;
  final bool textFailed;
  final bool joined;
  /// They have a SafeCircle account, so the in-app invitation reaches them.
  final bool hasAccount;
  /// No text sent: they haven't agreed to get texts (consent box unticked).
  final bool noConsent;

  /// Nothing reached them (no account, no text sent or recently sent), so the
  /// owner should send the invitation themselves from the share sheet.
  /// A text the owner sends from their own phone isn't an A2P business
  /// text, so it doesn't need the SafeCircle texting consent.
  bool get shouldShare => !joined && !texted && !hasAccount && retryAfter == 0;

  String message(String firstName) {
    if (joined) return appL10n.resendAlreadyJoined(firstName);
    if (texted) return appL10n.resendTexted(firstName);
    if (retryAfter > 0) {
      final minutes = (retryAfter / 60).ceil();
      return appL10n.resendTooSoon(firstName, minutes);
    }
    if (limited) return appL10n.resendLimited;
    if (noConsent) {
      return hasAccount ? appL10n.resendInApp(firstName) : appL10n.resendNoConsent(firstName);
    }
    if (textFailed) {
      return hasAccount ? appL10n.resendFailedInAppWaiting(firstName) : appL10n.resendFailed(firstName);
    }
    if (hasAccount) return appL10n.resendInApp(firstName);
    return appL10n.resendNoAccount(firstName);
  }
}

/// Where an invitation sends someone to get the app (the website links to
/// the stores, so one link works on iPhone and Android).
const kAppInviteUrl = 'https://safecircle.me';

/// The invitation the owner sends from their own phone (share sheet).
String inviteShareMessage(Circle circle, Person person) {
  final email = (person.email ?? '').trim();
  return email.isNotEmpty
      ? appL10n.inviteShareMessage(circle.name, kAppInviteUrl, email)
      : appL10n.inviteShareMessageNoEmail(circle.name, kAppInviteUrl);
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
    if (!person.smsConsent) return ResendResult(noConsent: true, hasAccount: hasAccount);
    try {
      final reply = await send({
        'circleId': id,
        'resend': {'countryCode': person.countryCode, 'digits': person.digits},
      }).timeout(const Duration(seconds: 20));
      if (reply['joined'] == true) return const ResendResult(joined: true);
      if (reply['noConsent'] == true) return ResendResult(noConsent: true, hasAccount: hasAccount);
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
