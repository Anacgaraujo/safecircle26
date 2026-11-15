import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/features/live_map/data/tracking_service.dart';
import 'package:safecircle/features/live_map/domain/location_sharing.dart';

final locationSharingProvider = Provider<LocationSharing>((ref) => TrackingService.instance);

final liveSharingProvider = NotifierProvider<LiveSharing, bool>(LiveSharing.new);

class LiveSharing extends Notifier<bool> {
  LocationSharing get _sharing => ref.read(locationSharingProvider);

  @override
  bool build() {
    final running = ref.watch(locationSharingProvider).running;
    void sync() => state = running.value;
    running.addListener(sync);
    ref.onDispose(() => running.removeListener(sync));
    return running.value;
  }

  bool get paused => _sharing.paused;

  Future<void> startIfAllowed() => _sharing.start();

  Future<bool> resume() async {
    _sharing.paused = false;
    await _sharing.start(userInitiated: true);
    return _sharing.isRunning;
  }

  Future<void> pause() async {
    _sharing.paused = true;
    await _sharing.stop();
  }
}
