import 'package:flutter/material.dart';

import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/journeys/domain/journey.dart';

class CheckInConfirmedView extends StatelessWidget {
  const CheckInConfirmedView({
    super.key,
    required this.checkIns,
    required this.confirmedIndex,
    required this.onBack,
  });

  final List<CheckIn> checkIns;
  final int? confirmedIndex;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final activeIndex = confirmedIndex;
    CheckIn? next;
    for (final c in checkIns.skip((activeIndex ?? -1) + 1)) {
      if (!c.confirmed) {
        next = c;
        break;
      }
    }
    final sub = next != null
        ? 'Your circle has been notified. Next check-in at ${next.time}.'
        : "You're all checked in for this journey. Have a safe trip.";
    final confirmed = activeIndex != null ? checkIns[activeIndex] : null;
    final place = confirmed?.place ?? '';

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(30, 30, 30, 30 + MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 30),
          Center(
            child: _CheckPop(
              child: Container(
                width: 110,
                height: 110,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ScColors.green50,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: ScColors.green500.withValues(alpha: .1), spreadRadius: 10)],
                ),
                child: Container(
                  width: 74,
                  height: 74,
                  decoration: const BoxDecoration(color: ScColors.green500, shape: BoxShape.circle),
                  child: const Icon(FeatherIcons.check, size: 44, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 26),
          Text('Check-in confirmed!',
              textAlign: TextAlign.center,
              style: ScText.sans(size: 28, weight: FontWeight.w800, color: ScColors.textHeading, spacing: -0.5)),
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
              width: 280,
              child: Text(sub,
                  textAlign: TextAlign.center,
                  style: ScText.sans(size: 15.5, weight: FontWeight.w500, color: ScColors.textSubtle, height: 23)),
            ),
          ),
          if (place.isNotEmpty) ...[
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: ScColors.surfaceCard,
                borderRadius: BorderRadius.circular(14),
                boxShadow: ScShadows.card,
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(color: ScColors.green50, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(FeatherIcons.mapPin, size: 18, color: ScColors.green500),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Location shared',
                            style: ScText.sans(size: 12.5, weight: FontWeight.w700, color: ScColors.textMuted)),
                        const SizedBox(height: 1),
                        Text(place,
                            style: ScText.sans(size: 14, weight: FontWeight.w600, color: ScColors.textHeading, height: 18)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 32),
          ScButton(label: 'Back to journey', onPressed: onBack),
        ],
      ),
    );
  }
}

class JourneyFinishedView extends StatelessWidget {
  const JourneyFinishedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: _CheckPop(
              child: Container(
                width: 120,
                height: 120,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ScColors.green50,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: ScColors.green500.withValues(alpha: .1), spreadRadius: 12)],
                ),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(color: ScColors.green500, shape: BoxShape.circle),
                  child: const Icon(FeatherIcons.check, size: 48, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 26),
          Text('Journey finished',
              textAlign: TextAlign.center,
              style: ScText.sans(size: 30, weight: FontWeight.w800, color: ScColors.textHeading, spacing: -0.5)),
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
              width: 290,
              child: Text(
                "You're safe and your circle has been notified that you've arrived.",
                textAlign: TextAlign.center,
                style: ScText.sans(size: 15.5, weight: FontWeight.w500, color: ScColors.textSubtle, height: 23),
              ),
            ),
          ),
          const SizedBox(height: 38),
          ScButton(
              label: 'Back home',
              leftIcon: FeatherIcons.home,
              onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }
}

class _CheckPop extends StatelessWidget {
  const _CheckPop({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: .4, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: ScMotion.easeOut,
      builder: (_, t, c) => Opacity(opacity: t.clamp(0, 1), child: Transform.scale(scale: t, child: c)),
      child: child,
    );
  }
}
