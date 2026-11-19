import 'package:flutter/material.dart';

import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/utils/actions.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/alerts/domain/safety_alert.dart';
import 'package:safecircle/features/alerts/presentation/alert_detail_screen.dart';
import 'package:safecircle/features/journeys/domain/journey.dart';
import 'package:safecircle/features/journeys/presentation/friend_journey_screen.dart';
import 'package:safecircle/features/journeys/presentation/journey_flow_screen.dart';
import 'package:safecircle/l10n/l10n.dart';

IconData alertIcon(SafetyAlert a) => switch (a.type) {
      'panic' => FeatherIcons.shield,
      'overdue' => FeatherIcons.clock,
      _ => FeatherIcons.alertTriangle,
    };

class MyJourneyCard extends StatelessWidget {
  const MyJourneyCard({super.key, required this.journey, required this.now});
  final Journey journey;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final next = journey.nextCheckIn;
    final late = next?.isLate(now) ?? false;
    final due = late || (next?.isDueNow(now) ?? false);
    final accent = late ? ScColors.red500 : due ? ScColors.amber800 : ScColors.green600;
    final bg = late ? ScColors.red50 : due ? ScColors.amber100 : ScColors.green50;
    final status = next == null
        ? context.l10n.allCheckInsConfirmed
        : late
            ? context.l10n.labelCheckInOverdue(next.label)
            : due
                ? context.l10n.labelCheckInDueNow(next.label)
                : context.l10n.nextCheckInLabel(next.label, next.timeText);
    return ScPressable(
      pressedScale: .99,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const JourneyFlow()),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 13, 12, 13),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accent.withValues(alpha: .35)),
        ),
        child: Row(
          children: [
            Icon(late ? FeatherIcons.alertCircle : due ? FeatherIcons.bell : FeatherIcons.navigation,
                size: 22, color: accent),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.yourJourneyWith(journey.circleName),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ScText.sans(size: 14.5, weight: FontWeight.w800, color: ScColors.textHeading)),
                  const SizedBox(height: 2),
                  Text(status,
                      style: ScText.sans(
                          size: 12.5,
                          weight: FontWeight.w600,
                          color: due ? accent : ScColors.textSecondary,
                          height: 16)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(FeatherIcons.chevronRight, size: 18, color: accent),
          ],
        ),
      ),
    );
  }
}

class NotificationRow extends StatelessWidget {
  const NotificationRow({
    super.key,
    required this.tint,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.sub,
    required this.onTap,
  });
  final Color tint;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String sub;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ScPressable(
      onTap: onTap,
      child: ScCard(
        padding: const EdgeInsets.all(13),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: tint, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: ScText.sans(size: 15, weight: FontWeight.w800, color: ScColors.textHeading)),
                  const SizedBox(height: 2),
                  Text(sub,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ScText.sans(size: 13, weight: FontWeight.w500, color: ScColors.textSecondary)),
                ],
              ),
            ),
            const Icon(FeatherIcons.chevronRight, size: 20, color: ScColors.brand),
          ],
        ),
      ),
    );
  }
}

class FriendsJourneysEmpty extends StatelessWidget {
  const FriendsJourneysEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 24, 40, 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: const BoxDecoration(color: ScColors.surfaceSunken, shape: BoxShape.circle),
              child: const Icon(FeatherIcons.flag, size: 44, color: ScColors.textMuted),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 260,
              child: Text(
                context.l10n.noActiveFriendJourneys,
                textAlign: TextAlign.center,
                style: ScText.sans(size: 16, weight: FontWeight.w600, color: ScColors.textSecondary, height: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StandaloneAlertCard extends StatelessWidget {
  const StandaloneAlertCard({super.key, required this.alert});
  final SafetyAlert alert;

  @override
  Widget build(BuildContext context) {
    return ScPressable(
      pressedScale: .99,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => AlertDetailScreen(alert: alert)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: ScColors.brand,
          borderRadius: BorderRadius.circular(20),
          boxShadow: ScShadows.brand,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: .9), width: 2),
                    ),
                    child: ScAvatar(name: alert.fromName, size: 48),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(alert.fromName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: ScText.sans(size: 17, weight: FontWeight.w800, color: Colors.white)),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(FeatherIcons.alertCircle,
                                size: 14, color: Colors.white.withValues(alpha: .92)),
                            const SizedBox(width: 6),
                            Text(
                                '${alert.kindLabel} · ${alert.timeText}',
                                style: ScText.sans(size: 13, weight: FontWeight.w800, color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: .15),
                            offset: const Offset(0, 3),
                            blurRadius: 10)
                      ],
                    ),
                    child: Icon(alertIcon(alert),
                        size: 20, color: ScColors.brand),
                  ),
                ],
              ),
            ),
            Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: Colors.white.withValues(alpha: .28)),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => callPhone(context, alert.fromPhone),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(FeatherIcons.phoneCall, size: 18, color: Colors.white),
                    const SizedBox(width: 9),
                    Text(context.l10n.callName(alert.fromFirstName),
                        style: ScText.sans(size: 15, weight: FontWeight.w800, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OverdueJourneyCard extends StatelessWidget {
  const OverdueJourneyCard({super.key, required this.journey, required this.panicMode});
  final Journey journey;
  final bool panicMode;

  @override
  Widget build(BuildContext context) {
    return ScPressable(
      pressedScale: .99,
      onTap: () => _openDetail(context, journey, panicMode),
      child: Container(
        decoration: BoxDecoration(
          color: ScColors.brand,
          borderRadius: BorderRadius.circular(20),
          boxShadow: ScShadows.brand,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: .9), width: 2),
                    ),
                    child: ScAvatar(name: journey.ownerName, size: 48),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(journey.ownerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: ScText.sans(size: 17, weight: FontWeight.w800, color: Colors.white)),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(FeatherIcons.clock, size: 14, color: Colors.white.withValues(alpha: .92)),
                            const SizedBox(width: 6),
                            Text(context.l10n.nextCheckInPrefix,
                                style: ScText.sans(
                                    size: 13,
                                    weight: FontWeight.w600,
                                    color: Colors.white.withValues(alpha: .92))),
                            Text(panicMode ? context.l10n.panicAlert : context.l10n.overdue,
                                style: ScText.sans(size: 13, weight: FontWeight.w800, color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: .15),
                            offset: const Offset(0, 3),
                            blurRadius: 10)
                      ],
                    ),
                    child: Icon(panicMode ? FeatherIcons.shield : FeatherIcons.alertTriangle,
                        size: 20, color: ScColors.brand),
                  ),
                ],
              ),
            ),
            Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: Colors.white.withValues(alpha: .28)),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => callPhone(context, journey.ownerPhone),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(FeatherIcons.phoneCall, size: 18, color: Colors.white),
                    const SizedBox(width: 9),
                    Text(context.l10n.callName(journey.ownerFirstName),
                        style: ScText.sans(size: 15, weight: FontWeight.w800, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JourneyCard extends StatelessWidget {
  const JourneyCard({super.key, required this.journey});
  final Journey journey;

  @override
  Widget build(BuildContext context) {
    final next = journey.nextCheckIn;
    final nextTime = next?.timeText ?? context.l10n.done;
    final dueNow = next?.isDueNow(DateTime.now()) ?? false;
    return ScPressable(
      onTap: () => _openDetail(context, journey, false),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: ScColors.surfaceCard,
          borderRadius: BorderRadius.circular(18),
          boxShadow: ScShadows.card,
        ),
        child: Row(
          children: [
            ScAvatar(
                name: journey.ownerName,
                size: 48,
                ring: dueNow ? ScAvatarRing.none : ScAvatarRing.safe),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(journey.ownerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ScText.sans(size: 16, weight: FontWeight.w800, color: ScColors.textHeading)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(FeatherIcons.clock,
                          size: 15, color: dueNow ? ScColors.amber800 : ScColors.green500),
                      const SizedBox(width: 6),
                      Text(dueNow ? context.l10n.checkInDuePrefix : context.l10n.nextCheckInPrefix,
                          style: ScText.sans(size: 13, weight: FontWeight.w600, color: ScColors.textSecondary)),
                      Text(nextTime, style: ScText.mono(size: 13, weight: FontWeight.w700)),
                      if (dueNow) ...[
                        const SizedBox(width: 6),
                        Text(context.l10n.waiting,
                            style: ScText.sans(size: 12.5, weight: FontWeight.w700, color: ScColors.amber800)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const Icon(FeatherIcons.chevronRight, size: 22, color: ScColors.brand),
          ],
        ),
      ),
    );
  }
}

void _openDetail(BuildContext context, Journey journey, bool panicMode) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => FriendDetailScreen(journeyId: journey.id, panicMode: panicMode)),
  );
}
