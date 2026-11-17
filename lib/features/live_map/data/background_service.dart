import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/core/firebase/firebase_bootstrap.dart';
import 'package:safecircle/core/data/repositories.dart';
import 'package:safecircle/features/journeys/data/journey_monitor.dart';
import 'package:safecircle/core/notifications/notification_service.dart';
import 'package:safecircle/features/live_map/data/tracking_service.dart';
import 'package:safecircle/l10n/l10n.dart';

bool get backgroundServiceSupported =>
    !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

const _serviceChannelId = 'safecircle_location';
const _serviceNotificationId = 4242;

class BackgroundLocationService {
  BackgroundLocationService._();

  static Future<void> configure() async {
    if (!backgroundServiceSupported) return;
    await NotificationService.instance.createServiceChannel(
      _serviceChannelId,
      appL10n.locationSharingChannel,
      appL10n.locationSharingChannelDescription,
    );
    await FlutterBackgroundService().configure(
      androidConfiguration: AndroidConfiguration(
        onStart: backgroundServiceEntry,
        autoStart: false,
        autoStartOnBoot: false,
        isForegroundMode: true,
        notificationChannelId: _serviceChannelId,
        initialNotificationTitle: appL10n.sharingNotificationTitle,
        initialNotificationContent: appL10n.sharingNotificationBody,
        foregroundServiceNotificationId: _serviceNotificationId,
        foregroundServiceTypes: [AndroidForegroundType.location],
      ),
      iosConfiguration: IosConfiguration(autoStart: false),
    );
  }

  static Future<bool> isRunning() async {
    if (!backgroundServiceSupported) return false;
    return FlutterBackgroundService().isRunning();
  }

  static Future<void> start() async {
    if (!backgroundServiceSupported) return;
    final svc = FlutterBackgroundService();
    if (await svc.isRunning()) {
      if (await _healthy(svc)) return;
      svc.invoke('stop');
      for (var i = 0; i < 20 && await svc.isRunning(); i++) {
        await Future.delayed(const Duration(milliseconds: 150));
      }
    }
    await svc.startService();
  }

  static Future<bool> _healthy(FlutterBackgroundService svc) async {
    final pong = svc.on('pong').first.timeout(
          const Duration(seconds: 3),
          onTimeout: () => null,
        );
    svc.invoke('ping');
    final r = await pong;
    if (r == null) return false;
    final fixAge = (r['fixAgeSec'] as num?)?.toInt() ?? -1;
    final uptime = (r['uptimeSec'] as num?)?.toInt() ?? 0;
    return fixAge >= 0 || uptime < 120;
  }

  static void stop() {
    if (!backgroundServiceSupported) return;
    FlutterBackgroundService().invoke('stop');
  }
}

@pragma('vm:entry-point')
Future<void> backgroundServiceEntry(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  service.on('ping').listen((_) {
    final t = TrackingService.instance;
    final last = t.lastFixAt;
    service.invoke('pong', {
      'fixAgeSec': last == null ? -1 : DateTime.now().difference(last).inSeconds,
      'uptimeSec': t.uptime.inSeconds,
    });
  });

  service.on('stop').listen((_) async {
    JourneyMonitor.instance.stop();
    await TrackingService.instance.stop(markPaused: false);
    await service.stopSelf();
  });

  try {
    await initFirebase();

    final user = FirebaseAuth.instance.currentUser ??
        await FirebaseAuth.instance
            .authStateChanges()
            .first
            .timeout(const Duration(seconds: 10), onTimeout: () => null);
    if (user == null) {
      await service.stopSelf();
      return;
    }

    final app = Session.instance..uid = user.uid;
    final doc = await Repositories.instance.users.getUserDoc(user.uid);
    app.setProfile(
      uid: user.uid,
      name: (doc?['name'] ?? user.email?.split('@').first ?? 'Me') as String,
      email: user.email ?? '',
      photo: doc?['photoPath'] as String?,
    );

    await NotificationService.instance.init();
    TrackingService.instance.inBackgroundIsolate = true;
    await TrackingService.instance.start();
    JourneyMonitor.instance.start();

    if (!TrackingService.instance.isRunning) {
      JourneyMonitor.instance.stop();
      await service.stopSelf();
    }
  } catch (e) {
    debugPrint('[SafeCircle] background service failed: $e');
    await service.stopSelf();
  }
}
