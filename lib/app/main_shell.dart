import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safecircle/core/notifications/notification_service.dart';
import 'package:safecircle/core/notifications/push_service.dart';
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/utils/clock.dart';
import 'package:safecircle/core/widgets/sc_bottom_nav.dart';
import 'package:safecircle/features/activity/data/activity_repository.dart';
import 'package:safecircle/features/alerts/data/alert_repository.dart';
import 'package:safecircle/features/alerts/domain/safety_alert.dart';
import 'package:safecircle/features/alerts/presentation/alert_detail_screen.dart';
import 'package:safecircle/features/alerts/presentation/emergency_screen.dart';
import 'package:safecircle/features/circles/data/circle_repository.dart';
import 'package:safecircle/features/circles/presentation/circles_screen.dart';
import 'package:safecircle/features/journeys/data/journey_monitor.dart';
import 'package:safecircle/features/journeys/data/journey_repository.dart';
import 'package:safecircle/features/journeys/domain/friends_feed.dart';
import 'package:safecircle/features/journeys/domain/journey.dart';
import 'package:safecircle/features/journeys/presentation/friends_journeys_screen.dart';
import 'package:safecircle/features/journeys/presentation/journey_flow_screen.dart';
import 'package:safecircle/features/live_map/application/live_sharing.dart';
import 'package:safecircle/features/live_map/presentation/map_home_screen.dart';
import 'package:safecircle/features/membership/application/membership_controller.dart';
import 'package:safecircle/features/membership/presentation/membership_paywall.dart';
import 'package:safecircle/features/profile/data/user_repository.dart';
import 'package:safecircle/features/profile/presentation/profile_screen.dart';
import 'package:safecircle/l10n/l10n.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> with WidgetsBindingObserver {
  late bool _mapHome = ref.read(sessionProvider).mapHome;

  List<Journey> _watched = const [];
  List<SafetyAlert> _incoming = const [];

  void _select(ScTab t) => ref.read(mainTabProvider.notifier).select(t);

  void _toggleHome() {
    setState(() => _mapHome = !_mapHome);
    ref.read(sessionProvider).mapHome = _mapHome;
    ref.read(userRepositoryProvider).saveSetting('mapHome', _mapHome).catchError(
        (e) => debugPrint('[SafeCircle] saveSetting mapHome: $e'));
  }

  @override
  void initState() {
    super.initState();
    final notifications = NotificationService.instance;

    ref.listenManual(incomingAlertsProvider, (_, next) {
      final alerts = next.value;
      if (alerts == null) return;
      final open = {for (final a in alerts) a.id};
      for (final gone in _incoming.where((a) => !open.contains(a.id))) {
        notifications.notifyAllClear(gone);
      }
      _incoming = alerts;
      alerts.forEach(notifications.notifyAlert);
    });

    ref.listenManual(friendsJourneysProvider, (_, next) {
      _watched = next.value ?? _watched;
      _checkOverdue();
    });
    ref.listenManual(clockProvider(const Duration(seconds: 30)), (_, __) => _checkOverdue());

    JourneyMonitor.instance.start();

    final since = DateTime.now().millisecondsSinceEpoch - 60 * 1000;
    ref.listenManual(recentActivityProvider, (_, next) {
      for (final e in (next.value ?? const []).where((e) => e.atMillis >= since)) {
        notifications.notifyActivity(e);
      }
    });

    ref.read(liveSharingProvider.notifier).startIfAllowed();
    WidgetsBinding.instance.addObserver(this);

    ref.listenManual(pendingInvitesProvider, (_, next) {
      (next.value ?? const []).forEach(notifications.notifyInvite);
    });

    final uid = ref.read(sessionProvider).uid;
    unawaited(ref.read(membershipProvider.notifier).start(uid));

    final push = PushService.instance;
    push.onOpen = _openPush;
    unawaited(push.register(uid));
    final pending = push.takePendingOpen();
    if (pending != null) WidgetsBinding.instance.addPostFrameCallback((_) => _openPush(pending));
  }

  /// A tapped push notification: show the alert, or the invitations.
  Future<void> _openPush(PushTarget target) async {
    switch (target) {
      case InviteTarget():
        _select(ScTab.circles);
      case JourneyTarget():
        // The journey screen picks up the active journey and its check-in.
        final nav = Navigator.of(context)..popUntil((r) => r.isFirst);
        await nav.push(MaterialPageRoute(builder: (_) => const JourneyFlow()));
      case AlertTarget(:final alertId):
        try {
          final snap = await FirebaseFirestore.instance.collection('alerts').doc(alertId).get();
          final data = snap.data();
          if (data == null || !mounted) return;
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => AlertDetailScreen(alert: SafetyAlert.fromMap(data, snap.id))));
        } catch (e) {
          debugPrint('[SafeCircle] open alert from push: $e');
        }
    }
  }

  void _checkOverdue() {
    overdueToNotify(_watched, _incoming, DateTime.now())
        .forEach(NotificationService.instance.notifyOverdue);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(liveSharingProvider.notifier).startIfAllowed();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    PushService.instance.onOpen = null;
    JourneyMonitor.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tab = ref.watch(mainTabProvider);
    // Without a membership, SOS (Emergency) and the profile (account,
    // emergency contacts, membership) stay open; the rest shows the paywall.
    final locked = !ref.watch(membershipProvider).hasAccess &&
        (tab == ScTab.home || tab == ScTab.circles);
    final Widget body = locked
        ? MembershipPaywall(onOpenSos: () => _select(ScTab.emergency))
        : switch (tab) {
      ScTab.home => _mapHome
          ? MapHomeScreen(
              onGoCircles: () => _select(ScTab.circles),
              onToggleHome: _toggleHome,
            )
          : HomeScreen(
              onGoCircles: () => _select(ScTab.circles),
              onToggleHome: _toggleHome,
            ),
      ScTab.circles => const CirclesScreen(),
      ScTab.emergency => const EmergencyScreen(),
      ScTab.profile => ProfileScreen(onGoCircles: () => _select(ScTab.circles)),
          };

    final circles = ref.watch(myCirclesProvider).value;
    final showCoachmark = tab == ScTab.home && !_mapHome && (circles?.isEmpty ?? false);
    return Scaffold(
      backgroundColor: ScColors.canvas,
      body: SafeArea(bottom: false, child: body),
      bottomNavigationBar: ScBottomNav(
        active: tab,
        onTab: _select,
        onFab: () => requireMembership(
          context,
          ref,
          () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const JourneyFlow()),
          ),
        ),
        coachmark: showCoachmark ? context.l10n.addYourFirstCircle : null,
        mapHome: _mapHome,
      ),
    );
  }
}
