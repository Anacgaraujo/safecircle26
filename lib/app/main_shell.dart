import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/notifications/notification_service.dart';
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/utils/clock.dart';
import 'package:safecircle/core/widgets/sc_bottom_nav.dart';
import 'package:safecircle/features/activity/data/activity_repository.dart';
import 'package:safecircle/features/alerts/data/alert_repository.dart';
import 'package:safecircle/features/alerts/domain/safety_alert.dart';
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
import 'package:safecircle/features/profile/data/user_repository.dart';
import 'package:safecircle/features/profile/presentation/profile_screen.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> with WidgetsBindingObserver {
  ScTab tab = ScTab.home;
  late bool _mapHome = ref.read(sessionProvider).mapHome;

  List<Journey> _watched = const [];
  List<SafetyAlert> _incoming = const [];

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
    JourneyMonitor.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget body = switch (tab) {
      ScTab.home => _mapHome
          ? MapHomeScreen(
              onGoCircles: () => setState(() => tab = ScTab.circles),
              onToggleHome: _toggleHome,
            )
          : HomeScreen(
              onGoCircles: () => setState(() => tab = ScTab.circles),
              onToggleHome: _toggleHome,
            ),
      ScTab.circles => const CirclesScreen(),
      ScTab.emergency => const EmergencyScreen(),
      ScTab.profile => ProfileScreen(onGoCircles: () => setState(() => tab = ScTab.circles)),
    };

    final circles = ref.watch(myCirclesProvider).value;
    final showCoachmark = tab == ScTab.home && !_mapHome && (circles?.isEmpty ?? false);
    return Scaffold(
      backgroundColor: ScColors.canvas,
      body: SafeArea(bottom: false, child: body),
      bottomNavigationBar: ScBottomNav(
        active: tab,
        onTab: (t) => setState(() => tab = t),
        onFab: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const JourneyFlow()),
        ),
        coachmark: showCoachmark ? 'Add your first circle' : null,
        mapHome: _mapHome,
      ),
    );
  }
}
