import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ScCameraGlide {
  ScCameraGlide(TickerProvider vsync, this.map)
      : _anim = AnimationController(vsync: vsync, duration: const Duration(milliseconds: 700));

  final MapController map;
  final AnimationController _anim;
  VoidCallback? _step;

  void to(LatLng point, double zoom, {Offset offset = Offset.zero}) {
    final cam = map.camera;
    final target = offset == Offset.zero
        ? point
        : cam.unprojectAtZoom(cam.projectAtZoom(point, zoom) - offset, zoom);
    final from = cam.center;
    final fromZoom = cam.zoom;
    stop();
    if (const Distance().as(LengthUnit.Kilometer, from, target) > 50) {
      map.move(target, zoom);
      return;
    }
    final curve = CurvedAnimation(parent: _anim, curve: Curves.easeInOutCubic);
    _step = () {
      final t = curve.value;
      map.move(
        LatLng(from.latitude + (target.latitude - from.latitude) * t,
            from.longitude + (target.longitude - from.longitude) * t),
        fromZoom + (zoom - fromZoom) * t,
      );
    };
    _anim
      ..addListener(_step!)
      ..forward(from: 0);
  }

  void stop() {
    _anim.stop();
    if (_step != null) _anim.removeListener(_step!);
    _step = null;
  }

  void dispose() {
    stop();
    _anim.dispose();
  }
}
