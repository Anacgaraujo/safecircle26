import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/utils/clock.dart';
import 'package:safecircle/core/widgets/async_view.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/alerts/data/alert_repository.dart';
import 'package:safecircle/features/alerts/domain/safety_alert.dart';
import 'package:safecircle/features/alerts/presentation/alert_detail_screen.dart';
import 'package:safecircle/features/circles/data/circle_repository.dart';
import 'package:safecircle/features/circles/domain/circle_invite.dart';
import 'package:safecircle/features/journeys/data/journey_repository.dart';
import 'package:safecircle/features/journeys/domain/friends_feed.dart';
import 'package:safecircle/features/journeys/presentation/widgets/friend_journey_cards.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, this.onGoCircles, this.showHeader = true, this.onToggleHome});

  final VoidCallback? onGoCircles;

  final bool showHeader;

  final VoidCallback? onToggleHome;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.now(const Duration(seconds: 30));
    final mine = ref.watch(myActiveJourneyProvider).value;
    final invites = ref.watch(pendingInvitesProvider).value ?? const <CircleInvite>[];
    final alertsAsync = ref.watch(incomingAlertsProvider);
    final alerts = alertsAsync.value ?? const <SafetyAlert>[];
    final journeysAsync = ref.watch(friendsJourneysProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader)
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 6, 22, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/images/logo.png', height: 30),
                Row(
                  children: [
                    if (onToggleHome != null) ...[
                      ScCircleIconButton(icon: FeatherIcons.map, onTap: onToggleHome!),
                      const SizedBox(width: 10),
                    ],
                    ScCircleIconButton(
                      icon: FeatherIcons.bell,
                      showDot: alerts.isNotEmpty || invites.isNotEmpty,
                      onTap: () => _openNotifications(context, alerts, invites),
                    ),
                  ],
                ),
              ],
            ),
          ),
        if (mine != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: MyJourneyCard(journey: mine, now: now),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
          child: Text("Friends' Journeys", style: ScText.title()),
        ),
        Expanded(
          child: alertsAsync.hasError
              ? ScStreamError(error: alertsAsync.error!)
              : ScAsyncView(
                  value: journeysAsync,
                  data: (journeys) => _FeedList(feed: FriendsFeed(journeys, alerts, now)),
                ),
        ),
      ],
    );
  }

  void _openNotifications(
      BuildContext context, List<SafetyAlert> alerts, List<CircleInvite> invites) {
    if (alerts.isEmpty && invites.isEmpty) {
      showScToast(context, 'No new notifications.');
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
              Text('Notifications',
                  style: ScText.sans(size: 20, weight: FontWeight.w800, color: ScColors.textHeading)),
              const SizedBox(height: 12),
              for (final a in alerts) ...[
                NotificationRow(
                  tint: ScColors.brandTint,
                  icon: alertIcon(a),
                  iconColor: ScColors.brand,
                  title: a.headline,
                  sub: '${a.kindLabel} · ${a.timeLabel}',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => AlertDetailScreen(alert: a)));
                  },
                ),
                const SizedBox(height: 10),
              ],
              for (final i in invites) ...[
                NotificationRow(
                  tint: ScColors.amber100,
                  icon: FeatherIcons.userPlus,
                  iconColor: ScColors.amber800,
                  title: 'Circle invite',
                  sub: i.summary,
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    onGoCircles?.call();
                  },
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedList extends StatelessWidget {
  const _FeedList({required this.feed});
  final FriendsFeed feed;

  @override
  Widget build(BuildContext context) {
    if (feed.isEmpty) return const FriendsJourneysEmpty();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 6, 24, 0),
          child: Text(feed.summary,
              style: ScText.sans(size: 13.5, weight: FontWeight.w500, color: ScColors.textMuted)),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            children: [
              for (final a in feed.standaloneAlerts) ...[
                StandaloneAlertCard(alert: a),
                const SizedBox(height: 13),
              ],
              for (final j in feed.overdue) ...[
                OverdueJourneyCard(journey: j, panicMode: feed.isPanic(j)),
                const SizedBox(height: 13),
              ],
              for (final j in feed.onTime) ...[
                JourneyCard(journey: j),
                const SizedBox(height: 13),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
