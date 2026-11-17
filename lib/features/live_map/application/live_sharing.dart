import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/features/live_map/data/tracking_service.dart';
import 'package:safecircle/features/live_map/domain/location_sharing.dart';

final locationSharingProvider = Provider<LocationSharing>((ref) => TrackingService.instance);

final liveSharingProvider = NotifierProvider<LiveSharing, bool>(LiveSharing.new);

class LiveSharing extends Notifier<bool> {
  LocationSharing get _sharing => ref.read(locationSharingProvider);

  /// Paused with the panic PIN: this phone shows sharing as paused, but the
  /// location keeps going to the circle. Kept in memory only, never written
  /// anywhere someone holding the phone could find it.
  bool _decoy = false;

  @override
  bool build() {
    final running = ref.watch(locationSharingProvider).running;
    void sync() => state = running.value && !_decoy;
    running.addListener(sync);
    ref.onDispose(() => running.removeListener(sync));
    return running.value && !_decoy;
  }

  bool get paused => _decoy || _sharing.paused;

  Future<void> startIfAllowed() => _sharing.start();

  Future<bool> resume() async {
    _decoy = false;
    _sharing.paused = false;
    await _sharing.start(userInitiated: true);
    state = _sharing.isRunning;
    return _sharing.isRunning;
  }

  /// Looks exactly like [pause] on this phone, but keeps sharing.
  void pauseUnderDuress() {
    _decoy = true;
    state = false;
  }

  Future<void> pause() async {
    _sharing.paused = true;
    await _sharing.stop();
  }
}
