import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/location/location_service.dart';
import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/utils/formatters.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/alerts/application/sos_service.dart';
import 'package:safecircle/features/alerts/data/alert_repository.dart';
import 'package:safecircle/features/alerts/domain/safety_alert.dart';
import 'package:safecircle/features/alerts/presentation/widgets/alert_sent_view.dart';
import 'package:safecircle/features/alerts/presentation/widgets/sos_view.dart';
import 'package:safecircle/l10n/l10n.dart';

class EmergencyScreen extends ConsumerStatefulWidget {
  const EmergencyScreen({super.key, this.holdSeconds = 1.5});
  final double holdSeconds;

  @override
  ConsumerState<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends ConsumerState<EmergencyScreen>
    with SingleTickerProviderStateMixin {
  bool sent = false;
  String sentAt = '';
  ScLocation? location;
  int reached = 0;

  late final AnimationController _hold = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: (widget.holdSeconds * 1000).round()),
  )..addStatusListener((status) {
      if (status == AnimationStatus.completed) _fire();
    });

  @override
  void initState() {
    super.initState();
    ref.listenManual(myOpenSosProvider, (_, next) {
      if (next.hasError) debugPrint('[SafeCircle] open sos stream: ${next.error}');
      final open = next.value;
      if (open != null) Future.microtask(() => _syncOpenSos(open));
    }, fireImmediately: true);
  }

  void _syncOpenSos(List<SafetyAlert> open) {
    if (!mounted) return;
    if (open.isNotEmpty && !sent) {
      final a = open.first;
      setState(() {
        sent = true;
        sentAt = a.timeText;
        reached = a.watcherCount;
        location = (a.lat != null && a.lng != null)
            ? ScLocation(lat: a.lat!, lng: a.lng!, label: a.location)
            : null;
      });
    } else if (open.isEmpty && sent) {
      setState(() => sent = false);
    }
  }

  @override
  void dispose() {
    _hold.dispose();
    super.dispose();
  }

  void _beginHold() => _hold.forward(from: 0);

  void _endHold() {
    if (_hold.status != AnimationStatus.completed) _hold.value = 0;
  }

  Future<void> _fire() async {
    final sos = ref.read(sosServiceProvider);
    setState(() {
      sentAt = scClock(DateTime.now());
      sent = true;
      _hold.value = 0;
    });
    final loc = await sos.currentPosition();
    if (mounted) setState(() => location = loc);
    try {
      final n = await sos.send(loc);
      if (mounted) setState(() => reached = n);
    } catch (e) {
      debugPrint('[SafeCircle] fireSos: $e');
      if (mounted) {
        setState(() => sent = false);
        showScToast(context, context.l10n.couldNotSendAlert);
      }
    }
  }

  void _cancel() {
    ref.read(sosServiceProvider).cancel();
    setState(() => sent = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 340),
      switchInCurve: ScMotion.easeOut,
      child: sent
          ? AlertSentView(
              key: const ValueKey('sent'),
              sentAt: sentAt,
              location: location,
              reached: reached,
              onCancel: _cancel,
            )
          : SosView(
              key: const ValueKey('sos'),
              hold: _hold,
              onHoldStart: _beginHold,
              onHoldEnd: _endHold,
            ),
    );
  }
}
