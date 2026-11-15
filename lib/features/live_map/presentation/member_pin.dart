import 'package:flutter/material.dart';

import 'package:safecircle/features/live_map/domain/tracking.dart';
import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';

class MemberPin extends StatelessWidget {
  const MemberPin({
    super.key,
    required this.status,
    required this.focused,
    required this.isMe,
    required this.stale,
  });

  final MemberStatus status;
  final bool focused;
  final bool isMe;
  final bool stale;

  @override
  Widget build(BuildContext context) {
    final ring = isMe
        ? ScColors.textHeading
        : status.moving
            ? ScColors.brand
            : ScColors.green500;

    final pin = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: ring,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: .35),
                      offset: const Offset(0, 8),
                      blurRadius: 18,
                      spreadRadius: -4),
                ],
              ),
              child: ScAvatar(image: status.photo, name: status.name, size: 44),
            ),
            if (status.lowBattery)
              Positioned(
                right: -4,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: ScColors.red500,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Text('${status.battery}%',
                      style: ScText.mono(
                          size: 9.5, weight: FontWeight.w700, color: Colors.white)),
                ),
              ),
          ],
        ),
        CustomPaint(size: const Size(8, 12), painter: _Pointer(ring)),
        Stack(
          alignment: Alignment.center,
          children: [
            if (focused) _Pulse(color: ring),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: ring,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ],
        ),
      ],
    );

    return AnimatedScale(
      scale: focused ? 1.15 : .9,
      duration: const Duration(milliseconds: 220),
      curve: ScMotion.easeOut,
      child: Opacity(opacity: stale ? .45 : 1, child: pin),
    );
  }
}

class _Pointer extends CustomPainter {
  _Pointer(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_Pointer old) => old.color != color;
}

class _Pulse extends StatefulWidget {
  const _Pulse({required this.color});
  final Color color;

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = _c.value;
        return Opacity(
          opacity: (1 - t) * .55,
          child: Container(
            width: 10 + t * 9,
            height: 10 + t * 9,
            decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
          ),
        );
      },
    );
  }
}
