import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/data/lookup_hash.dart';
import 'package:safecircle/core/notifications/notification_service.dart';
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/features/profile/data/user_repository.dart';

typedef SessionUser = ({String uid, String email});

final sessionLoaderProvider = Provider<SessionLoader>((ref) => SessionLoader(
      users: ref.watch(userRepositoryProvider),
      session: ref.watch(sessionProvider),
      applyNotificationSettings: (settings) => NotificationService.instance
        ..checkinReminder = settings['checkinReminder'] ?? true
        ..circleAlerts = settings['circleAlerts'] ?? true
        ..overdueAlerts = settings['overdueAlerts'] ?? true,
    ));

final sessionLoadProvider = FutureProvider.autoDispose.family<bool, SessionUser>(
  (ref, user) => ref.watch(sessionLoaderProvider).load(user),
  retry: (_, __) => null,
);

class SessionLoader {
  SessionLoader({
    required this.users,
    required this.session,
    this.applyNotificationSettings,
    this.pause = const Duration(milliseconds: 600),
  });

  final UserRepository users;
  final Session session;
  final void Function(Map<String, bool> settings)? applyNotificationSettings;
  final Duration pause;

  Future<bool> load(SessionUser user) async {
    Object? lastError;
    for (var attempt = 0; attempt < 3; attempt++) {
      try {
        return await _loadOnce(user).timeout(const Duration(seconds: 15));
      } catch (e) {
        lastError = e;
        await Future.delayed(pause);
      }
    }
    throw lastError ?? 'Could not load session';
  }

  Future<bool> _loadOnce(SessionUser user) async {
    Future<Map<String, dynamic>?> readDoc() async {
      try {
        return await users.getUserDoc(user.uid);
      } catch (_) {
        return null;
      }
    }

    session.uid = user.uid;
    final docF = readDoc();
    final privF = users.getPrivateProfile().then<Map<String, dynamic>?>((v) => v,
        onError: (_) => null);
    final pinsF = users.getPins();
    unawaited(pinsF.then((_) {}, onError: (_) {}));
    final settingsF =
        users.getSettings().then<Map<String, bool>?>((v) => v, onError: (_) => null);

    var doc = await docF;
    for (var i = 0; i < 5 && doc?['name'] == null; i++) {
      await Future.delayed(pause);
      doc = await readDoc();
    }

    final email = user.email.toLowerCase();
    final priv = await privF;
    final phone = (priv?['phone'] ?? doc?['phone'] ?? '') as String;
    final name = (doc?['name'] ?? email.split('@').first) as String;

    final needsHeal = doc == null ||
        doc['emailHash'] == null ||
        doc['email'] != null ||
        doc['phone'] != null ||
        doc['phoneDigits'] != null ||
        doc['lookupV'] != kLookupVersion;
    if (email.isNotEmpty && needsHeal) {
      unawaited(() async {
        try {
          final latest = await readDoc();
          final safeName = (latest?['name'] ?? name) as String;
          await users.createUserDoc(uid: user.uid, name: safeName, email: email, phone: phone);
        } catch (_) {}
      }());
    }

    session.setProfile(
      uid: user.uid,
      name: name.isEmpty ? 'Me' : name,
      email: email,
      phone: phone,
      photo: doc?['photoPath'] as String?,
    );

    final (safety, panic) = await pinsF;
    session.setPins(safety: safety, panic: panic);

    final settings = await settingsF;
    if (settings != null) {
      applyNotificationSettings?.call(settings);
      session.mapHome = settings['mapHome'] ?? true;
    }

    return safety.isNotEmpty;
  }
}
