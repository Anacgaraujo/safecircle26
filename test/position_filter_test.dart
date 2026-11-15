import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:safecircle/core/location/position_filter.dart';

const homeLat = 40.6782;
const homeLng = -73.9442;
const home = PlaceArea('home', homeLat, homeLng, 250);

GeoFix fixAt(double north, double east, double accuracy, DateTime at) {
  final dLat = north / 111320;
  final dLng = east / (111320 * math.cos(homeLat * math.pi / 180));
  return GeoFix(homeLat + dLat, homeLng + dLng, accuracy, at);
}

void main() {
  final t0 = DateTime(2026, 10, 21, 9);

  group('phone sitting at home for an hour', () {
    List<GeoFix> hour([int seed = 7]) {
      final rnd = math.Random(seed);
      final fixes = <GeoFix>[];
      for (var i = 0; i < 120; i++) {
        final at = t0.add(Duration(seconds: 30 * i));
        if (i % 10 == 5) {
          final d = 400 + rnd.nextDouble() * 200;
          final angle = rnd.nextDouble() * 2 * math.pi;
          fixes.add(fixAt(d * math.sin(angle), d * math.cos(angle), 60 + rnd.nextDouble() * 30, at));
          if (i % 20 == 5) {
            fixes.add(fixAt(900, -700, 800, at.add(const Duration(seconds: 5))));
          }
        } else {
          fixes.add(fixAt(rnd.nextDouble() * 60 - 30, rnd.nextDouble() * 60 - 30,
              12 + rnd.nextDouble() * 20, at));
        }
      }
      return fixes;
    }

    test('the pin stays put', () {
      final s = PositionStabilizer();
      final first = s.accept(hour().first)!.fix;
      var moves = 0;
      var maxShift = 0.0;
      for (final f in hour().skip(1)) {
        final r = s.accept(f);
        if (r == null) continue;
        if (r.moved) moves++;
        maxShift = math.max(maxShift, metersBetween(first.lat, first.lng, r.fix.lat, r.fix.lng));
      }
      expect(moves, lessThanOrEqualTo(2), reason: 'standing still must not read as movement');
      expect(maxShift, lessThan(100), reason: 'the shown position must not wander');
    });

    test('no "left home" / "arrived home" events', () {
      final s = PositionStabilizer();
      final g = GeofenceTracker();
      final events = <bool>[];
      for (final f in hour()) {
        final r = s.accept(f);
        if (r == null) continue;
        events.addAll(g.update(r.fix, [home], f.at).values);
      }
      expect(events, isEmpty);
      expect(g.isInside('home'), isTrue);
    });

    test('holds for 30 different noise patterns', () {
      var worstMoves = 0;
      var worstShift = 0.0;
      for (var seed = 1; seed <= 30; seed++) {
        final s = PositionStabilizer();
        final g = GeofenceTracker();
        final fixes = hour(seed);
        final first = s.accept(fixes.first)!.fix;
        g.update(first, [home], fixes.first.at);
        var moves = 0;
        for (final f in fixes.skip(1)) {
          final r = s.accept(f);
          if (r == null) continue;
          if (r.moved) moves++;
          worstShift = math.max(worstShift, metersBetween(first.lat, first.lng, r.fix.lat, r.fix.lng));
          expect(g.update(r.fix, [home], f.at), isEmpty, reason: 'seed $seed: no place events');
        }
        worstMoves = math.max(worstMoves, moves);
      }
      // ignore: avoid_print
      print('30 hours at home: worst moves $worstMoves, worst shift ${worstShift.round()} m');
      expect(worstMoves, lessThanOrEqualTo(2));
      expect(worstShift, lessThan(100));
    });

    test('even unfiltered fixes no longer flap the place', () {
      final g = GeofenceTracker();
      final events = <bool>[];
      for (final f in hour()) {
        events.addAll(g.update(f, [home], f.at).values);
      }
      expect(events, isEmpty);
    });
  });

  group('really leaving and coming back', () {
    test('one "left" and one "arrived", and the pin follows', () {
      final s = PositionStabilizer();
      final g = GeofenceTracker();
      final events = <bool>[];
      var t = t0;
      void feed(GeoFix f) {
        final r = s.accept(f);
        if (r == null) return;
        events.addAll(g.update(r.fix, [home], f.at).values);
      }

      for (var i = 0; i < 10; i++) {
        t = t.add(const Duration(seconds: 30));
        feed(fixAt(5, -5, 15, t));
      }
      for (var m = 50.0; m <= 1000; m += 50) {
        t = t.add(const Duration(seconds: 36));
        feed(fixAt(m, 0, 12, t));
      }
      for (var i = 0; i < 10; i++) {
        t = t.add(const Duration(seconds: 30));
        feed(fixAt(1000, 0, 12, t));
      }
      expect(events, [false], reason: 'left home once');
      final shown = s.accept(fixAt(1000, 0, 12, t.add(const Duration(seconds: 30))))!.fix;
      expect(metersBetween(shown.lat, shown.lng, homeLat, homeLng), greaterThan(950));

      for (var m = 950.0; m >= 0; m -= 50) {
        t = t.add(const Duration(seconds: 36));
        feed(fixAt(m, 0, 12, t));
      }
      for (var i = 0; i < 10; i++) {
        t = t.add(const Duration(seconds: 30));
        feed(fixAt(0, 0, 12, t));
      }
      expect(events, [false, true], reason: 'then arrived once');
    });

    test('a quick drive is followed live', () {
      final s = PositionStabilizer();
      var t = t0;
      s.accept(fixAt(0, 0, 10, t));
      var moved = 0;
      for (var m = 150.0; m <= 3000; m += 150) {
        t = t.add(const Duration(seconds: 10));
        if (s.accept(fixAt(m, 0, 10, t))!.moved) moved++;
      }
      expect(moved, greaterThanOrEqualTo(18));
    });

    test('a drive with GPS speed is followed from the first fix', () {
      final s = PositionStabilizer();
      var t = t0;
      s.accept(fixAt(0, 0, 10, t));
      var moved = 0;
      for (var m = 150.0; m <= 3000; m += 150) {
        t = t.add(const Duration(seconds: 10));
        final f = fixAt(m, 0, 10, t);
        if (s.accept(GeoFix(f.lat, f.lng, f.accuracy, f.at, speedMps: 15))!.moved) moved++;
      }
      expect(moved, 20);
    });
  });
}
