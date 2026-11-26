import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// What a tapped push notification asks the app to open.
sealed class PushTarget {
  const PushTarget();

  /// Reads the `data` the server attaches to each push (functions/push.js).
  static PushTarget? fromData(Map<String, dynamic> data) => switch (data['kind']) {
        'alert' when (data['alertId'] ?? '').toString().isNotEmpty =>
          AlertTarget(data['alertId'].toString()),
        'invite' => const InviteTarget(),
        'journey' => const JourneyTarget(),
        _ => null,
      };

  /// Reads the payload of the app's own notifications (NotificationService):
  /// `alert:<id>`, `invite` or `journey`.
  static PushTarget? fromPayload(String? payload) {
    if (payload == null || payload.isEmpty) return null;
    final i = payload.indexOf(':');
    final kind = i < 0 ? payload : payload.substring(0, i);
    return fromData({'kind': kind, if (i >= 0) 'alertId': payload.substring(i + 1)});
  }
}

class AlertTarget extends PushTarget {
  const AlertTarget(this.alertId);
  final String alertId;
}

class InviteTarget extends PushTarget {
  const InviteTarget();
}

/// The user's own journey: a check-in reminder was tapped.
class JourneyTarget extends PushTarget {
  const JourneyTarget();
}

/// Registers this phone for push notifications (Firebase Cloud Messaging).
///
/// The device token is kept in `users/{uid}/private/push` (`tokens`), which
/// only the user and the servers can read. The servers push SOS, panic,
/// missed check-in and all-clear alerts and circle invitations, so they reach
/// people even when the app is closed. While the app is open its own
/// listeners already show those notifications, so pushes are not shown twice.
class PushService {
  PushService._();
  static final PushService instance = PushService._();

  FirebaseMessaging get _messaging => FirebaseMessaging.instance;
  StreamSubscription<String>? _refresh;
  String? _uid;
  String? _token;

  /// Called with what to open when the user taps a push notification.
  void Function(PushTarget target)? onOpen;
  PushTarget? _pendingOpen;

  bool get _supported =>
      !kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android);

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      FirebaseFirestore.instance.collection('users').doc(uid).collection('private').doc('push');

  /// Asks for permission, then saves this phone's token for [uid].
  Future<void> register(String uid) async {
    if (!_supported || uid.isEmpty) return;
    _uid = uid;
    try {
      await _messaging.requestPermission(alert: true, badge: true, sound: true);
      // The app's listeners show alerts while it is open.
      await _messaging.setForegroundNotificationPresentationOptions(alert: false, badge: true, sound: false);
      final token = await _tokenWithRetry();
      if (token != null) await _save(uid, token);
      _refresh ??= _messaging.onTokenRefresh.listen((t) {
        final u = _uid;
        if (u != null) _save(u, t);
      });
    } catch (e) {
      debugPrint('[SafeCircle] push register failed: $e');
    }
  }

  /// Removes this phone's token, so a signed-out phone gets no more pushes.
  /// Must run before signing out (the token doc needs the user's access).
  Future<void> unregister() async {
    final uid = _uid;
    final token = _token;
    _uid = null;
    _token = null;
    await _refresh?.cancel();
    _refresh = null;
    if (!_supported || uid == null) return;
    try {
      if (token != null) {
        await _doc(uid).set({'tokens': FieldValue.arrayRemove([token])}, SetOptions(merge: true));
      }
      await _messaging.deleteToken();
    } catch (e) {
      debugPrint('[SafeCircle] push unregister failed: $e');
    }
  }

  /// Starts listening for taps. [onOpen] gets taps that opened the app too.
  Future<void> listenForTaps() async {
    if (!_supported) return;
    try {
      FirebaseMessaging.onMessageOpenedApp.listen((m) => _open(m.data));
      final initial = await _messaging.getInitialMessage();
      if (initial != null) _open(initial.data);
    } catch (e) {
      debugPrint('[SafeCircle] push taps unavailable: $e');
    }
  }

  /// Hands over a tap that came in before anyone was listening.
  PushTarget? takePendingOpen() {
    final t = _pendingOpen;
    _pendingOpen = null;
    return t;
  }

  void _open(Map<String, dynamic> data) => openTarget(PushTarget.fromData(data));

  /// Opens [target] now, or once the app is ready to show it.
  void openTarget(PushTarget? target) {
    if (target == null) return;
    final handler = onOpen;
    if (handler == null) {
      _pendingOpen = target;
    } else {
      handler(target);
    }
  }

  Future<void> _save(String uid, String token) async {
    final old = _token;
    _token = token;
    await _doc(uid).set({
      'tokens': FieldValue.arrayUnion([token]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    if (old != null && old != token) {
      await _doc(uid).set({'tokens': FieldValue.arrayRemove([old])}, SetOptions(merge: true));
    }
  }

  /// On iOS the FCM token needs the APNs token, which can take a moment.
  Future<String?> _tokenWithRetry() async {
    for (var i = 0; i < 5; i++) {
      try {
        if (defaultTargetPlatform == TargetPlatform.iOS && await _messaging.getAPNSToken() == null) {
          await Future<void>.delayed(const Duration(seconds: 2));
          continue;
        }
        return await _messaging.getToken();
      } catch (e) {
        debugPrint('[SafeCircle] push token not ready: $e');
        await Future<void>.delayed(const Duration(seconds: 2));
      }
    }
    return null;
  }
}
