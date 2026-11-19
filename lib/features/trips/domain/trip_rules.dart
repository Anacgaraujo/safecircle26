import 'dart:math' as math;

import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import 'package:safecircle/core/utils/formatters.dart';
import 'package:safecircle/features/live_map/domain/tracking.dart';

DateTime weekStart(int weeksAgo, {DateTime? now}) {
  final n = now ?? DateTime.now();
  final monday = DateTime(n.year, n.month, n.day).subtract(Duration(days: n.weekday - 1));
  return monday.subtract(Duration(days: 7 * weeksAgo));
}

/// Short weekday name in the phone's language: "Mon", "seg.", "周一"…
String weekdayName(DateTime d) => scFormat(DateFormat.E, d);

String tripDayLabel(DateTime d) => '${weekdayName(d)} · ${shortDate(d)}';

/// "Nov 16", "16 de nov."…
String shortDate(DateTime d) => scFormat(DateFormat.MMMd, d);

class TripWeek {
  TripWeek(this.all, {this.onlyOverLimit = false});

  final List<Trip> all;
  final bool onlyOverLimit;

  List<Trip> get shown => onlyOverLimit ? all.where((t) => t.overLimit).toList() : all;
  double get totalKm => all.fold<double>(0, (a, t) => a + t.km);
  double get topKmh => all.fold<double>(0, (a, t) => math.max(a, t.maxSpeedKmh));
  int get overLimitCount => all.where((t) => t.overLimit).length;

  Map<String, List<Trip>> get byDay {
    final out = <String, List<Trip>>{};
    for (final t in shown) {
      out.putIfAbsent(tripDayLabel(t.start), () => []).add(t);
    }
    return out;
  }
}

class TripPath {
  TripPath(this.points) : _lengths = _cumulative(points);

  final List<TripPoint> points;

  final List<double> _lengths;

  static List<double> _cumulative(List<TripPoint> points) {
    final out = <double>[0];
    for (var i = 1; i < points.length; i++) {
      final dx = points[i].lng - points[i - 1].lng;
      final dy = points[i].lat - points[i - 1].lat;
      out.add(out[i - 1] + math.sqrt(dx * dx + dy * dy));
    }
    return out;
  }

  LatLng positionAt(double t) {
    if (points.isEmpty) return const LatLng(0, 0);
    final first = LatLng(points.first.lat, points.first.lng);
    if (points.length == 1 || _lengths.last <= 0) return first;
    final d = t * _lengths.last;
    for (var i = 1; i < points.length; i++) {
      if (d <= _lengths[i]) {
        final seg = _lengths[i] - _lengths[i - 1];
        final f = seg == 0 ? 0.0 : (d - _lengths[i - 1]) / seg;
        return LatLng(
          points[i - 1].lat + (points[i].lat - points[i - 1].lat) * f,
          points[i - 1].lng + (points[i].lng - points[i - 1].lng) * f,
        );
      }
    }
    return LatLng(points.last.lat, points.last.lng);
  }

  double speedAt(double t) {
    if (points.isEmpty) return 0;
    final i = (t * (points.length - 1)).round().clamp(0, points.length - 1);
    return points[i].speedKmh;
  }

  int passedIndex(double t) {
    if (points.isEmpty) return 0;
    return (t * (points.length - 1)).floor().clamp(0, points.length - 1);
  }
}
