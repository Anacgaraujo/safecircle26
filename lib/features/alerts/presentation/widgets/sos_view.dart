import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/contacts/data/contacts_repository.dart';
import 'package:safecircle/features/contacts/presentation/contacts_screen.dart';

class SosView extends ConsumerWidget {
  const SosView({super.key, required this.hold, required this.onHoldStart, required this.onHoldEnd});
  final AnimationController hold;
  final VoidCallback onHoldStart;
  final VoidCallback onHoldEnd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(contactsProvider);
    return _buildBody(context, contacts.value ?? const <Person>[], contacts.hasValue);
  }

  Widget _buildBody(BuildContext context, List<Person> contacts, bool loaded) {
    final enabled = contacts.isNotEmpty;
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -1.1),
          radius: 1.5,
          colors: [Color(0xFFFFE3EC), Color(0xFFFBEEF2), ScColors.canvas],
          stops: [0, .42, 1],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(26, 8, 26, 0),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(color: ScColors.red50, borderRadius: BorderRadius.circular(11)),
                  child: const Icon(FeatherIcons.alertTriangle, size: 19, color: ScColors.red500),
                ),
                const SizedBox(width: 10),
                Text('Emergency SOS',
                    style: ScText.sans(size: 24, weight: FontWeight.w800, color: ScColors.textHeading, height: 28, spacing: -0.5)),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(26, 6, 26, 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SosButton(
                    hold: hold,
                    enabled: enabled,
                    onHoldStart: onHoldStart,
                    onHoldEnd: onHoldEnd,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 300,
                    child: Text(
                      enabled
                          ? 'This alerts your circle in the app with your location. Contacts without SafeCircle get a one-tap SMS with your position.'
                          : 'Add at least one emergency contact before you can send an alert.',
                      textAlign: TextAlign.center,
                      style: ScText.sans(size: 14.5, weight: FontWeight.w500, color: ScColors.textSubtle, height: 21),
                    ),
                  ),
                  if (loaded && !enabled) ...[
                    const SizedBox(height: 14),
                    ScButton(
                      label: 'Add emergency contact',
                      variant: ScButtonVariant.secondary,
                      fullWidth: false,
                      leftIcon: FeatherIcons.userPlus,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const EmergencyContactsScreen()),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ScSectionLabel(
                      'Your emergency contacts · ${contacts.length}',
                      icon: FeatherIcons.users,
                    ),
                  ),
                  const SizedBox(height: 11),
                  SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: contacts.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final c = contacts[i];
                        return Container(
                          padding: const EdgeInsets.fromLTRB(7, 7, 13, 7),
                          decoration: BoxDecoration(
                            color: ScColors.surfaceCard,
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: ScShadows.card,
                          ),
                          child: Row(
                            children: [
                              ScAvatar(image: c.image, name: c.name, size: 30),
                              const SizedBox(width: 9),
                              Text(c.firstName, style: ScText.sans(size: 14, weight: FontWeight.w700)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SosButton extends StatelessWidget {
  const _SosButton({
    required this.hold,
    required this.enabled,
    required this.onHoldStart,
    required this.onHoldEnd,
  });
  final AnimationController hold;
  final bool enabled;
  final VoidCallback onHoldStart;
  final VoidCallback onHoldEnd;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: hold,
      builder: (context, _) {
        final p = hold.value;
        final holding = hold.isAnimating;
        final caption =
            !enabled ? 'Unavailable' : (holding ? (p >= .99 ? 'Sending…' : 'Keep holding…') : 'Hold to alert');

        return SizedBox(
          width: 264,
          height: 264,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (holding) ...[
                _Halo(controller: hold, scaleTo: 1.7, opacity: .16),
                _Halo(controller: hold, scaleTo: 2.1, opacity: .12),
              ],
              CustomPaint(
                size: const Size(264, 264),
                painter: _RingPainter(progress: p),
              ),
              GestureDetector(
                onTapDown: (_) {
                  if (!enabled) {
                    showScToast(context, 'Add an emergency contact before sending an alert.');
                    return;
                  }
                  onHoldStart();
                },
                onTapUp: (_) => onHoldEnd(),
                onTapCancel: onHoldEnd,
                child: AnimatedScale(
                  scale: p > 0 ? .96 : 1,
                  duration: ScMotion.fast,
                  child: Opacity(
                    opacity: enabled ? 1 : .5,
                    child: Container(
                      width: 212,
                      height: 212,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          center: Alignment(0, -.32),
                          colors: [Color(0xFFFF3D6E), Color(0xFFEF2B57), Color(0xFFD61F46)],
                          stops: [0, .46, 1],
                        ),
                        boxShadow: [
                          BoxShadow(color: ScColors.red500.withValues(alpha: .10), spreadRadius: 12),
                          BoxShadow(
                              color: const Color(0xFFD61F46).withValues(alpha: .55),
                              offset: const Offset(0, 22),
                              blurRadius: 42,
                              spreadRadius: -10),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('SOS', style: ScText.mono(size: 46, weight: FontWeight.w700, color: Colors.white, spacing: 2.7)),
                          const SizedBox(height: 6),
                          Text(caption.toUpperCase(),
                              style: ScText.sans(size: 13, weight: FontWeight.w800, color: Colors.white.withValues(alpha: .95), spacing: 2)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Halo extends StatefulWidget {
  const _Halo({required this.controller, required this.scaleTo, required this.opacity});
  final AnimationController controller;
  final double scaleTo;
  final double opacity;

  @override
  State<_Halo> createState() => _HaloState();
}

class _HaloState extends State<_Halo> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final t = _c.value;
        return Transform.scale(
          scale: 1 + (widget.scaleTo - 1) * t,
          child: Container(
            width: 212,
            height: 212,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ScColors.red500.withValues(alpha: widget.opacity * (1 - t)),
            ),
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 10.0;
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = size.width / 2 - stroke / 2;

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = const Color(0xFFD61F46).withValues(alpha: .14);
    canvas.drawCircle(center, radius, track);

    if (progress > 0) {
      final arc = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFFEF2B57);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        arc,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}
