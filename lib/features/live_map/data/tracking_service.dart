import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/live_map/domain/location_sharing.dart';
import 'package:safecircle/features/live_map/domain/tracking.dart';
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/features/live_map/data/background_service.dart';
import 'package:safecircle/core/data/repositories.dart';
import 'package:safecircle/core/location/location_service.dart';
import 'package:safecircle/core/location/position_filter.dart';
import 'package:safecircle/core/notifications/notification_service.dart';

class TrackingService implements LocationSharing {
  TrackingService._();
  static final TrackingService instance = TrackingService._();

  Repositories get _repo => Repositories.instance;
  final _battery = Battery();

  StreamSubscription<Position>? _positions;
  Timer? _heartbeat;

  List<String> _viewers = const [];
  StreamSubscription<List<Circle>>? _circlesSub;

  List<Place> _places = const [];
  StreamSubscription<List<Place>>? _placesSub;
  bool _seededGeofences = false;

  final _stabilizer = PositionStabilizer();
  final _geofences = GeofenceTracker();

  final List<TripPoint> _trip = [];
  Position? _lastStop;
  DateTime? _stoppedAt;

  DateTime? _lastMoveAt;
  DateTime? _since;
  double _tripMeters = 0;
  double _tripTopKmh = 0;
  String _tripFrom = '';
  int _tripsToday = 0;
  double _metersToday = 0;

  bool _running = false;
  @override
  bool get isRunning => _running;

  bool inBackgroundIsolate = false;
  bool get _delegates => backgroundServiceSupported && !inBackgroundIsolate;

  @override
  bool paused = false;

  @override
  final ValueNotifier<bool> running = ValueNotifier(false);

  DateTime? _lastPublish;

  Position? _prevFix;

  DateTime? lastFixAt;
  final DateTime _createdAt = DateTime.now();
  Duration get uptime => DateTime.now().difference(_createdAt);
  int _lastBattery = -1;
  bool _lowBatteryWarned = false;

  @override
  Future<void> start({bool userInitiated = false}) {
    return _starting ??= _start(userInitiated: userInitiated)
        .whenComplete(() => _starting = null);
  }

  Future<void>? _starting;

  Future<void> _start({required bool userInitiated}) async {
    if (_running) return;
    if (!await LocationService.instance.hasPermission()) return;
    try {
      final mine = await _repo.status.myStatus();
      if (!userInitiated && mine != null && !mine.sharing) paused = true;
      if (mine != null && !mine.moving && mine.since != null) _since ??= mine.since;
    } catch (_) {}
    if (paused) return;
    _running = true;
    running.value = true;

    if (_delegates) {
      if (userInitiated) {
        try {
          await _repo.status.setSharing(true);
        } catch (_) {}
      }
      await BackgroundLocationService.start();
      return;
    }

    _viewers = await _safePeers();
    _circlesSub = _repo.circles.myCirclesStream().listen((circles) {
      final ids = <String>{Session.instance.uid};
      for (final c in circles) {
        ids.addAll(c.memberIds);
      }
      final next = ids.toList()..sort();
      final current = List<String>.from(_viewers)..sort();
      if (next.join(',') == current.join(',')) return;
      _viewers = next;
      _lastPublish = null;
      _tick();
    }, onError: (e) => debugPrint('[SafeCircle] circles stream: $e'));
    _placesSub = _repo.places.placesStream().listen((p) => _places = p,
        onError: (e) => debugPrint('[SafeCircle] places stream: $e'));

    final totals = await _safeTotals();
    _tripsToday = totals.$1;
    _metersToday = totals.$2;

    if (!_listen()) {
      _running = false;
      running.value = false;
      return;
    }
    _heartbeat = Timer.periodic(const Duration(minutes: 1), (_) => _tick());
    await _tick();
  }

  bool _listen() {
    try {
      _positions = Geolocator.getPositionStream(locationSettings: _settings()).listen(
        _onPosition,
        onError: (e) => debugPrint('[SafeCircle] position stream: $e'),
        onDone: () => _positions = null,
      );
      return true;
    } catch (e) {
      debugPrint('[SafeCircle] could not start the position stream: $e');
      return false;
    }
  }

  @override
  Future<void> stop({bool markPaused = true}) async {
    _running = false;
    running.value = false;
    if (_delegates) {
      BackgroundLocationService.stop();
      if (markPaused) {
        try {
          await _repo.status.setSharing(false);
        } catch (e) {
          debugPrint('[SafeCircle] setSharing: $e');
        }
      }
      return;
    }
    await _positions?.cancel();
    await _placesSub?.cancel();
    _positions = null;
    _placesSub = null;
    _heartbeat?.cancel();
    await _circlesSub?.cancel();
    _circlesSub = null;
    if (markPaused) {
      try {
        await _repo.status.setSharing(false);
      } catch (e) {
        debugPrint('[SafeCircle] setSharing: $e');
      }
    }
  }

  LocationSettings _settings() {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 25,
        intervalDuration: const Duration(seconds: 15),
      );
    }
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      return AppleSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 25,
        pauseLocationUpdatesAutomatically: true,
        showBackgroundLocationIndicator: true,
      );
    }
    return const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 25);
  }

  Future<List<String>> _safePeers() async {
    try {
      return await _repo.circles.circlePeers();
    } catch (e) {
      debugPrint('[SafeCircle] circlePeers: $e');
      return _viewers.isEmpty ? [Session.instance.uid] : _viewers;
    }
  }

  Future<(int, double)> _safeTotals() async {
    try {
      return await _repo.trips.todayTotals(Session.instance.uid);
    } catch (e) {
      debugPrint('[SafeCircle] todayTotals: $e');
      return (0, .0);
    }
  }

  Future<void> _tick() async {
    if (!_running) return;
    if (_positions == null) _listen();
    try {
      final p = await Geolocator.getLastKnownPosition();
      if (p != null) await _onPosition(p, heartbeat: true);
    } catch (e) {
      debugPrint('[SafeCircle] heartbeat: $e');
    }
  }

  Future<void> _onPosition(Position raw, {bool heartbeat = false}) async {
    if (!_running || paused) return;
    final now = DateTime.now();
    if (!heartbeat) lastFixAt = now;
    final fresh = !heartbeat || now.difference(raw.timestamp).inSeconds < 30;
    final stable = _stabilizer.accept(GeoFix(raw.latitude, raw.longitude, raw.accuracy,
        raw.timestamp, speedMps: fresh && raw.speed.isFinite ? raw.speed : 0));
    if (stable == null) return;
    final p = _withPosition(raw, stable.fix);
    var speedKmh = fresh ? (p.speed.isFinite && p.speed > 0 ? p.speed : 0) * 3.6 : 0.0;
    final prev = _prevFix;
    if (fresh && speedKmh == 0 && prev != null && p.accuracy <= 50) {
      final secs = p.timestamp.difference(prev.timestamp).inMilliseconds / 1000;
      if (secs >= 1 && secs <= 60) {
        final meters = Geolocator.distanceBetween(
            prev.latitude, prev.longitude, p.latitude, p.longitude);
        final derived = meters / secs * 3.6;
        if (derived < 250) speedKmh = derived;
      }
    }
    if (fresh) _prevFix = p;
    if (!stable.moved) speedKmh = 0;
    final moving = speedKmh > 5.4 && p.accuracy <= 50;

    await _updateTrip(p, now, moving: moving, speedKmh: speedKmh);
    await _evaluateGeofences(p, now);

    final onTheMove = moving || _trip.isNotEmpty;

    final gap = onTheMove ? const Duration(seconds: 30) : const Duration(minutes: 5);
    if (_lastPublish != null && now.difference(_lastPublish!) < gap) return;
    _lastPublish = now;

    final battery = await _batteryLevel();
    final charging = await _isCharging();
    await _warnLowBattery(battery, charging);

    final place = _placeAt(p)?.name ?? await _label(p);
    try {
      await _repo.status.publishStatus(
        viewerIds: _viewers,
        lat: p.latitude,
        lng: p.longitude,
        place: place,
        moving: onTheMove,
        speedKmh: speedKmh,
        battery: battery,
        charging: charging,
        sharing: true,
        since: onTheMove ? null : (_since ??= now),
        tripsToday: _tripsToday,
        metersToday: _metersToday,
      );
    } catch (e) {
      debugPrint('[SafeCircle] publishStatus: $e');
    }
  }

  Future<String> _label(Position p) async {
    final loc = ScLocation(lat: p.latitude, lng: p.longitude, label: '');
    return LocationService.instance.labelFor(loc);
  }

  Future<int> _batteryLevel() async {
    try {
      return await _battery.batteryLevel;
    } catch (_) {
      return -1;
    }
  }

  Future<bool> _isCharging() async {
    try {
      final s = await _battery.batteryState;
      return s == BatteryState.charging || s == BatteryState.full;
    } catch (_) {
      return false;
    }
  }

  Future<void> _warnLowBattery(int level, bool charging) async {
    if (level < 0) return;
    if (level > 20 || charging) {
      _lowBatteryWarned = false;
      _lastBattery = level;
      return;
    }
    if (_lowBatteryWarned || _lastBattery >= 0 && _lastBattery <= 20) {
      _lastBattery = level;
      return;
    }
    _lastBattery = level;
    _lowBatteryWarned = true;
    try {
      await _repo.activity.logActivity(type: 'lowBattery', viewerIds: _viewers, detail: '$level%');
    } catch (e) {
      debugPrint('[SafeCircle] low battery event: $e');
    }
  }

  Place? _placeAt(Position p) {
    for (final place in _places) {
      if (!place.enabled) continue;
      final d = Geolocator.distanceBetween(p.latitude, p.longitude, place.lat, place.lng);
      if (d <= place.radiusM) return place;
    }
    return null;
  }

  Position _withPosition(Position raw, GeoFix f) => Position(
        latitude: f.lat,
        longitude: f.lng,
        timestamp: raw.timestamp,
        accuracy: raw.accuracy,
        altitude: raw.altitude,
        altitudeAccuracy: raw.altitudeAccuracy,
        heading: raw.heading,
        headingAccuracy: raw.headingAccuracy,
        speed: raw.speed,
        speedAccuracy: raw.speedAccuracy,
        floor: raw.floor,
        isMocked: raw.isMocked,
      );

  Future<void> _evaluateGeofences(Position p, DateTime now) async {
    final me = Session.instance.uid;
    final mine = [
      for (final place in _places)
        if (place.id != null && (place.memberIds.isEmpty || place.memberIds.contains(me)))
          place,
    ];
    final crossings = _geofences.update(
      GeoFix(p.latitude, p.longitude, p.accuracy, p.timestamp),
      [for (final place in mine) PlaceArea(place.id!, place.lat, place.lng, place.radiusM)],
      now,
    );
    final report = _seededGeofences;
    _seededGeofences = true;
    if (!report) return;
    for (final place in mine) {
      final isIn = crossings[place.id];
      if (isIn == null || !place.enabled) continue;
      if (isIn && !place.notifyArrive) continue;
      if (!isIn && !place.notifyLeave) continue;
      try {
        await _repo.activity.logActivity(
          type: isIn ? 'arrive' : 'leave',
          viewerIds: place.viewerIds.isEmpty ? _viewers : place.viewerIds,
          placeName: place.name,
        );
      } catch (e) {
        debugPrint('[SafeCircle] geofence event: $e');
      }
    }
  }

  Future<void> _updateTrip(Position p, DateTime now,
      {required bool moving, required double speedKmh}) async {
    final point = TripPoint(
      lat: p.latitude,
      lng: p.longitude,
      atMillis: now.millisecondsSinceEpoch,
      speedKmh: speedKmh,
    );

    if (_trip.isEmpty) {
      final from = _lastStop;
      final away = from == null
          ? 0.0
          : Geolocator.distanceBetween(from.latitude, from.longitude, p.latitude, p.longitude);
      if (from == null) {
        _lastStop = p;
        _since ??= now;
        _tripFrom = _placeAt(p)?.name ?? await _label(p);
        return;
      }
      if (away < kTripStartRadiusM) return;
      _trip
        ..clear()
        ..add(TripPoint(
          lat: from.latitude,
          lng: from.longitude,
          atMillis: (_stoppedAt ?? now).millisecondsSinceEpoch,
        ))
        ..add(point);
      _tripMeters = away;
      _tripTopKmh = speedKmh;
      _since = null;
      _stoppedAt = null;
      _lastMoveAt = now;
      return;
    }

    final last = _trip.last;
    final step =
        Geolocator.distanceBetween(last.lat, last.lng, p.latitude, p.longitude);
    if (step >= 15) {
      _trip.add(point);
      _tripMeters += step;
    }
    if (speedKmh > _tripTopKmh) _tripTopKmh = speedKmh;

    if (moving || step >= 100) {
      _lastMoveAt = now;
      return;
    }
    final stillSince = _lastMoveAt ?? now;
    if (now.difference(stillSince) >= kTripStopAfter) {
      await _closeTrip(p, stillSince);
    }
  }

  Future<void> _closeTrip(Position p, DateTime arrivedAt) async {
    final points = List<TripPoint>.from(_trip);
    final meters = _tripMeters;
    final top = _tripTopKmh;
    final from = _tripFrom;
    _trip.clear();
    _tripMeters = 0;
    _tripTopKmh = 0;
    _lastStop = p;
    _stoppedAt = arrivedAt;
    _lastMoveAt = null;
    _since = arrivedAt;

    if (points.length < 3 || meters < 300) {
      _tripFrom = _placeAt(p)?.name ?? await _label(p);
      return;
    }

    final to = _placeAt(p)?.name ?? await _label(p);
    final trip = Trip(
      id: '',
      userId: Session.instance.uid,
      userName: Session.instance.userName,
      points: points,
      startMillis: points.first.atMillis,
      endMillis: arrivedAt.millisecondsSinceEpoch,
      fromLabel: from,
      toLabel: to,
      distanceM: meters,
      maxSpeedKmh: top,
    );
    _tripFrom = to;
    _tripsToday += 1;
    _metersToday += meters;
    _lastPublish = null;
    try {
      await _repo.trips.saveTrip(trip, viewerIds: _viewers);
      if (top > kSpeedLimitKmh) {
        await NotificationService.instance.notifyTripRisk(trip);
      }
    } catch (e) {
      debugPrint('[SafeCircle] saveTrip: $e');
    }
  }
}
