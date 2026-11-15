import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

const kMapTilerKey = String.fromEnvironment('MAPTILER_KEY');

const kMapTileUrl = String.fromEnvironment(
  'MAP_TILE_URL',
  defaultValue: kMapTilerKey == ''
      ? 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
      : 'https://api.maptiler.com/maps/streets-v2/256/{z}/{x}/{y}@2x.png?key=$kMapTilerKey',
);

const kMapAttribution = String.fromEnvironment(
  'MAP_ATTRIBUTION',
  defaultValue: kMapTilerKey == ''
      ? '© OpenStreetMap contributors'
      : '© MapTiler © OpenStreetMap contributors',
);

const kMapBackground = Color(0xFFF2EFE9);

TileLayer scTileLayer() => TileLayer(
      urlTemplate: kMapTileUrl,
      userAgentPackageName: 'app.safecircle',
      keepBuffer: 1,
      panBuffer: 0,
      evictErrorTileStrategy: EvictErrorTileStrategy.notVisibleRespectMargin,
    );

const kMapMinZoom = 2.0;
const kMapMaxZoom = 19.0;

final kWorldConstraint = CameraConstraint.contain(
  bounds: LatLngBounds(const LatLng(-85, -180), const LatLng(85, 180)),
);

Widget scMapAttribution({Alignment alignment = Alignment.bottomLeft}) => Align(
      alignment: alignment,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        color: const Color(0xB3FFFFFF),
        child: const Text(kMapAttribution,
            style: TextStyle(fontSize: 10, color: Color(0xFF5E5A6B))),
      ),
    );
