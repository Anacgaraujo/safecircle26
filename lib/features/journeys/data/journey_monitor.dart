import 'dart:async';

import 'package:flutter/foundation.dart' show debugPrint, visibleForTesting;

import 'package:safecircle/features/journeys/domain/journey.dart';
import 'package:safecircle/core/data/repositories.dart';
import 'package:safecircle/features/journeys/data/journey_repository.dart';
import 'package:safecircle/core/location/location_service.dart';

class JourneyMonitor {
  JourneyMonitor({JourneyRepository? journeys, Future<ScLocation?> Function()? locate})
      : _journeys = journeys,
        _locate = locate ?? LocationService.instance.getCurrent;
  static final JourneyMonitor instance = JourneyMonitor();

  final JourneyRepository? _journeys;
  final Future<ScLocation?> Function() _locate;

  JourneyRepository get _repo => _journeys ?? Repositories.instance.journeys;

  StreamSubscription<Journey?>? _sub;
  Timer? _checkClock;
  Timer? _positionClock;
  Journey? _mine;
  bool _raising = false;

  bool get isRunning => _sub != null;

  void start() {
    if (_sub != null) return;
    _sub = _repo.myActiveJourneyStream().listen((j) {
      _mine = j;
      _check();
    }, onError: (e) => debugPrint('[SafeCircle] my journey stream: $e'));
    _checkClock = Timer.periodic(const Duration(seconds: 30), (_) => _check());
    _positionClock = Timer.periodic(const Duration(seconds: 60), (_) => _sharePosition());
  }

  void stop() {
    _sub?.cancel();
    _sub = null;
    _checkClock?.cancel();
    _positionClock?.cancel();
    _mine = null;
  }

  @visibleForTesting
  Future<void> checkNow() => _check();

  Future<void> _check() async {
    final j = _mine;
    if (j == null || _raising) return;
    final missed = j.missedCheckIn(DateTime.now());
    if (missed == null) return;
    _raising = true;
    try {
      final loc = await _locate();
      await _repo.raiseOverdueOnJourney(j, missed, location: loc);
    } catch (e) {
      debugPrint('[SafeCircle] raiseOverdue: $e');
    } finally {
      _raising = false;
    }
  }

  Future<void> _sharePosition() async {
    final j = _mine;
    if (j == null) return;
    try {
      final loc = await _locate();
      if (loc != null) await _repo.updateJourneyLocation(j.id, loc);
    } catch (e) {
      debugPrint('[SafeCircle] live position: $e');
    }
  }
}
