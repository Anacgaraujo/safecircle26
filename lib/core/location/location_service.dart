import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class ScLocation {
  const ScLocation({required this.lat, required this.lng, required this.label});
  final double lat;
  final double lng;
  final String label;
}

class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();

  Future<bool> hasPermission() async {
    try {
      final p = await Geolocator.checkPermission();
      return p == LocationPermission.always || p == LocationPermission.whileInUse;
    } catch (_) {
      return false;
    }
  }

  Future<bool> ensurePermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;
    var p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) {
      p = await Geolocator.requestPermission();
    }
    return p == LocationPermission.always || p == LocationPermission.whileInUse;
  }

  Future<ScLocation?> getCurrent() async {
    try {
      if (!await ensurePermission()) return null;
      Position? last;
      if (!kIsWeb) {
        try {
          last = await Geolocator.getLastKnownPosition();
        } catch (_) {}
      }
      Position? pos;
      if (last != null &&
          DateTime.now().difference(last.timestamp) < const Duration(minutes: 2)) {
        pos = last;
      } else {
        try {
          pos = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              timeLimit: Duration(seconds: 10),
            ),
          );
        } catch (_) {
          pos = last;
        }
      }
      if (pos == null) return null;
      return ScLocation(
        lat: pos.latitude,
        lng: pos.longitude,
        label: await _label(pos.latitude, pos.longitude),
      );
    } catch (_) {
      return null;
    }
  }

  Future<String> labelFor(ScLocation loc) => _label(loc.lat, loc.lng);

  /// Places matching a typed address, best match first (at most 5).
  Future<List<ScLocation>> search(String address) async {
    final q = address.trim();
    if (q.isEmpty || kIsWeb) return const [];
    try {
      final found = await locationFromAddress(q).timeout(const Duration(seconds: 8));
      final results = <ScLocation>[];
      for (final f in found.take(5)) {
        results.add(ScLocation(
          lat: f.latitude,
          lng: f.longitude,
          label: await _addressLabel(f.latitude, f.longitude, fallback: q),
        ));
      }
      return results;
    } catch (_) {
      // Not found, or the phone's geocoder is unavailable.
      return const [];
    }
  }

  /// A full street address for search results ("12 Main St, Springfield, NJ").
  Future<String> _addressLabel(double lat, double lng, {required String fallback}) async {
    try {
      final marks = await placemarkFromCoordinates(lat, lng).timeout(const Duration(seconds: 4));
      if (marks.isNotEmpty) {
        final p = marks.first;
        final parts = <String>{
          if ((p.street ?? '').isNotEmpty) p.street! else if ((p.name ?? '').isNotEmpty) p.name!,
          if ((p.locality ?? '').isNotEmpty) p.locality!,
          if ((p.administrativeArea ?? '').isNotEmpty) p.administrativeArea!,
        };
        if (parts.isNotEmpty) return parts.join(', ');
      }
    } catch (_) {}
    return fallback;
  }

  Future<String> _label(double lat, double lng) async {
    if (kIsWeb) return '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
    try {
      final placemarks =
          await placemarkFromCoordinates(lat, lng).timeout(const Duration(seconds: 4));
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final parts = <String>[
          if ((p.thoroughfare ?? '').isNotEmpty) p.thoroughfare!,
          if ((p.subLocality ?? '').isNotEmpty)
            p.subLocality!
          else if ((p.locality ?? '').isNotEmpty)
            p.locality!,
        ];
        if (parts.isNotEmpty) return parts.join(' · ');
      }
    } catch (_) {}
    return '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
  }
}
