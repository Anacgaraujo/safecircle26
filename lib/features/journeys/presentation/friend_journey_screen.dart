import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/utils/actions.dart';
import 'package:safecircle/core/utils/clock.dart';
import 'package:safecircle/core/widgets/async_view.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_map.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/alerts/data/alert_repository.dart';
import 'package:safecircle/features/journeys/data/journey_repository.dart';
import 'package:safecircle/features/journeys/domain/journey.dart';
import 'package:safecircle/features/journeys/domain/journey_schedule.dart';

class FriendDetailScreen extends ConsumerWidget {
  const FriendDetailScreen({super.key, required this.journeyId, this.panicMode = false});
  final String journeyId;
  final bool panicMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.now(const Duration(seconds: 15));
    final alerts = ref.watch(incomingAlertsProvider).value;
    final journey = ref.watch(journeyProvider(journeyId)).value;
    return Scaffold(
      body: journey == null
          ? const ScSpinner()
          : _FriendDetailBody(
              journey: journey,
              now: now,
              panicMode: alerts == null
                  ? panicMode
                  : alerts.any((a) => a.fromUid == journey.ownerId && a.type == 'panic'),
            ),
    );
  }
}

class _FriendDetailBody extends StatelessWidget {
  const _FriendDetailBody({required this.journey, required this.panicMode, required this.now});
  final Journey journey;
  final bool panicMode;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final missed = journey.missedCheckIn(now);
    final od = journey.alertRaised || panicMode || missed != null;
    final pinColor = od ? ScColors.brand : ScColors.green500;
    final first = journey.ownerFirstName;

    return LayoutBuilder(builder: (context, constraints) {
      final mapHeight = constraints.maxHeight * .42;
      return Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: mapHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ScMapView(lat: journey.lastLat, lng: journey.lastLng, pinColor: pinColor),
                IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [ScColors.canvas.withValues(alpha: 0), ScColors.canvas],
                        stops: const [.72, 1],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 56,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .9),
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: .08),
                              offset: const Offset(0, 2),
                              blurRadius: 6)
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              width: 7, height: 7, decoration: BoxDecoration(color: pinColor, shape: BoxShape.circle)),
                          const SizedBox(width: 7),
                          Text(
                              journey.lastSeen.isEmpty
                                  ? 'Journey with ${journey.circleName}'
                                  : '${journey.lastSeen}${journey.lastPlace.isEmpty ? '' : ' · ${journey.lastPlace}'}',
                              style: ScText.sans(size: 12, weight: FontWeight.w700, color: ScColors.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 0, 0),
                child: ScCircleIconButton(
                  icon: FeatherIcons.arrowLeft,
                  size: 42,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
          Positioned(
            top: mapHeight - 78,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
              decoration: const BoxDecoration(
                color: ScColors.canvas,
                borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                boxShadow: ScShadows.sheet,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                          color: ScColors.borderDefault, borderRadius: BorderRadius.circular(3)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      ScAvatar(
                        name: journey.ownerName,
                        size: 56,
                        ring: od ? ScAvatarRing.overdue : ScAvatarRing.safe,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(journey.ownerName,
                                style: ScText.sans(
                                    size: 20, weight: FontWeight.w800, color: ScColors.textHeading, spacing: -.3)),
                            const SizedBox(height: 5),
                            _StatusPill(
                              label: od ? (panicMode ? 'Silent alert' : 'Overdue') : 'On time',
                              bg: od ? ScColors.brandTint : ScColors.green50,
                              fg: od ? ScColors.magenta600 : ScColors.green600,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (od) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                      decoration: BoxDecoration(
                        color: ScColors.brandTint,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: ScColors.brand.withValues(alpha: .25)),
                      ),
                      child: Row(
                        children: [
                          Icon(panicMode ? FeatherIcons.shield : FeatherIcons.alertTriangle,
                              size: 20, color: ScColors.magenta600),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              panicMode
                                  ? '$first used the panic PIN — they may be in danger. Call them or $kEmergencyNumber.'
                                  : missed != null
                                      ? 'Missed check-in at ${missed.time}. Reach out to $first.'
                                      : 'A check-in was missed. Reach out to $first.',
                              style: ScText.sans(
                                  size: 13.5, weight: FontWeight.w700, color: ScColors.magenta600, height: 19),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (journey.note.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Icon(FeatherIcons.info, size: 15, color: ScColors.textMuted),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(journey.note,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: ScText.sans(
                                  size: 13.5, weight: FontWeight.w600, color: ScColors.textSecondary, height: 19)),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 22),
                  const ScSectionLabel('Check-ins', icon: FeatherIcons.clock),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        for (final (c, st) in checkInTimeline(journey.checkIns, now))
                          _CheckInRow(checkIn: c, state: st, now: now),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ScButton(
                          label: 'Call',
                          leftIcon: FeatherIcons.phoneCall,
                          onPressed: () => callPhone(context, journey.ownerPhone),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ScButton(
                          label: 'Message',
                          variant: ScButtonVariant.secondary,
                          leftIcon: FeatherIcons.messageCircle,
                          onPressed: () => messagePhone(context, journey.ownerPhone),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.bg, required this.fg});
  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 7, height: 7, decoration: BoxDecoration(color: fg, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(label, style: ScText.sans(size: 12.5, weight: FontWeight.w700, color: fg)),
        ],
      ),
    );
  }
}

class _CheckInRow extends StatelessWidget {
  const _CheckInRow({required this.checkIn, required this.state, required this.now});
  final CheckIn checkIn;
  final CheckInState state;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final (Color dotBg, Widget dotChild, Color titleColor, String tag, Color tagColor) = switch (state) {
      CheckInState.done => (
          ScColors.green50,
          const Icon(FeatherIcons.check, size: 18, color: ScColors.green500),
          ScColors.textHeading,
          'Confirmed',
          ScColors.green500,
        ),
      CheckInState.missed => (
          ScColors.brandTint,
          const Icon(FeatherIcons.alertCircle, size: 18, color: ScColors.brand),
          ScColors.magenta600,
          'Missed',
          ScColors.brand,
        ),
      CheckInState.next => (
          checkIn.isDueNow(now) ? ScColors.amber100 : ScColors.brandTint,
          const _PulsingDot(),
          ScColors.textHeading,
          checkIn.isDueNow(now) ? 'Due now' : 'Upcoming',
          checkIn.isDueNow(now) ? ScColors.amber800 : ScColors.brand,
        ),
      CheckInState.future => (
          ScColors.surfaceSunken,
          Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(color: ScColors.borderDefault, shape: BoxShape.circle)),
          ScColors.textMuted,
          'Upcoming',
          ScColors.textMuted,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ScColors.borderHairline))),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: dotBg,
              shape: BoxShape.circle,
              border: state == CheckInState.missed ? Border.all(color: ScColors.brand, width: 1.5) : null,
            ),
            child: dotChild,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(checkIn.label, style: ScText.sans(size: 15, weight: FontWeight.w700, color: titleColor)),
                const SizedBox(height: 1),
                Text(
                    checkIn.confirmed && (checkIn.place ?? '').isNotEmpty
                        ? '${checkIn.date} · ${checkIn.time} · ${checkIn.place}'
                        : '${checkIn.date} · ${checkIn.time}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: ScText.mono(size: 12.5, color: ScColors.textMuted)),
              ],
            ),
          ),
          Text(tag, style: ScText.sans(size: 12.5, weight: FontWeight.w700, color: tagColor)),
        ],
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
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
        final wave = t < .5 ? t * 2 : (1 - t) * 2;
        return Transform.scale(
          scale: 1 + wave * .7,
          child: Opacity(
            opacity: .85 - wave * .65,
            child: Container(
              width: 9,
              height: 9,
              decoration: const BoxDecoration(color: ScColors.brand, shape: BoxShape.circle),
            ),
          ),
        );
      },
    );
  }
}
