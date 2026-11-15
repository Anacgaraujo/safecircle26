import 'dart:async';

import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'package:safecircle/core/platform/web_notifier.dart';
import 'package:safecircle/features/journeys/domain/journey.dart';
import 'package:safecircle/features/alerts/domain/safety_alert.dart';
import 'package:safecircle/features/circles/domain/circle_invite.dart';
import 'package:safecircle/features/live_map/domain/tracking.dart';
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/core/utils/formatters.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  final Map<int, Timer> _webTimers = {};

  bool checkinReminder = true;
  bool circleAlerts = true;
  bool overdueAlerts = true;

  final Set<String> _notified = {};

  static const _channel = AndroidNotificationDetails(
    'safecircle_alerts',
    'SafeCircle alerts',
    channelDescription: 'Check-in reminders and safety alerts',
    importance: Importance.max,
    priority: Priority.high,
  );
  static const _details = NotificationDetails(android: _channel, iOS: DarwinNotificationDetails());

  Future<void> init() async {
    if (_ready) return;
    if (kIsWeb) {
      _ready = WebNotifier.supported;
      return;
    }
    try {
      tzdata.initializeTimeZones();
      try {
        final name = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(name));
      } catch (_) {
      }
      await _plugin.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('ic_stat_safecircle'),
          iOS: DarwinInitializationSettings(),
        ),
      );
      _ready = true;
    } catch (e) {
      debugPrint('[SafeCircle] notification init failed: $e');
    }
  }

  bool get isReady => _ready;

  bool get webGranted => kIsWeb && WebNotifier.granted;

  Future<bool> requestWebPermission() async {
    if (!kIsWeb) return true;
    return WebNotifier.requestPermission();
  }

  Future<void> _show(int id, String title, String body) async {
    if (kIsWeb) {
      WebNotifier.show(title, body);
      return;
    }
    await _plugin.show(id, title, body, _details);
  }

  int _reminderId(String journeyId, int index, {bool lastCall = false}) =>
      (journeyId.hashCode & 0x3ffff) * 64 + index * 2 + (lastCall ? 1 : 0);

  Future<void> scheduleJourneyReminders(String journeyId, List<CheckIn> checkIns) async {
    if (!_ready || !checkinReminder) return;
    final now = DateTime.now();
    for (var i = 0; i < checkIns.length; i++) {
      final c = checkIns[i];
      if (c.confirmed || c.at == null) continue;
      final at = c.at!;
      if (at.isAfter(now)) {
        await _scheduleAt(
          _reminderId(journeyId, i),
          'Check-in due now',
          "${c.label} · ${c.time} — open SafeCircle and confirm you're safe.",
          at,
          now,
        );
      }
      final lastCall = at.add(kCheckInGrace - const Duration(minutes: 1));
      if (lastCall.isAfter(now)) {
        await _scheduleAt(
          _reminderId(journeyId, i, lastCall: true),
          'Last call: confirm your check-in',
          '${c.label} · ${c.time} — your circle will be alerted in 1 minute.',
          lastCall,
          now,
        );
      }
    }
  }

  Future<void> _scheduleAt(int id, String title, String body, DateTime at, DateTime now) async {
    if (kIsWeb) {
      _webTimers.remove(id)?.cancel();
      _webTimers[id] = Timer(at.difference(now), () {
        _webTimers.remove(id);
        WebNotifier.show(title, body);
      });
      return;
    }
    final when = tz.TZDateTime.from(at, tz.local);
    try {
      await _plugin.zonedSchedule(id, title, body, when, _details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
    } catch (e) {
      debugPrint('[SafeCircle] exact reminder failed ($e), falling back to inexact');
      try {
        await _plugin.zonedSchedule(id, title, body, when, _details,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle);
      } catch (e2) {
        debugPrint('[SafeCircle] reminder scheduling failed: $e2');
      }
    }
  }

  Future<void> createServiceChannel(String id, String name, String description) async {
    if (kIsWeb) return;
    try {
      await _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(AndroidNotificationChannel(
            id,
            name,
            description: description,
            importance: Importance.low,
            showBadge: false,
          ));
    } catch (e) {
      debugPrint('[SafeCircle] service channel: $e');
    }
  }

  Future<bool> sendTest() async {
    if (!_ready) return false;
    if (kIsWeb && !WebNotifier.granted) return false;
    try {
      await _show(
        424242,
        'SafeCircle notifications are working',
        'You will be alerted like this for check-ins, overdue friends and emergencies.',
      );
      return true;
    } catch (e) {
      debugPrint('[SafeCircle] test notification failed: $e');
      return false;
    }
  }

  Future<void> cancelReminder(String journeyId, int index) async {
    if (!_ready) return;
    for (final id in [
      _reminderId(journeyId, index),
      _reminderId(journeyId, index, lastCall: true),
    ]) {
      if (kIsWeb) {
        _webTimers.remove(id)?.cancel();
        continue;
      }
      try {
        await _plugin.cancel(id);
      } catch (_) {}
    }
  }

  Future<void> cancelJourneyReminders(String journeyId, int count) async {
    if (!_ready) return;
    for (var i = 0; i < count; i++) {
      await cancelReminder(journeyId, i);
    }
  }

  Future<void> notifyAlert(SafetyAlert alert) async {
    if (!_ready) return;
    if (!_notified.add('alert-${alert.id}')) return;
    try {
      await _show(
        alert.id.hashCode & 0x7fffffff,
        alert.headline,
        '${alert.kindLabel} · ${alert.timeLabel}'
            '${alert.location.isEmpty ? '' : ' · ${alert.location}'}',
      );
    } catch (_) {}
  }

  Future<void> notifyInvite(CircleInvite invite) async {
    if (!_ready) return;
    final id = invite.id;
    if (id.isEmpty || !_notified.add('invite-$id')) return;
    try {
      await _show(
        id.hashCode & 0x7fffffff,
        'Circle invite',
        '${invite.summary} — open SafeCircle to accept.',
      );
    } catch (_) {}
  }

  Future<void> notifyTripRisk(Trip trip) async {
    if (!_ready || !overdueAlerts) return;
    if (!_notified.add('trip-${trip.startMillis}')) return;
    try {
      await _show(
        trip.startMillis.hashCode & 0x7fffffff,
        'Speed alert on your last trip',
        '${trip.title} · top ${scSpeed(trip.maxSpeedKmh)}',
      );
    } catch (_) {}
  }

  Future<void> notifyActivity(ActivityEvent e) async {
    if (!_ready || !circleAlerts) return;
    if (e.userId == Session.instance.uid) return;
    if (!_notified.add('activity-${e.id}')) return;
    try {
      await _show(e.id.hashCode & 0x7fffffff, e.title, e.subtitle);
    } catch (_) {}
  }

  Future<void> notifyOverdue(Journey j) async {
    if (!_ready || !overdueAlerts) return;
    final missed = j.missedCheckIn(DateTime.now());
    if (!_notified.add('overdue-${j.id}-${missed?.atMillis ?? 0}')) return;
    try {
      await _show(
        j.id.hashCode & 0x7fffffff,
        '${j.ownerFirstName} missed a check-in',
        '${missed?.label ?? 'Check-in'} is overdue — reach out.',
      );
    } catch (_) {}
  }
}
