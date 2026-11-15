import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/location/location_service.dart';
import 'package:safecircle/features/alerts/data/alert_repository.dart';

final sosServiceProvider = Provider<SosService>((ref) => SosService(
      ref.watch(alertRepositoryProvider),
      locate: LocationService.instance.getCurrent,
    ));

class SosService {
  SosService(this._alerts, {required this.locate});

  final AlertRepository _alerts;
  final Future<ScLocation?> Function() locate;

  Future<ScLocation?> currentPosition() => locate();

  Future<int> send(ScLocation? location) => _alerts.fireSos(location: location);

  Future<void> cancel() => _alerts.resolveMyAlerts(types: const {'sos'});

  Future<void> setResolved(String alertId, bool resolved) =>
      _alerts.resolveAlert(alertId, resolved: resolved);
}
