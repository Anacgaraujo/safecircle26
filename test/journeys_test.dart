import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safecircle/core/widgets/sc_bottom_nav.dart';
import 'package:safecircle/core/data/lookup_hash.dart';
import 'package:safecircle/core/location/location_service.dart';
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/features/alerts/data/alert_repository.dart';
import 'package:safecircle/features/alerts/domain/safety_alert.dart';
import 'package:safecircle/features/circles/data/circle_repository.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/circles/domain/circle_invite.dart';
import 'package:safecircle/features/contacts/data/contacts_repository.dart';
import 'package:safecircle/features/journeys/application/journey_service.dart';
import 'package:safecircle/features/journeys/data/journey_monitor.dart';
import 'package:safecircle/features/journeys/data/journey_repository.dart';
import 'package:safecircle/features/journeys/domain/friends_feed.dart';
import 'package:safecircle/features/journeys/domain/journey.dart';
import 'package:safecircle/features/journeys/domain/journey_schedule.dart';
import 'package:safecircle/features/journeys/domain/pin_check.dart';
import 'package:safecircle/features/journeys/presentation/friends_journeys_screen.dart';
import 'package:safecircle/features/journeys/presentation/journey_flow/pick_circle_step.dart';

class _Reminders implements JourneyReminders {
  final scheduled = <String, int>{};
  final cancelled = <int>[];
  int cancelledAll = 0;

  @override
  Future<void> schedule(String journeyId, List<CheckIn> checkIns) async =>
      scheduled[journeyId] = checkIns.length;

  @override
  Future<void> cancel(String journeyId, int index) async => cancelled.add(index);

  @override
  Future<void> cancelAll(String journeyId, int count) async => cancelledAll = count;
}

CheckIn _at(String label, DateTime at, {bool confirmed = false}) =>
    checkInAt(label, at, now: at)..confirmed = confirmed;

Journey _journey(String owner, List<CheckIn> checkIns) => Journey(
      id: 'j-$owner',
      ownerId: owner,
      ownerName: owner,
      circleId: 'c1',
      circleName: 'Family',
      status: 'active',
      checkIns: checkIns,
      alertRaised: false,
    );

SafetyAlert _alert(String from, String type) => SafetyAlert(
    id: 'a-$from', fromUid: from, fromName: from, type: type, resolved: false, location: '');

void main() {
  final now = DateTime(2026, 10, 23, 20, 10);

  group('schedule', () {
    test('suggests check-ins from the next half hour', () {
      final c = defaultCheckIns(now);
      expect(c.map((e) => e.time), ['9:30 PM', '11:00 PM', '12:30 AM']);
      expect(c.map((e) => e.date), ['Today', 'Today', 'Tomorrow']);
    });

    test('an extra check-in goes before the check-out', () {
      final c = defaultCheckIns(now);
      addCheckIn(c, now);
      expect(c.map((e) => e.label), ['First check-in', 'Second check-in', 'Check-in 3', 'Check-out']);
    });

    test('a picked time already gone today means tomorrow', () {
      expect(nextOccurrence(0, 30, now), DateTime(2026, 10, 24, 0, 30));
      expect(nextOccurrence(21, 0, now), DateTime(2026, 10, 23, 21, 0));
      expect(nextOccurrence(20, 10, now.add(const Duration(seconds: 30))), isNotNull,
          reason: '20:10 already passed, so it is tomorrow');
      expect(nextOccurrence(20, 11, now.add(const Duration(seconds: 30))), isNull,
          reason: 'less than a minute away');
    });

    test('dates beyond tomorrow use the US month/day order', () {
      expect(dayLabel(DateTime(2026, 10, 28), now), '10/28');
    });

    test('a check-in in the past blocks starting', () {
      final c = [_at('First', now.add(const Duration(hours: 1))), _at('Late', now)];
      expect(firstPastCheckIn(c, now)?.label, 'Late');
      expect(firstPastCheckIn(c.take(1).toList(), now), isNull);
    });

    test('duration reads as hours and minutes', () {
      expect(journeyDuration(now, now.add(const Duration(minutes: 65))), '1h 05m');
      expect(journeyDuration(null, now), '0h 00m');
    });

    test('timeline marks done, missed and upcoming check-ins', () {
      final c = [
        _at('A', now.subtract(const Duration(hours: 1)), confirmed: true),
        _at('B', now.subtract(const Duration(minutes: 10))),
        _at('C', now.add(const Duration(hours: 1))),
      ];
      expect(checkInTimeline(c, now).map((e) => e.$2),
          [CheckInState.done, CheckInState.missed, CheckInState.future]);
      expect(checkInTimeline(c, now.subtract(const Duration(minutes: 30))).map((e) => e.$2),
          [CheckInState.done, CheckInState.next, CheckInState.future]);
    });
  });

  test('the panic PIN is told apart from the safety PIN', () {
    final s = Session()..setProfile(uid: 'ana', name: 'Ana', email: 'ana@example.com');
    s.setPins(safety: hashPin('ana', '1234'), panic: hashPin('ana', '9876'));
    expect(checkPin(s, '1234'), PinResult.safety);
    expect(checkPin(s, '9876'), PinResult.panic);
    expect(checkPin(s, '0000'), PinResult.wrong);
  });

  group('friends feed', () {
    final onTime = _journey('bia', [_at('A', now.add(const Duration(hours: 1)))]);
    final late = _journey('carlos', [_at('A', now.subtract(const Duration(minutes: 10)))]);

    test('overdue friends come first', () {
      final feed = FriendsFeed([onTime, late], const [], now);
      expect(feed.overdue, [late]);
      expect(feed.onTime, [onTime]);
      expect(feed.summary, '1 friend needs attention · 2 active');
    });

    test('an alert flags the journey; one without a journey stands alone', () {
      final feed = FriendsFeed([onTime], [_alert('bia', 'panic'), _alert('dani', 'sos')], now);
      expect(feed.overdue, [onTime]);
      expect(feed.isPanic(onTime), isTrue);
      expect(feed.standaloneAlerts.single.fromUid, 'dani');
      expect(feed.summary, '2 friends need attention · 1 active');
    });

    test('nobody on a journey', () {
      final feed = FriendsFeed(const [], const [], now);
      expect(feed.isEmpty, isTrue);
      expect(feed.summary, '0 friends currently on a journey');
    });
  });

  group('journey service', () {
    late FakeFirebaseFirestore db;
    late _Reminders reminders;
    const here = ScLocation(lat: 40.7128, lng: -74.006, label: 'Lower Manhattan');

    JourneyService service({ScLocation? location = here}) {
      final alerts = AlertRepository(db,
          contacts: ContactsRepository(db, currentUid: () => 'ana'), currentUid: () => 'ana');
      return JourneyService(
        journeys: JourneyRepository(db, alerts: alerts, currentUid: () => 'ana'),
        alerts: alerts,
        session: Session.instance,
        reminders: reminders,
        locate: () async => location,
        now: () => now,
      );
    }

    Future<Map<String, dynamic>> doc(String id) async =>
        (await db.collection('journeys').doc(id).get()).data()!;

    Future<List<String>> alertTypes() async =>
        (await db.collection('alerts').get()).docs.map((d) => d['type'] as String).toList();

    setUp(() async {
      db = FakeFirebaseFirestore();
      reminders = _Reminders();
      Session.instance.setProfile(uid: 'ana', name: 'Ana Ribeiro', email: 'ana@example.com');
      await db.collection('circles').add({'name': 'Family', 'ownerId': 'ana', 'memberIds': ['ana', 'bia']});
    });

    final family = Circle(name: 'Family', memberIds: ['ana', 'bia'])..id = 'c1';
    List<CheckIn> plan() => [
          _at('Check-out', now.add(const Duration(hours: 4))),
          _at('First check-in', now.add(const Duration(hours: 1))),
        ];

    test('starting sorts the check-ins, shares the position and arms reminders', () async {
      final started = await service().start(circle: family, checkIns: plan(), note: 'Bar');
      final j = await doc(started.id);
      expect(started.location, here);
      expect((j['checkIns'] as List).map((c) => c['label']), ['First check-in', 'Check-out']);
      expect(j['lastPlace'], 'Lower Manhattan');
      expect(j['note'], 'Bar');
      expect(reminders.scheduled[started.id], 2);
    });

    test('a check-in is confirmed where it happened', () async {
      final checkIns = plan();
      final started = await service().start(circle: family, checkIns: checkIns);
      await service().confirmCheckIn(journeyId: started.id, checkIns: checkIns, index: 0, panic: false);

      final first = (await doc(started.id))['checkIns'][0] as Map;
      expect(first['confirmed'], isTrue);
      expect(first['place'], 'Lower Manhattan');
      expect(reminders.cancelled, [0]);
      expect(await alertTypes(), isEmpty);
    });

    test('confirming with the panic PIN raises a silent alert', () async {
      final checkIns = plan();
      final started = await service().start(circle: family, checkIns: checkIns);
      await service().confirmCheckIn(journeyId: started.id, checkIns: checkIns, index: 0, panic: true);
      expect((await doc(started.id))['alertRaised'], isTrue);
      expect(await alertTypes(), ['panic']);
    });

    test('ending normally clears my SOS; ending with the panic PIN keeps the alert open', () async {
      final started = await service().start(circle: family, checkIns: plan());
      await service().alerts.fireSos();
      await service().finish(
          journeyId: started.id,
          checkIns: plan(),
          startedAt: now.subtract(const Duration(minutes: 95)));
      final j = await doc(started.id);
      expect(j['status'], 'finished');
      expect(j['duration'], '1h 35m');
      expect(reminders.cancelledAll, 2);
      expect((await db.collection('alerts').get()).docs.single['resolved'], isTrue);

      final second = await service().start(circle: family, checkIns: plan());
      await service().finish(journeyId: second.id, checkIns: plan(), panic: true);
      final open = (await db.collection('alerts').where('resolved', isEqualTo: false).get()).docs;
      expect(open.single['type'], 'panic');
    });

    test('an unfinished journey is resumed with its reminders', () async {
      final started = await service().start(circle: family, checkIns: plan());
      reminders.scheduled.clear();
      final resumed = await service().resumeActive();
      expect(resumed?.id, started.id);
      expect(reminders.scheduled[started.id], 2);
    });

    test('the monitor alerts the circle once a check-in is missed', () async {
      final missed = [_at('First check-in', DateTime.now().subtract(const Duration(minutes: 10)))];
      await service().start(circle: family, checkIns: missed);
      final alerts = AlertRepository(db,
          contacts: ContactsRepository(db, currentUid: () => 'ana'), currentUid: () => 'ana');
      final monitor = JourneyMonitor(
        journeys: JourneyRepository(db, alerts: alerts, currentUid: () => 'ana'),
        locate: () async => here,
      )..start();
      addTearDown(monitor.stop);

      await pumpEventQueue();
      await monitor.checkNow();
      expect(await alertTypes(), ['overdue']);
    });
  });

  group('journey history', () {
    late FakeFirebaseFirestore db;
    JourneyRepository repo() {
      final alerts = AlertRepository(db,
          contacts: ContactsRepository(db, currentUid: () => 'ana'), currentUid: () => 'ana');
      return JourneyRepository(db, alerts: alerts, currentUid: () => 'ana');
    }

    Future<void> add(String id, String owner, String status) =>
        db.collection('journeys').doc(id).set({'ownerId': owner, 'status': status});

    Future<List<String>> ids() async => (await db.collection('journeys').get()).docs.map((d) => d.id).toList();

    setUp(() async {
      db = FakeFirebaseFirestore();
      await add('old1', 'ana', 'finished');
      await add('old2', 'ana', 'finished');
      await add('now', 'ana', 'active');
      await add('bia1', 'bia', 'finished');
    });

    test('deletes one finished journey, never an active one or someone else\'s', () async {
      await repo().deleteFinishedJourney('old1');
      await repo().deleteFinishedJourney('now');
      await repo().deleteFinishedJourney('bia1');
      expect(await ids(), unorderedEquals(['old2', 'now', 'bia1']));
    });

    test('deletes all my finished journeys', () async {
      expect(await repo().deleteAllFinishedJourneys(), 2);
      expect(await ids(), unorderedEquals(['now', 'bia1']));
    });
  });

  group('screens', () {
    testWidgets('home lists the friend who needs attention first', (tester) async {
      final late = _journey('Carlos Lima', [
        checkInAt('First check-in', DateTime.now().subtract(const Duration(minutes: 10)), now: now),
      ]);
      final onTime = _journey('Bia Souza', [
        checkInAt('First check-in', DateTime.now().add(const Duration(hours: 1)), now: now),
      ]);
      await tester.pumpWidget(ProviderScope(
        overrides: [
          myActiveJourneyProvider.overrideWith((ref) => Stream.value(null)),
          friendsJourneysProvider.overrideWith((ref) => Stream.value([onTime, late])),
          incomingAlertsProvider.overrideWith((ref) => Stream.value(const <SafetyAlert>[])),
          pendingInvitesProvider.overrideWith((ref) => Stream.value(const <CircleInvite>[])),
        ],
        child: const MaterialApp(home: Scaffold(body: HomeScreen())),
      ));
      await tester.pump();
      expect(find.text('1 friend needs attention · 2 active'), findsOneWidget);
      expect(find.text('Overdue'), findsOneWidget);
      expect(tester.getTopLeft(find.text('Carlos Lima')).dy,
          lessThan(tester.getTopLeft(find.text('Bia Souza')).dy));
    });

    testWidgets('a journey cannot start without watchers or contacts', (tester) async {
      Session.instance.setProfile(uid: 'ana', name: 'Ana', email: 'ana@example.com');
      await tester.pumpWidget(ProviderScope(
        overrides: [
          myCirclesProvider.overrideWith((ref) => Stream.value([
                Circle(name: 'Family', memberIds: ['ana'])..id = 'c1',
              ])),
          contactsProvider.overrideWith((ref) => Stream.value([Person(name: 'Carlos')])),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: PickCircleStep(
              checkIns: defaultCheckIns(now),
              selectedCircleId: null,
              starting: false,
              onSelect: (_) {},
              onBack: () {},
              onStart: (_) => fail('must not start'),
            ),
          ),
        ),
      ));
      await tester.pump();
      expect(find.textContaining('Nobody in this circle has accepted'), findsOneWidget);
      expect(find.text('Add 2 emergency contacts before starting'), findsOneWidget);
      await tester.tap(find.text('Start journey'));
      await tester.pump();
    });

    testWidgets('without a circle it points to the Circles tab instead of starting', (tester) async {
      Session.instance.setProfile(uid: 'ana', name: 'Ana', email: 'ana@example.com');
      await tester.pumpWidget(ProviderScope(
        overrides: [
          myCirclesProvider.overrideWith((ref) => Stream.value(const <Circle>[])),
          contactsProvider.overrideWith((ref) => Stream.value([Person(name: 'Carlos'), Person(name: 'Bia')])),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: PickCircleStep(
              checkIns: defaultCheckIns(now),
              selectedCircleId: null,
              starting: false,
              onSelect: (_) {},
              onBack: () {},
              onStart: (_) => fail('must not start'),
            ),
          ),
        ),
      ));
      await tester.pump();
      expect(find.textContaining('Tap the Circles tab below'), findsOneWidget);
      expect(find.byType(CirclesIcon), findsOneWidget);
      expect(find.text('Start journey'), findsNothing);
    });
  });
}
