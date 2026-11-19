import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Circle, Path;

import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/utils/formatters.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_tiles.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/live_map/domain/tracking.dart';
import 'package:safecircle/features/trips/domain/trip_rules.dart';
import 'package:safecircle/l10n/l10n.dart';

class TripReplayScreen extends StatefulWidget {
  const TripReplayScreen({super.key, required this.trip});
  final Trip trip;

  @override
  State<TripReplayScreen> createState() => _TripReplayScreenState();
}

class _TripReplayScreenState extends State<TripReplayScreen>
    with SingleTickerProviderStateMixin {
  static const _duration = Duration(seconds: 14);

  late final AnimationController _c =
      AnimationController(vsync: this, duration: _duration)..addListener(_onTick);
  double _rate = 1;

  late final _path = TripPath(widget.trip.points);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _c.forward());
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _onTick() {
    if (mounted) setState(() {});
  }

  void _seek(double t) {
    _c.stop();
    _c.value = t.clamp(0, 1);
    setState(() {});
  }

  void _toggle() {
    if (_c.isAnimating) {
      _c.stop();
    } else {
      if (_c.value >= 1) _c.value = 0;
      _c.forward();
    }
    setState(() {});
  }

  void _setRate(double r) {
    _rate = r;
    _c.duration = Duration(milliseconds: (_duration.inMilliseconds / r).round());
    if (_c.isAnimating) {
      _c.stop();
      _c.forward();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;
    final t = _c.value;
    final here = _path.positionAt(t);
    final done = <LatLng>[];
    for (final p in widget.trip.points) {
      done.add(LatLng(p.lat, p.lng));
    }
    final passedCount = _path.passedIndex(t);
    final passed = [...done.take(passedCount + 1), here];

    final elapsed = trip.startMillis + ((trip.endMillis - trip.startMillis) * t).round();
    final clock = scClock(DateTime.fromMillisecondsSinceEpoch(elapsed));
    final speed = _path.speedAt(t);

    return Scaffold(
      backgroundColor: ScColors.canvas,
      body: Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              options: MapOptions(
                backgroundColor: kMapBackground,
                minZoom: kMapMinZoom,
                cameraConstraint: kWorldConstraint,
                initialCenter: here,
                initialZoom: 15,
                initialCameraFit: done.length < 2
                    ? null
                    : CameraFit.bounds(
                        bounds: LatLngBounds.fromPoints(done),
                        padding: EdgeInsets.fromLTRB(
                            48, MediaQuery.of(context).padding.top + 80, 48, 380),
                        maxZoom: 17,
                      ),
                interactionOptions:
                    const InteractionOptions(flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
              ),
              children: [
                scTileLayer(),
        scMapAttribution(alignment: const Alignment(1, -0.78)),
                PolylineLayer(polylines: [
                  Polyline(
                      points: done,
                      strokeWidth: 9,
                      color: Colors.white.withValues(alpha: .9)),
                  Polyline(points: done, strokeWidth: 5, color: const Color(0xFFF9A8D4)),
                  if (passed.length > 1)
                    Polyline(points: passed, strokeWidth: 5, color: ScColors.brand),
                ]),
                MarkerLayer(markers: [
                  if (done.isNotEmpty)
                    Marker(
                      point: done.first,
                      width: 18,
                      height: 18,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: ScColors.brand, width: 3),
                        ),
                      ),
                    ),
                  if (done.isNotEmpty)
                    Marker(
                      point: done.last,
                      width: 24,
                      height: 24,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: ScColors.textHeading, shape: BoxShape.circle),
                        child: const Icon(FeatherIcons.flag, size: 12, color: Colors.white),
                      ),
                    ),
                  Marker(
                    point: here,
                    width: 44,
                    height: 44,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                          color: ScColors.brand, shape: BoxShape.circle),
                      child: ScAvatar(name: trip.userName, size: 34),
                    ),
                  ),
                ]),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            child: Row(
              children: [
                ScCircleIconButton(
                  icon: FeatherIcons.arrowLeft,
                  onTap: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .92),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: ScShadows.card,
                  ),
                  child: Text(context.l10n.replayOf(tripDayLabel(trip.start)),
                      style: ScText.sans(size: 13, weight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          Positioned(left: 0, right: 0, bottom: 0, child: _buildSheet(trip, t, clock, speed)),
        ],
      ),
    );
  }

  Widget _buildSheet(Trip trip, double t, String clock, double speed) {
    final events = trip.overLimitAt;
    return Container(
      padding: EdgeInsets.fromLTRB(22, 12, 22, 18 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: ScColors.canvas,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        boxShadow: [BoxShadow(color: Color(0x1F000000), offset: Offset(0, -8), blurRadius: 30)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(trip.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: ScText.sans(size: 19, weight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(
              context.l10n.tripSummaryTop(scClock(trip.start), scClock(trip.end), scDistance(trip.km), scSpeed(trip.maxSpeedKmh)),
              style: ScText.mono(size: 12.5, color: ScColors.textMuted)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _Metric(label: context.l10n.metricTime, value: clock)),
              const SizedBox(width: 8),
              Expanded(
                child: _Metric(
                  label: context.l10n.metricSpeed,
                  value: '${scMph(speed)}',
                  suffix: context.l10n.unitMph,
                  danger: speed > kSpeedLimitKmh,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _Metric(label: context.l10n.metricDistance, value: scMiles(trip.km * t), suffix: context.l10n.unitMi),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              ScPressable(
                pressedScale: .94,
                onTap: _toggle,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                      color: ScColors.brand, shape: BoxShape.circle, boxShadow: ScShadows.brand),
                  child: Icon(_c.isAnimating ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: 28, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                      ),
                      child: Slider(
                        value: t.clamp(0, 1),
                        activeColor: ScColors.brand,
                        inactiveColor: ScColors.borderDefault,
                        onChanged: _seek,
                      ),
                    ),
                    SizedBox(
                      height: 6,
                      child: Stack(
                        children: [
                          for (final e in events)
                            Align(
                              alignment: Alignment(e * 2 - 1, 0),
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                    color: ScColors.red500, shape: BoxShape.circle),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              ScPressable(
                pressedScale: .94,
                onTap: () => _setRate(_rate == 1 ? 2 : (_rate == 2 ? 4 : 1)),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
                  decoration: BoxDecoration(
                      color: ScColors.surfaceSunken, borderRadius: BorderRadius.circular(10)),
                  child: Text('${_rate.round()}×',
                      style: ScText.mono(size: 13, weight: FontWeight.w700)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _TimelineRow(
            icon: FeatherIcons.navigation,
            label: context.l10n.leftPlace(trip.fromLabel.isEmpty ? context.l10n.theStart : trip.fromLabel),
            time: scClock(trip.start),
            passed: true,
            onTap: () => _seek(0),
          ),
          for (final e in events)
            _TimelineRow(
              icon: FeatherIcons.alertTriangle,
              label: context.l10n.speedingOver(scSpeed(kSpeedLimitKmh)),
              time: scClock(DateTime.fromMillisecondsSinceEpoch(
                  trip.startMillis + ((trip.endMillis - trip.startMillis) * e).round())),
              passed: t >= e,
              danger: true,
              onTap: () => _seek(e),
            ),
          _TimelineRow(
            icon: FeatherIcons.flag,
            label: context.l10n.arrivedAt(trip.toLabel.isEmpty ? context.l10n.theEnd : trip.toLabel),
            time: scClock(trip.end),
            passed: t >= 1,
            onTap: () => _seek(1),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, this.suffix = '', this.danger = false});
  final String label;
  final String value;
  final String suffix;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
      decoration: BoxDecoration(
          color: ScColors.surfaceCard, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(label,
              style: ScText.sans(
                  size: 10, weight: FontWeight.w700, color: ScColors.textMuted, spacing: .8)),
          const SizedBox(height: 3),
          FittedBox(
            child: Text('$value$suffix',
                style: ScText.mono(
                    size: 17,
                    weight: FontWeight.w700,
                    color: danger ? ScColors.red500 : ScColors.brand)),
          ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.icon,
    required this.label,
    required this.time,
    required this.passed,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final String time;
  final bool passed;
  final bool danger;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = !passed
        ? ScColors.textMuted
        : danger
            ? ScColors.red500
            : ScColors.brand;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ScText.sans(
                      size: 13.5,
                      weight: FontWeight.w700,
                      color: passed ? ScColors.textHeading : ScColors.textMuted)),
            ),
            Text(time, style: ScText.mono(size: 12.5, color: ScColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
