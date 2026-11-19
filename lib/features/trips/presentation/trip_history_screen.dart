import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/utils/formatters.dart';
import 'package:safecircle/core/widgets/async_view.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/live_map/domain/tracking.dart';
import 'package:safecircle/features/trips/data/trip_repository.dart';
import 'package:safecircle/features/trips/domain/trip_rules.dart';
import 'package:safecircle/features/trips/presentation/widgets/trip_card.dart';
import 'package:safecircle/l10n/l10n.dart';

class TripHistoryScreen extends ConsumerStatefulWidget {
  const TripHistoryScreen({super.key, required this.userId, required this.name, this.photo});
  final String userId;
  final String name;
  final String? photo;

  @override
  ConsumerState<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends ConsumerState<TripHistoryScreen> {
  int _weeksAgo = 0;
  bool _onlyOverLimit = false;

  String get _firstName => widget.name.trim().split(' ').first;

  @override
  Widget build(BuildContext context) {
    final isMe = widget.userId == ref.watch(sessionProvider).uid;
    final tripsAsync =
        ref.watch(tripsOfWeekProvider((userId: widget.userId, weeksAgo: _weeksAgo)));
    final counts = ref.watch(weeklyTripCountsProvider(widget.userId)).value ?? const [0, 0, 0, 0];
    final week = TripWeek(tripsAsync.value ?? const <Trip>[], onlyOverLimit: _onlyOverLimit);

    return Scaffold(
      backgroundColor: ScColors.canvas,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Row(
              children: [
                ScBackButton(onTap: () => Navigator.of(context).pop()),
                Expanded(
                  child: Center(
                    child: Text(context.l10n.tripHistoryEyebrow,
                        style: ScText.sans(
                            size: 11, weight: FontWeight.w700, color: ScColors.textMuted, spacing: 1)),
                  ),
                ),
                const SizedBox(width: 42),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                ScAvatar(image: widget.photo, name: widget.name, size: 56),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(isMe ? context.l10n.yourTrips : context.l10n.namesTrips(_firstName),
                          style: ScText.sans(
                              size: 24,
                              weight: FontWeight.w800,
                              color: ScColors.textHeading,
                              height: 29,
                              spacing: -.6)),
                      const SizedBox(height: 3),
                      Text(
                        week.all.isEmpty
                            ? context.l10n.noTripsThisWeek
                            : context.l10n.weekSummary(scMiles(week.totalKm), scSpeed(week.topKmh)),
                        style: ScText.sans(
                            size: 13.5, weight: FontWeight.w600, color: ScColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _WeekPicker(
              weeksAgo: _weeksAgo,
              onChange: (w) => setState(() => _weeksAgo = w),
            ),
            const SizedBox(height: 14),
            _WeekChart(
              counts: counts,
              selected: 3 - _weeksAgo,
              onSelect: (i) => setState(() => _weeksAgo = 3 - i),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _FilterChip(
                  label: context.l10n.allTripsCount(week.all.length),
                  active: !_onlyOverLimit,
                  onTap: () => setState(() => _onlyOverLimit = false),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: context.l10n.overSpeedCount(scSpeed(kSpeedLimitKmh), week.overLimitCount),
                  active: _onlyOverLimit,
                  onTap: () => setState(() => _onlyOverLimit = true),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(FeatherIcons.info, size: 14, color: ScColors.textMuted),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    isMe
                        ? context.l10n.tripsRecordedYou(kTripStartRadiusM.round(), kTripStopAfter.inMinutes)
                        : context.l10n.tripsRecordedName(_firstName, kTripStartRadiusM.round(), kTripStopAfter.inMinutes),
                    style: ScText.sans(
                        size: 12.5, weight: FontWeight.w600, color: ScColors.textMuted, height: 17),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            ScAsyncView(
              value: tripsAsync,
              data: (_) => week.shown.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          week.all.isEmpty ? context.l10n.noTripsRecorded : context.l10n.noTripsMatch,
                          textAlign: TextAlign.center,
                          style: ScText.sans(size: 14, weight: FontWeight.w600, color: ScColors.textMuted),
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final entry in week.byDay.entries) ...[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(entry.key, style: ScText.sans(size: 15, weight: FontWeight.w800)),
                          ),
                          for (final t in entry.value) ...[
                            TripCard(trip: t),
                            const SizedBox(height: 10),
                          ],
                          const SizedBox(height: 8),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekPicker extends StatelessWidget {
  const _WeekPicker({required this.weeksAgo, required this.onChange});
  final int weeksAgo;
  final ValueChanged<int> onChange;

  @override
  Widget build(BuildContext context) {
    final start = weekStart(weeksAgo);
    final label = weeksAgo == 0
        ? context.l10n.thisWeek
        : weeksAgo == 1
            ? context.l10n.lastWeek
            : '${shortDate(start)} – ${shortDate(start.add(const Duration(days: 6)))}';

    return ScCard(
      radius: 16,
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          _Chevron(
            icon: FeatherIcons.chevronLeft,
            enabled: weeksAgo < 3,
            onTap: () => onChange(weeksAgo + 1),
          ),
          Expanded(
            child: Column(
              children: [
                Text(label, style: ScText.sans(size: 15, weight: FontWeight.w800)),
                const SizedBox(height: 1),
                Text(
                    weeksAgo == 0
                        ? context.l10n.sinceDay('${weekdayName(start)}, ${shortDate(start)}')
                        : '${weekdayName(start)}, ${shortDate(start)} – ${weekdayName(start.add(const Duration(days: 6)))}, ${shortDate(start.add(const Duration(days: 6)))}',
                    style: ScText.sans(
                        size: 12, weight: FontWeight.w600, color: ScColors.textMuted)),
              ],
            ),
          ),
          _Chevron(
            icon: FeatherIcons.chevronRight,
            enabled: weeksAgo > 0,
            onTap: () => onChange(weeksAgo - 1),
          ),
        ],
      ),
    );
  }
}

class _Chevron extends StatelessWidget {
  const _Chevron({required this.icon, required this.enabled, required this.onTap});
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ScPressable(
      pressedScale: enabled ? .94 : 1,
      onTap: enabled ? onTap : null,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: ScColors.surfaceSunken, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon,
            size: 19, color: enabled ? ScColors.textHeading : const Color(0xFFCBD5E1)),
      ),
    );
  }
}

class _WeekChart extends StatelessWidget {
  const _WeekChart({required this.counts, required this.selected, required this.onSelect});

  final List<int> counts;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final max = counts.fold<int>(1, (a, b) => math.max(a, b));
    return ScCard(
      radius: 18,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.tripsPerWeek,
              style: ScText.sans(
                  size: 11, weight: FontWeight.w700, color: ScColors.textMuted, spacing: 1)),
          const SizedBox(height: 10),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < counts.length; i++)
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onSelect(i),
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('${counts[i]}',
                              style: ScText.mono(
                                  size: 12,
                                  weight: FontWeight.w700,
                                  color: i == selected ? ScColors.brand : ScColors.textMuted)),
                          const SizedBox(height: 4),
                          Container(
                            height: (counts[i] / max * 60).clamp(4, 60),
                            constraints: const BoxConstraints(maxWidth: 56),
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              color: i == selected ? ScColors.brand : const Color(0xFFFCE7F3),
                              borderRadius:
                                  const BorderRadius.vertical(top: Radius.circular(8)),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            i == 3
                                ? context.l10n.thisWeekShort
                                : i == 2
                                    ? context.l10n.lastWeekShort
                                    : shortDate(weekStart(3 - i)),
                            textAlign: TextAlign.center,
                            style: ScText.sans(
                                size: 11, weight: FontWeight.w700, color: ScColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ScPressable(
      pressedScale: .97,
      onTap: onTap,
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? ScColors.textHeading : ScColors.surfaceCard,
          borderRadius: BorderRadius.circular(999),
          boxShadow: active ? null : ScShadows.card,
        ),
        child: Text(label,
            style: ScText.sans(
                size: 13,
                weight: FontWeight.w700,
                color: active ? Colors.white : ScColors.textSecondary)),
      ),
    );
  }
}
