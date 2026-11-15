import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/utils/formatters.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/live_map/domain/tracking.dart';
import 'package:safecircle/features/trips/presentation/trip_replay_screen.dart';

class TripCard extends StatelessWidget {
  const TripCard({super.key, required this.trip});
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return ScPressable(
      pressedScale: .99,
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => TripReplayScreen(trip: trip))),
      child: ScCard(
        radius: 18,
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 92,
                height: 92,
                child: CustomPaint(painter: TripThumbPainter(trip.points)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(trip.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: ScText.sans(size: 15, weight: FontWeight.w800, height: 19)),
                  const SizedBox(height: 3),
                  Text(
                      '${scClock(trip.start)} – ${scClock(trip.end)} · ${scDistance(trip.km)}',
                      style: ScText.mono(size: 12.5, color: ScColors.textMuted)),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      _Tag(
                        icon: FeatherIcons.zap,
                        label: scSpeed(trip.maxSpeedKmh),
                        bg: ScColors.surfaceSunken,
                        fg: ScColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      _Tag(
                        label: trip.overLimit
                            ? 'Over ${scSpeed(kSpeedLimitKmh)}'
                            : 'Within limit',
                        bg: trip.overLimit ? ScColors.red50 : ScColors.green50,
                        fg: trip.overLimit ? const Color(0xFFDC2626) : ScColors.green600,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(FeatherIcons.chevronRight, size: 18, color: ScColors.brand),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.bg, required this.fg, this.icon});
  final String label;
  final Color bg;
  final Color fg;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Text(label, style: ScText.sans(size: 11.5, weight: FontWeight.w700, color: fg)),
        ],
      ),
    );
  }
}

class TripThumbPainter extends CustomPainter {
  TripThumbPainter(this.points);
  final List<TripPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFE9E5DE));
    if (points.length < 2) return;

    final lats = points.map((p) => p.lat).toList();
    final lngs = points.map((p) => p.lng).toList();
    final minLat = lats.reduce(math.min), maxLat = lats.reduce(math.max);
    final minLng = lngs.reduce(math.min), maxLng = lngs.reduce(math.max);
    final span = math.max(math.max(maxLat - minLat, maxLng - minLng), 1e-5) * 1.5;
    final cx = (minLng + maxLng) / 2, cy = (minLat + maxLat) / 2;

    Offset at(TripPoint p) => Offset(
          size.width / 2 + (p.lng - cx) / span * size.width,
          size.height / 2 - (p.lat - cy) / span * size.height,
        );

    final path = Path()..moveTo(at(points.first).dx, at(points.first).dy);
    for (final p in points.skip(1)) {
      path.lineTo(at(p).dx, at(p).dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = ScColors.brand
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(at(points.first), 4, Paint()..color = Colors.white);
    canvas.drawCircle(
      at(points.first),
      4,
      Paint()
        ..color = ScColors.brand
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    canvas.drawCircle(at(points.last), 5.5, Paint()..color = ScColors.brand);
    canvas.drawCircle(
      at(points.last),
      5.5,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(TripThumbPainter old) => old.points != points;
}
