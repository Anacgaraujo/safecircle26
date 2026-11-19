import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';

import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/l10n/l10n.dart';

class CirclesIcon extends StatelessWidget {
  const CirclesIcon({super.key, this.size = 24, this.color = ScColors.textMuted});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.square(size), painter: _CirclesPainter(color));
  }
}

class _CirclesPainter extends CustomPainter {
  _CirclesPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 12
      ..strokeCap = StrokeCap.round;
    final u = size.width / 24;
    canvas.drawCircle(Offset(9 * u, 9 * u), 5.4 * u, p);
    canvas.drawCircle(Offset(15.6 * u, 14.6 * u), 5.4 * u, p);
  }

  @override
  bool shouldRepaint(_CirclesPainter old) => old.color != color;
}

enum ScTab { home, circles, emergency, profile }

/// The main shell's selected tab. Screens pushed over the shell (such as the
/// journey flow) select a tab here and pop back to show it.
final mainTabProvider = NotifierProvider.autoDispose<MainTabNotifier, ScTab>(MainTabNotifier.new);

class MainTabNotifier extends Notifier<ScTab> {
  @override
  ScTab build() => ScTab.home;

  void select(ScTab tab) => state = tab;
}

class ScBottomNav extends StatelessWidget {
  const ScBottomNav({
    super.key,
    required this.active,
    required this.onTab,
    required this.onFab,
    this.coachmark,
    this.mapHome = true,
  });

  final ScTab active;
  final ValueChanged<ScTab> onTab;
  final VoidCallback onFab;

  final String? coachmark;

  final bool mapHome;

  Widget _tab(BuildContext context, ScTab tab, String label, IconData? icon) {
    final isActive = tab == active;
    final color = isActive ? ScColors.brand : ScColors.textMuted;
    return Expanded(
      child: ScPressable(
        onTap: () => onTab(tab),
        pressedScale: .9,
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon == null)
                CirclesIcon(size: 24, color: color)
              else
                Icon(icon, size: 24, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                style: ScText.sans(
                  size: 10,
                  weight: isActive ? FontWeight.w800 : FontWeight.w600,
                  color: color,
                  spacing: .2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 10,
            bottom: 12 + MediaQuery.of(context).padding.bottom,
          ),
          decoration: const BoxDecoration(
            color: ScColors.surfaceCard,
            border: Border(top: BorderSide(color: ScColors.borderHairline)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(children: [
                  _tab(context, ScTab.home, mapHome ? context.l10n.tabMap : context.l10n.tabJourneys,
                      mapHome ? FeatherIcons.map : FeatherIcons.list),
                  _tab(context, ScTab.circles, context.l10n.tabCircles, null),
                ]),
              ),
              const SizedBox(width: 72),
              Expanded(
                child: Row(children: [
                  _tab(context, ScTab.emergency, context.l10n.tabEmergency, FeatherIcons.shield),
                  _tab(context, ScTab.profile, context.l10n.tabProfile, FeatherIcons.user),
                ]),
              ),
            ],
          ),
        ),
        Positioned(
          top: -16,
          left: 0,
          right: 0,
          child: Center(
            child: Semantics(
              button: true,
              label: context.l10n.planAJourney,
              child: ScPressable(
              onTap: onFab,
              pressedScale: .92,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: ScColors.ink,
                  shape: BoxShape.circle,
                  border: Border.all(color: ScColors.surfaceCard, width: 4),
                  boxShadow: ScShadows.lg,
                ),
                child: const Icon(FeatherIcons.plus, size: 26, color: Colors.white),
              ),
            ),
            ),
          ),
        ),
        if (coachmark != null)
          Positioned(
            bottom: 74 + MediaQuery.of(context).padding.bottom,
            left: 24,
            child: _Coachmark(text: coachmark!),
          ),
      ],
    );
  }
}

class _Coachmark extends StatelessWidget {
  const _Coachmark({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 400),
      curve: ScMotion.easeOut,
      builder: (_, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(offset: Offset(0, (1 - t) * 6), child: child),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 172,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: ScColors.amber100,
              borderRadius: BorderRadius.circular(14),
              boxShadow: ScShadows.lg,
            ),
            child: Row(
              children: [
                const Icon(FeatherIcons.userPlus, size: 18, color: ScColors.amber800),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    text,
                    style: ScText.sans(size: 13, weight: FontWeight.w700, color: ScColors.amber800, height: 17),
                  ),
                ),
              ],
            ),
          ),
          CustomPaint(
            size: const Size(12, 6),
            painter: _TrianglePainter(ScColors.amber100),
          ),
        ],
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  _TrianglePainter(this.color);
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
  bool shouldRepaint(_TrianglePainter old) => old.color != color;
}
