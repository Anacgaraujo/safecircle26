import 'package:flutter/material.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/sc_camera.dart';
import 'package:safecircle/core/widgets/sc_tiles.dart';
import 'package:safecircle/l10n/l10n.dart';

class ScMapView extends StatefulWidget {
  const ScMapView({
    super.key,
    this.lat,
    this.lng,
    this.pinColor = ScColors.brand,
    this.pinIcon = FeatherIcons.mapPin,
    this.interactive = false,
    this.attributionAlignment = Alignment.bottomLeft,
  });

  final double? lat;
  final double? lng;
  final Color pinColor;
  final IconData pinIcon;
  final bool interactive;

  final Alignment attributionAlignment;

  @override
  State<ScMapView> createState() => _ScMapViewState();
}

class _ScMapViewState extends State<ScMapView> with SingleTickerProviderStateMixin {
  final _map = MapController();
  late final _glide = ScCameraGlide(this, _map);
  bool _ready = false;

  @override
  void didUpdateWidget(ScMapView old) {
    super.didUpdateWidget(old);
    final lat = widget.lat, lng = widget.lng;
    if (!_ready || lat == null || lng == null) return;
    final here = LatLng(lat, lng);
    if (const Distance().as(LengthUnit.Meter, _map.camera.center, here) > 25) {
      _glide.to(here, _map.camera.zoom);
    }
  }

  @override
  void dispose() {
    _glide.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lat = widget.lat, lng = widget.lng;
    final pinColor = widget.pinColor, pinIcon = widget.pinIcon;
    if (lat == null || lng == null) {
      _ready = false;
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/map-sf.png', fit: BoxFit.cover),
          Container(
            color: Colors.white.withValues(alpha: .55),
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .95),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(context.l10n.locationNotSharedYet,
                  style: ScText.sans(size: 12.5, weight: FontWeight.w700, color: ScColors.textSecondary)),
            ),
          ),
        ],
      );
    }

    return FlutterMap(
      mapController: _map,
      options: MapOptions(
        backgroundColor: kMapBackground,
        initialCenter: LatLng(lat, lng),
        initialZoom: 15.5,
        onMapReady: () => _ready = true,
        interactionOptions: InteractionOptions(
          flags: widget.interactive ? InteractiveFlag.all : InteractiveFlag.none,
        ),
      ),
      children: [
        scTileLayer(),
        scMapAttribution(alignment: widget.attributionAlignment),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(lat, lng),
              width: 44,
              height: 52,
              alignment: Alignment.topCenter,
              child: ScMapPin(color: pinColor, icon: pinIcon),
            ),
          ],
        ),
      ],
    );
  }
}

class ScMapPin extends StatelessWidget {
  const ScMapPin({super.key, required this.color, this.icon = FeatherIcons.mapPin, this.size = 40});
  final Color color;
  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.785398,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(size / 2),
            topRight: Radius.circular(size / 2),
            bottomRight: Radius.circular(size / 2),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: .4),
                offset: const Offset(0, 8),
                blurRadius: 18,
                spreadRadius: -4),
          ],
        ),
        child: Transform.rotate(
          angle: 0.785398,
          child: Icon(icon, size: size * .45, color: Colors.white),
        ),
      ),
    );
  }
}

class ScMapPinSmall extends StatelessWidget {
  const ScMapPinSmall({super.key, this.icon = FeatherIcons.mapPin});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: ScColors.brand,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: ScShadows.card,
      ),
      child: Icon(icon, size: 15, color: Colors.white),
    );
  }
}
