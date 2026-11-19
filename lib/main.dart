import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:safecircle/app/app.dart';
import 'package:safecircle/core/firebase/firebase_bootstrap.dart';
import 'package:safecircle/core/notifications/notification_service.dart';
import 'package:safecircle/core/notifications/push_service.dart';
import 'package:safecircle/features/live_map/data/background_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  PaintingBinding.instance.imageCache.maximumSizeBytes = 60 << 20;
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  await initFirebase();
  await NotificationService.instance.init();
  unawaited(PushService.instance.listenForTaps());
  await BackgroundLocationService.configure();
  runApp(ProviderScope(retry: (_, __) => null, child: const SafeCircleApp()));
}
