import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/activity/data/activity_repository.dart';
import 'package:safecircle/features/activity/presentation/activity_screen.dart';
import 'package:safecircle/features/alerts/data/alert_repository.dart';
import 'package:safecircle/features/alerts/domain/safety_alert.dart';
import 'package:safecircle/features/circles/data/circle_repository.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/circles/domain/circle_invite.dart';
import 'package:safecircle/features/live_map/domain/tracking.dart';
import 'package:safecircle/features/live_map/presentation/widgets/map_controls.dart';
import 'package:safecircle/features/places/presentation/places_screen.dart';

class MapTopBar extends StatelessWidget {
  const MapTopBar({
    super.key,
    required this.circles,
    required this.circle,
    required this.onToggleMenu,
    this.onGoCircles,
    this.onToggleHome,
  });

  final List<Circle> circles;
  final Circle? circle;
  final VoidCallback onToggleMenu;
  final VoidCallback? onGoCircles;
  final VoidCallback? onToggleHome;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: ScPressable(
              pressedScale: .98,
              onTap: circles.isEmpty ? onGoCircles : onToggleMenu,
              child: Container(
                height: 44,
                padding: const EdgeInsets.fromLTRB(7, 0, 12, 0),
                decoration: BoxDecoration(
                  color: ScColors.surfaceCard,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: ScShadows.card,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                          color: ScColors.brandTint, shape: BoxShape.circle),
                      child: const Icon(FeatherIcons.users, size: 16, color: ScColors.brand),
                    ),
                    const SizedBox(width: 9),
                    Flexible(
                      child: Text(circle?.name ?? 'Create a circle',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ScText.sans(size: 15, weight: FontWeight.w800)),
                    ),
                    const SizedBox(width: 4),
                    const Icon(FeatherIcons.chevronDown, size: 18, color: ScColors.textMuted),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (onToggleHome != null) ...[
            MapRoundButton(
              icon: FeatherIcons.list,
              tooltip: 'Journeys list',
              onTap: onToggleHome,
            ),
            const SizedBox(width: 8),
          ],
          MapRoundButton(
            icon: FeatherIcons.mapPin,
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => PlacesScreen(circle: circle))),
          ),
          const SizedBox(width: 8),
          _Bell(onGoCircles: onGoCircles),
        ],
      ),
    );
  }
}

class _Bell extends ConsumerWidget {
  const _Bell({this.onGoCircles});
  final VoidCallback? onGoCircles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(incomingAlertsProvider).value ?? const <SafetyAlert>[];
    final invites = ref.watch(pendingInvitesProvider).value ?? const <CircleInvite>[];
    final events = ref.watch(activityFeedProvider).value ?? const <ActivityEvent>[];
    return MapRoundButton(
      icon: FeatherIcons.bell,
      showDot: alerts.isNotEmpty || invites.isNotEmpty || events.isNotEmpty,
      onTap: () => showActivitySheet(
        context,
        alerts: alerts,
        invites: invites,
        events: events,
        onGoCircles: onGoCircles,
      ),
    );
  }
}

class CircleMenu extends StatelessWidget {
  const CircleMenu({super.key, required this.circles, required this.selected, required this.onPick});
  final List<Circle> circles;
  final Circle? selected;
  final ValueChanged<Circle> onPick;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60,
      left: 16,
      child: Container(
        constraints: const BoxConstraints(minWidth: 200, maxWidth: 300),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: ScColors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          boxShadow: ScShadows.lg,
        ),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final c in circles)
                InkWell(
                  onTap: () => onPick(c),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                    color: c.id == selected?.id ? ScColors.brandTint : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.name, style: ScText.sans(size: 15, weight: FontWeight.w800)),
                        const SizedBox(height: 2),
                        Text('${c.memberIds.length} ${c.memberIds.length == 1 ? 'member' : 'members'}',
                            style: ScText.sans(
                                size: 12, weight: FontWeight.w600, color: ScColors.textMuted)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
