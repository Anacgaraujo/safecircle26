import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/location/location_service.dart';
import 'package:safecircle/core/notifications/notification_service.dart';
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/features/alerts/data/alert_repository.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/journeys/data/journey_repository.dart';
import 'package:safecircle/features/journeys/domain/journey.dart';
import 'package:safecircle/features/journeys/domain/journey_schedule.dart';

abstract interface class JourneyReminders {
  Future<void> schedule(String journeyId, List<CheckIn> checkIns);
  Future<void> cancel(String journeyId, int index);
  Future<void> cancelAll(String journeyId, int count);
}

class _NotificationReminders implements JourneyReminders {
  NotificationService get _n => NotificationService.instance;

  @override
  Future<void> schedule(String journeyId, List<CheckIn> checkIns) =>
      _n.scheduleJourneyReminders(journeyId, checkIns);

  @override
  Future<void> cancel(String journeyId, int index) => _n.cancelReminder(journeyId, index);

  @override
  Future<void> cancelAll(String journeyId, int count) =>
      _n.cancelJourneyReminders(journeyId, count);
}

final journeyServiceProvider = Provider<JourneyService>((ref) => JourneyService(
      journeys: ref.watch(journeyRepositoryProvider),
      alerts: ref.watch(alertRepositoryProvider),
      session: ref.watch(sessionProvider),
      reminders: _NotificationReminders(),
      locate: LocationService.instance.getCurrent,
    ));

class JourneyService {
  JourneyService({
    required this.journeys,
    required this.alerts,
    required this.session,
    required this.reminders,
    required this.locate,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final JourneyRepository journeys;
  final AlertRepository alerts;
  final Session session;
  final JourneyReminders reminders;
  final Future<ScLocation?> Function() locate;
  final DateTime Function() _now;

  Future<Journey?> resumeActive() async {
    final j = await journeys.activeJourneyOf(session.uid);
    if (j != null) await reminders.schedule(j.id, j.checkIns);
    return j;
  }

  Future<({String id, ScLocation? location})> start({
    required Circle circle,
    required List<CheckIn> checkIns,
    String note = '',
  }) async {
    sortChronologically(checkIns);
    final location = await locate();
    final id = await journeys.startJourney(
        circle: circle, checkIns: checkIns, location: location, note: note);
    await reminders.schedule(id, checkIns);
    return (id: id, location: location);
  }

  Future<ScLocation?> confirmCheckIn({
    required String journeyId,
    required List<CheckIn> checkIns,
    required int index,
    required bool panic,
  }) async {
    checkIns[index].confirmed = true;
    await reminders.cancel(journeyId, index);
    final location = await locate();
    if (location != null) {
      checkIns[index]
        ..lat = location.lat
        ..lng = location.lng
        ..place = location.label;
    }
    await journeys.confirmCheckIn(
        journeyId: journeyId, checkIns: checkIns, panic: panic, location: location);
    return location;
  }

  Future<void> finish({
    required String journeyId,
    required List<CheckIn> checkIns,
    DateTime? startedAt,
    bool panic = false,
    bool panicRaised = false,
  }) async {
    await reminders.cancelAll(journeyId, checkIns.length);
    if (panic) {
      await journeys.raisePanicOnJourney(journeyId, location: await locate());
    }
    await journeys.finishJourney(journeyId, duration: journeyDuration(startedAt, _now()));
    if (!panic && !panicRaised) await alerts.resolveMyAlerts(types: const {'sos'});
  }
}
