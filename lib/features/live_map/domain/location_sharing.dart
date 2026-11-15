import 'package:flutter/foundation.dart';

abstract interface class LocationSharing {
  ValueListenable<bool> get running;
  bool get isRunning;

  bool get paused;
  set paused(bool value);

  Future<void> start({bool userInitiated = false});
  Future<void> stop({bool markPaused = true});
}
