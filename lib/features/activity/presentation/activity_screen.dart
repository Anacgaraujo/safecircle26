import 'package:flutter/material.dart';

import 'package:safecircle/features/circles/domain/circle_invite.dart';
import 'package:safecircle/features/alerts/domain/safety_alert.dart';
import 'package:safecircle/features/live_map/domain/tracking.dart';
import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/alerts/presentation/alert_detail_screen.dart';
import 'package:safecircle/l10n/l10n.dart';

void showActivitySheet(
  BuildContext context, {
  required List<SafetyAlert> alerts,
  required List<CircleInvite> invites,
  required List<ActivityEvent> events,
  VoidCallback? onGoCircles,
}) {
  if (alerts.isEmpty && invites.isEmpty && events.isEmpty) {
    showScToast(context, context.l10n.nothingNewYet);
    return;
  }
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: ScColors.canvas,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: 16),
            Text(context.l10n.activity,
                style: ScText.sans(
                    size: 20, weight: FontWeight.w800, color: ScColors.textHeading)),
            const SizedBox(height: 12),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final a in alerts) ...[
                    _Row(
                      tint: ScColors.brandTint,
                      iconColor: ScColors.brand,
                      icon: switch (a.type) {
                        'panic' => FeatherIcons.shield,
                        'overdue' => FeatherIcons.clock,
                        _ => FeatherIcons.alertTriangle,
                      },
                      title: a.headline,
                      sub: '${a.kindLabel} · ${a.timeText}',
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => AlertDetailScreen(alert: a)));
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                  for (final i in invites) ...[
                    _Row(
                      tint: ScColors.amber100,
                      iconColor: ScColors.amber800,
                      icon: FeatherIcons.userPlus,
                      title: context.l10n.circleInvite,
                      sub: i.summary,
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        onGoCircles?.call();
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                  for (final e in events) ...[
                    _Row(
                      tint: e.type == 'lowBattery' ? ScColors.red50 : ScColors.green50,
                      iconColor: e.type == 'lowBattery' ? ScColors.red500 : ScColors.green600,
                      icon: switch (e.type) {
                        'lowBattery' => FeatherIcons.battery,
                        'leave' => FeatherIcons.logOut,
                        _ => FeatherIcons.home,
                      },
                      title: e.title,
                      sub: e.subtitle,
                      onTap: () => Navigator.of(sheetContext).pop(),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _Row extends StatelessWidget {
  const _Row({
    required this.tint,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.sub,
    required this.onTap,
  });

  final Color tint;
  final Color iconColor;
  final IconData icon;
  final String title;
  final String sub;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ScPressable(
      pressedScale: .99,
      onTap: onTap,
      child: ScCard(
        radius: 16,
        padding: const EdgeInsets.all(12),
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: ScText.sans(size: 14.5, weight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(sub,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ScText.sans(
                          size: 12.5, weight: FontWeight.w500, color: ScColors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
