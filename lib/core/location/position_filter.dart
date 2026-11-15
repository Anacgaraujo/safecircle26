import 'dart:math' as math;

class GeoFix {
  const GeoFix(this.lat, this.lng, this.accuracy, this.at, {this.speedMps = 0});
  final double lat;
  final double lng;

  final double accuracy;
  final DateTime at;

  final double speedMps;
}

double metersBetween(double lat1, double lng1, double lat2, double lng2) {
  const r = 6371000.0;
  double rad(double d) => d * math.pi / 180;
  final dLat = rad(lat2 - lat1);
  final dLng = rad(lng2 - lng1);
  final a = math.pow(math.sin(dLat / 2), 2) +
      math.cos(rad(lat1)) * math.cos(rad(lat2)) * math.pow(math.sin(dLng / 2), 2);
  return 2 * r * math.asin(math.sqrt(a));
}

class StableFix {
  const StableFix(this.fix, {required this.moved});
  final GeoFix fix;

  final bool moved;
}

class PositionStabilizer {
  static const coarseAccuracy = 100.0;

  static const trustWindow = Duration(minutes: 2);

  static const maxSpeedKmh = 200.0;

  GeoFix? _anchor;

  GeoFix? _candidate;
  int _chain = 0;

  DateTime? _movingUntil;

  StableFix? accept(GeoFix f) {
    final a = _anchor;
    if (a == null) {
      _anchor = f;
      return StableFix(f, moved: false);
    }
    final age = f.at.difference(a.at);
    final recent = age < trustWindow;
    final d = metersBetween(a.lat, a.lng, f.lat, f.lng);

    final muchBetter = f.accuracy * 2 < a.accuracy;
    if (!muchBetter && recent) {
      if (f.accuracy > coarseAccuracy && a.accuracy <= coarseAccuracy) return null;
      final secs = math.max(1, age.inSeconds);
      if (d / secs * 3.6 > maxSpeedKmh) return null;
      if (f.accuracy > 50 && f.accuracy > a.accuracy * 1.5) return StableFix(a, moved: false);
    }

    final noise = math.max(40.0, f.accuracy + a.accuracy);
    if (!muchBetter && d < noise) {
      final k = (0.25 * a.accuracy / (a.accuracy + f.accuracy)).clamp(0.05, 0.25);
      _anchor = GeoFix(a.lat + (f.lat - a.lat) * k, a.lng + (f.lng - a.lng) * k,
          math.min(a.accuracy, f.accuracy), f.at);
      _candidate = null;
      _chain = 0;
      return StableFix(_anchor!, moved: false);
    }

    final moving = _movingUntil != null && f.at.isBefore(_movingUntil!);
    final c = _candidate;
    final onward = c != null &&
        f.at.difference(c.at) < trustWindow &&
        metersBetween(a.lat, a.lng, c.lat, c.lng) < d &&
        metersBetween(c.lat, c.lng, f.lat, f.lng) < d;
    _chain = onward ? _chain + 1 : 1;
    if (moving || muchBetter || f.speedMps > 2 || _chain >= 3) {
      _anchor = f;
      _candidate = null;
      _chain = 0;
      _movingUntil = f.at.add(const Duration(minutes: 1));
      return StableFix(f, moved: true);
    }
    _candidate = f;
    return StableFix(a, moved: false);
  }
}

class PlaceArea {
  const PlaceArea(this.id, this.lat, this.lng, this.radiusM);
  final String id;
  final double lat;
  final double lng;
  final double radiusM;
}

class GeofenceTracker {
  static const confirmAfter = Duration(minutes: 2);
  static const cooldown = Duration(minutes: 5);

  final Map<String, bool> _inside = {};
  final Map<String, DateTime> _crossingSince = {};
  final Map<String, DateTime> _lastEvent = {};

  bool? isInside(String placeId) => _inside[placeId];

  Map<String, bool> update(GeoFix f, Iterable<PlaceArea> places, DateTime now) {
    final out = <String, bool>{};
    final usable = f.accuracy.isFinite && f.accuracy <= PositionStabilizer.coarseAccuracy;
    for (final place in places) {
      final d = metersBetween(f.lat, f.lng, place.lat, place.lng);
      final was = _inside[place.id];
      if (was == null) {
        if (usable) _inside[place.id] = d <= place.radiusM;
        continue;
      }
      if (!usable) continue;
      final margin = math.max(25.0, place.radiusM * .15);
      final crossed = was
          ? d - f.accuracy > place.radiusM + margin
          : d + f.accuracy / 2 < place.radiusM;
      if (!crossed) {
        _crossingSince.remove(place.id);
        continue;
      }
      final since = _crossingSince.putIfAbsent(place.id, () => now);
      if (now.difference(since) < confirmAfter) continue;
      _crossingSince.remove(place.id);
      _inside[place.id] = !was;
      final last = _lastEvent[place.id];
      if (last != null && now.difference(last) < cooldown) continue;
      _lastEvent[place.id] = now;
      out[place.id] = !was;
    }
    return out;
  }
}
