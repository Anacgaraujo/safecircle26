import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/async_view.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_bottom_nav.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/journeys/data/journey_repository.dart';
import 'package:safecircle/features/journeys/domain/journey.dart';

class JourneyHistoryView extends ConsumerWidget {
  const JourneyHistoryView({super.key, required this.onPlanNew});
  final VoidCallback onPlanNew;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.fromLTRB(24, 12, 24, 0), child: ScBackButton()),
        Padding(
          padding: const EdgeInsets.fromLTRB(26, 6, 26, 0),
          child: Text('Journey history',
              style: ScText.sans(
                  size: 28, weight: FontWeight.w800, color: ScColors.textHeading, height: 34, spacing: -0.6)),
        ),
        Expanded(
          child: ScAsyncView(
            value: ref.watch(journeyHistoryProvider),
            data: (history) => history.isEmpty
                ? const _HistoryEmpty()
                : ListView(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                    children: [
                      for (final h in history) ...[
                        _HistoryCard(journey: h),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(26, 8, 26, 20),
          child: ScButton(
            label: 'Plan new journey',
            variant: ScButtonVariant.secondary,
            leftIcon: FeatherIcons.plus,
            onPressed: onPlanNew,
          ),
        ),
      ],
    );
  }
}

class _HistoryEmpty extends StatelessWidget {
  const _HistoryEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(FeatherIcons.map, size: 56, color: ScColors.textMuted),
            const SizedBox(height: 14),
            Text('No past journeys yet',
                style: ScText.sans(size: 17, weight: FontWeight.w700, color: ScColors.textSecondary)),
            const SizedBox(height: 8),
            SizedBox(
              width: 250,
              child: Text('Your completed journeys will show up here once you finish one.',
                  textAlign: TextAlign.center,
                  style: ScText.sans(
                      size: 14, weight: FontWeight.w500, color: ScColors.textMuted, height: 20)),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.journey});
  final Journey journey;

  @override
  Widget build(BuildContext context) {
    final h = journey;
    return ScCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(h.dateLabel.isEmpty ? 'Journey' : h.dateLabel,
                  style: ScText.sans(size: 16, weight: FontWeight.w800, color: ScColors.textHeading)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: ScColors.green50,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: ScColors.green600,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text('Completed',
                        style: ScText.sans(
                            size: 11,
                            weight: FontWeight.w700,
                            color: ScColors.green600,
                            spacing: .3)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const CirclesIcon(size: 15, color: ScColors.textMuted),
              const SizedBox(width: 7),
              Text(h.circleName,
                  style: ScText.sans(size: 13.5, weight: FontWeight.w600, color: ScColors.textSecondary)),
              const SizedBox(width: 16),
              const Icon(FeatherIcons.clock, size: 15, color: ScColors.textMuted),
              const SizedBox(width: 7),
              Text(h.duration.isEmpty ? '—' : h.duration,
                  style: ScText.sans(size: 13.5, weight: FontWeight.w600, color: ScColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}
