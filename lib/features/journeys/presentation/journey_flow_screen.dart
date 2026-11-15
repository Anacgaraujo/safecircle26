import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/location/location_service.dart';
import 'package:safecircle/core/permissions/permissions.dart';
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/async_view.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/circles/data/circle_repository.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/journeys/application/journey_service.dart';
import 'package:safecircle/features/journeys/data/journey_repository.dart';
import 'package:safecircle/features/journeys/domain/journey.dart';
import 'package:safecircle/features/journeys/domain/journey_schedule.dart';
import 'package:safecircle/features/journeys/domain/pin_check.dart';
import 'package:safecircle/features/journeys/presentation/journey_flow/active_journey_step.dart';
import 'package:safecircle/features/journeys/presentation/journey_flow/check_in_pin_step.dart';
import 'package:safecircle/features/journeys/presentation/journey_flow/journey_result_views.dart';
import 'package:safecircle/features/journeys/presentation/journey_flow/pick_circle_step.dart';
import 'package:safecircle/features/journeys/presentation/journey_flow/plan_timing_step.dart';
import 'package:safecircle/features/journeys/presentation/journey_history_view.dart';
import 'package:safecircle/features/live_map/data/tracking_service.dart';

class JourneyFlow extends ConsumerStatefulWidget {
  const JourneyFlow({super.key, this.startAtHistory = false});
  final bool startAtHistory;

  @override
  ConsumerState<JourneyFlow> createState() => _JourneyFlowState();
}

enum _JStep { timing, circle, active, confirmPin, confirmed, finished, history }

class _JourneyFlowState extends ConsumerState<JourneyFlow> {
  late _JStep step = widget.startAtHistory ? _JStep.history : _JStep.timing;
  late bool checkingResume = !widget.startAtHistory;

  List<CheckIn> checkIns = defaultCheckIns(DateTime.now());
  final noteCtrl = TextEditingController();
  String? selectedCircleId;
  bool starting = false;

  String? journeyId;
  String? circleId;
  String circleName = '';
  DateTime? startedAt;
  ScLocation? lastLocation;

  String pin = '';
  bool pinError = false;
  int? activeIndex;

  bool finishing = false;

  Timer? _clock;
  int? _lastDueMillis;

  JourneyService get _service => ref.read(journeyServiceProvider);

  @override
  void initState() {
    super.initState();
    _clock = Timer.periodic(const Duration(seconds: 15), (_) => _tick());
    if (!widget.startAtHistory) _tryResume();
  }

  @override
  void dispose() {
    _clock?.cancel();
    noteCtrl.dispose();
    super.dispose();
  }

  void _tick() {
    if (!mounted || step != _JStep.active) return;
    final next = checkIns.where((c) => !c.confirmed).firstOrNull;
    if (next != null && next.isDueNow(DateTime.now()) && _lastDueMillis != next.atMillis) {
      _lastDueMillis = next.atMillis;
      HapticFeedback.vibrate();
    }
    setState(() {});
  }

  void _go(_JStep s) => setState(() => step = s);

  Future<void> _tryResume() async {
    try {
      final j = await _service.resumeActive();
      if (j != null && mounted) {
        setState(() {
          journeyId = j.id;
          circleId = j.circleId;
          circleName = j.circleName;
          checkIns = j.checkIns;
          startedAt = j.startedAt ?? DateTime.now();
          noteCtrl.text = j.note;
          if (j.lastLat != null && j.lastLng != null) {
            lastLocation = ScLocation(lat: j.lastLat!, lng: j.lastLng!, label: j.lastPlace);
          }
          step = _JStep.active;
        });
      }
    } catch (_) {}
    if (mounted) setState(() => checkingResume = false);
  }

  Future<void> _startJourney(Circle circle) async {
    if (starting) return;
    final past = firstPastCheckIn(checkIns, DateTime.now());
    if (past != null) {
      showScToast(context, '"${past.label}" is already in the past — adjust its time.');
      return;
    }
    if (!await ensureJourneyPermissions(context)) return;
    if (!mounted) return;
    TrackingService.instance.start();
    setState(() => starting = true);
    try {
      final started =
          await _service.start(circle: circle, checkIns: checkIns, note: noteCtrl.text.trim());
      if (!mounted) return;
      if (started.location == null) {
        showScToast(context, 'Location unavailable — journey starts without a map position.');
      }
      setState(() {
        journeyId = started.id;
        circleId = circle.id;
        circleName = circle.name;
        startedAt = DateTime.now();
        lastLocation = started.location;
        starting = false;
        step = _JStep.active;
      });
    } catch (_) {
      if (mounted) {
        showScToast(context, 'Could not start the journey. Try again.');
        setState(() => starting = false);
      }
    }
  }

  Future<void> _finishJourney({bool panic = false, bool panicRaised = false}) async {
    if (journeyId != null) {
      await _service.finish(
        journeyId: journeyId!,
        checkIns: checkIns,
        startedAt: startedAt,
        panic: panic,
        panicRaised: panicRaised,
      );
    }
    if (mounted) _go(_JStep.finished);
  }

  void _openPin({int? checkIn}) {
    setState(() {
      activeIndex = checkIn;
      finishing = checkIn == null;
      pin = '';
      pinError = false;
      step = _JStep.confirmPin;
    });
  }

  void _onDigit(String d) {
    if (pin.length >= 4) return;
    setState(() {
      pin += d;
      pinError = false;
    });
    if (pin.length < 4) return;
    final result = checkPin(ref.read(sessionProvider), pin);
    Future.delayed(const Duration(milliseconds: 180), () async {
      if (!mounted) return;
      if (result == PinResult.wrong) {
        setState(() => pinError = true);
        return;
      }
      final panic = result == PinResult.panic;
      if (finishing) {
        setState(() {
          pin = '';
          finishing = false;
        });
        await _finishJourney(panic: panic);
      } else {
        await _confirmCheckIn(panic: panic);
      }
    });
  }

  Future<void> _confirmCheckIn({required bool panic}) async {
    final index = activeIndex;
    if (index == null || journeyId == null) return;
    final confirming =
        _service.confirmCheckIn(journeyId: journeyId!, checkIns: checkIns, index: index, panic: panic);
    setState(() {
      pin = '';
      step = _JStep.confirmed;
    });
    final location = await confirming;
    if (location != null && mounted) setState(() => lastLocation = location);
    if (mounted && step == _JStep.confirmed && checkIns.every((c) => c.confirmed)) {
      await _finishJourney(panicRaised: panic);
    }
  }

  void _onPinDelete() {
    if (pin.isEmpty) return;
    setState(() {
      pin = pin.substring(0, pin.length - 1);
      pinError = false;
    });
  }

  void _planNew() {
    setState(() {
      checkIns = defaultCheckIns(DateTime.now());
      journeyId = null;
      lastLocation = null;
      step = _JStep.timing;
    });
  }

  Circle _activeCircle() {
    final circles = ref.watch(myCirclesProvider).value ?? const <Circle>[];
    return circles.where((c) => c.id == circleId).firstOrNull ?? Circle(name: circleName);
  }

  ScLocation? _livePosition() {
    final id = journeyId;
    final live = id == null ? null : ref.watch(journeyProvider(id)).value;
    if (live?.lastLat == null || live?.lastLng == null) return lastLocation;
    return ScLocation(lat: live!.lastLat!, lng: live.lastLng!, label: live.lastPlace);
  }

  @override
  Widget build(BuildContext context) {
    if (checkingResume) return const Scaffold(body: ScSpinner());

    final Widget body = switch (step) {
      _JStep.timing => PlanTimingStep(
          checkIns: checkIns,
          noteCtrl: noteCtrl,
          onChanged: () => setState(() {}),
          onNext: () => _go(_JStep.circle),
        ),
      _JStep.circle => PickCircleStep(
          checkIns: checkIns,
          selectedCircleId: selectedCircleId,
          starting: starting,
          onSelect: (c) => setState(() => selectedCircleId = c.id),
          onBack: () => _go(_JStep.timing),
          onStart: _startJourney,
        ),
      _JStep.active => ActiveJourneyStep(
          circle: _activeCircle(),
          checkIns: checkIns,
          location: _livePosition(),
          now: DateTime.now(),
          onConfirm: (i) => _openPin(checkIn: i),
          onFinish: () => _openPin(),
        ),
      _JStep.confirmPin => CheckInPinStep(
          finishing: finishing,
          checkIn: activeIndex == null ? null : checkIns[activeIndex!],
          pinLength: pin.length,
          pinError: pinError,
          onDigit: _onDigit,
          onDelete: _onPinDelete,
          onBack: () => setState(() {
            pin = '';
            finishing = false;
            step = _JStep.active;
          }),
        ),
      _JStep.confirmed => CheckInConfirmedView(
          checkIns: checkIns,
          confirmedIndex: activeIndex,
          onBack: () => _go(_JStep.active),
        ),
      _JStep.finished => const JourneyFinishedView(),
      _JStep.history => JourneyHistoryView(onPlanNew: _planNew),
    };

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 340),
        switchInCurve: ScMotion.easeOut,
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween(begin: const Offset(0, .02), end: Offset.zero).animate(anim),
            child: child,
          ),
        ),
        child: KeyedSubtree(
          key: ValueKey(step),
          child: step == _JStep.active ? body : SafeArea(child: body),
        ),
      ),
    );
  }
}
