import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart' hide Circle;
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/features/alerts/domain/safety_alert.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/journeys/domain/friends_feed.dart';
import 'package:safecircle/features/journeys/domain/journey.dart';
import 'package:safecircle/features/live_map/application/live_sharing.dart';
import 'package:safecircle/features/live_map/domain/location_sharing.dart';
import 'package:safecircle/features/live_map/domain/map_rules.dart';
import 'package:safecircle/features/live_map/domain/tracking.dart';
import 'package:safecircle/features/places/application/place_service.dart';
import 'package:safecircle/features/places/data/place_repository.dart';
import 'package:safecircle/features/trips/data/trip_repository.dart';
import 'package:safecircle/features/trips/domain/trip_rules.dart';
import 'package:safecircle/features/trips/presentation/trip_history_screen.dart';
import 'package:safecircle/features/trips/presentation/widgets/trip_card.dart';

class _FakeSharing implements LocationSharing {
  _FakeSharing({this.locationOn = true});
  final bool locationOn;

  @override
  final ValueNotifier<bool> running = ValueNotifier(false);
  @override
  bool paused = false;
  @override
  bool get isRunning => running.value;

  @override
  Future<void> start({bool userInitiated = false}) async {
    if (!paused && locationOn) running.value = true;
  }

  @override
  Future<void> stop({bool markPaused = true}) async => running.value = false;
}

MemberStatus _member(String uid, String name,
        {bool sharing = true, double? lat = 40.7, bool moving = false, DateTime? updatedAt}) =>
    MemberStatus(
        uid: uid,
        name: name,
        lat: lat,
        lng: lat == null ? null : -74.0,
        sharing: sharing,
        moving: moving,
        updatedAt: updatedAt);

Journey _journey(String owner, CheckIn checkIn, {bool alertRaised = false}) => Journey(
      id: 'j-$owner',
      ownerId: owner,
      ownerName: '$owner Smith',
      circleId: 'c1',
      circleName: 'Family',
      status: 'active',
      checkIns: [checkIn],
      alertRaised: alertRaised,
    );

CheckIn _checkInAt(DateTime at) =>
    CheckIn(label: 'First', date: 'Today', time: '', atMillis: at.millisecondsSinceEpoch);

void main() {
  final now = DateTime(2026, 10, 23, 20, 10);

  group('map rules', () {
    final family = Circle(name: 'Family', memberIds: ['ana', 'bia', 'carlos']);

    test('shows the circle members sharing a position, me last', () {
      final all = [
        _member('ana', 'Ana'),
        _member('carlos', 'Carlos'),
        _member('bia', 'Bia'),
        _member('dani', 'Dani'),
        _member('eva', 'Eva', sharing: false),
        _member('fred', 'Fred', lat: null),
      ];
      expect(visibleMembers(all, family, 'ana').map((m) => m.uid), ['bia', 'carlos', 'ana']);
    });

    test('finds a member phone by uid, or by name for entries without one', () {
      final circle = Circle(name: 'Family', members: [
        Person(name: 'Bia Souza', uid: 'bia', digits: '7185550142'),
        Person(name: 'Carlos Lima', digits: '2125550000'),
      ]);
      expect(phoneOfMember(_member('bia', 'Bia'), [circle]), contains('718'));
      expect(phoneOfMember(_member('x', ' carlos lima '), [circle]), contains('212'));
      expect(phoneOfMember(_member('y', 'Nobody'), [circle]), isNull);
    });

    test('the camera follows real movement, not GPS wobble', () {
      final at = const LatLng(40.7, -74.0);
      final walked = MemberStatus(uid: 'b', name: 'B', lat: 40.7009, lng: -74.0, moving: true);
      final drifted = MemberStatus(uid: 'b', name: 'B', lat: 40.7009, lng: -74.0);
      expect(shouldFollow(member: walked, centeredAt: at, lastFollow: null, now: now), isTrue,
          reason: '100 m while moving');
      expect(shouldFollow(member: drifted, centeredAt: at, lastFollow: null, now: now), isFalse,
          reason: '100 m while still is drift');
      expect(
          shouldFollow(
              member: walked,
              centeredAt: at,
              lastFollow: now.subtract(const Duration(seconds: 2)),
              now: now),
          isFalse,
          reason: 'followed two seconds ago');
    });

    test('freshness and motion read naturally', () {
      expect(freshnessLabel(_member('b', 'B', updatedAt: now), now), 'Live · updated just now');
      expect(freshnessLabel(_member('b', 'B', updatedAt: now.subtract(const Duration(minutes: 4))), now),
          'Updated 4 min ago');
      expect(freshnessLabel(_member('b', 'B', updatedAt: DateTime(2026, 10, 23, 19, 5)), now),
          'Last seen 7:05 PM');
      expect(motionLabel(MemberStatus(uid: 'b', name: 'B', moving: true, speedKmh: 42), stale: false),
          'Moving · 26 mph');
      expect(motionLabel(MemberStatus(uid: 'b', name: 'B', since: DateTime(2026, 10, 23, 19, 5)), stale: false),
          'At place since 7:05 PM');
      expect(motionLabel(_member('b', 'B', moving: true), stale: true), 'No recent update');
    });

    test('the safety strip puts alerts first, then late and due check-ins', () {
      final alert = SafetyAlert(
          id: 'a', fromUid: 'bia', fromName: 'Bia Souza', type: 'sos', resolved: false, location: '');
      final late = _journey('carlos', _checkInAt(now.subtract(const Duration(minutes: 10))));
      final due = _journey('dani', _checkInAt(now.subtract(const Duration(minutes: 2))));
      final calm = _journey('eva', _checkInAt(now.add(const Duration(hours: 1))));

      expect(SafetyStrip.of([alert], [late], now)?.label, 'Bia needs help');
      expect(SafetyStrip.of(const [], [late, due], now)?.level, SafetyLevel.late);
      expect(SafetyStrip.of(const [], [due, calm], now)?.label, "dani's check-in is due");
      expect(SafetyStrip.of(const [], [calm], now)?.label, '1 friend on a journey');
      expect(SafetyStrip.of(const [], const [], now), isNull);
    });

    test('an overdue friend is notified once nobody raised an alert for them', () {
      final late = _journey('carlos', _checkInAt(now.subtract(const Duration(minutes: 10))));
      final raised = _journey('dani', _checkInAt(now.subtract(const Duration(minutes: 10))),
          alertRaised: true);
      final alert = SafetyAlert(
          id: 'a', fromUid: 'carlos', fromName: 'Carlos', type: 'overdue', resolved: false, location: '');
      expect(overdueToNotify([late, raised], const [], now), [late]);
      expect(overdueToNotify([late], [alert], now), isEmpty);
    });
  });

  group('live sharing', () {
    test('follows the service and resumes or pauses it', () async {
      final fake = _FakeSharing();
      final container = ProviderContainer(overrides: [locationSharingProvider.overrideWithValue(fake)]);
      addTearDown(container.dispose);

      expect(container.read(liveSharingProvider), isFalse);
      expect(await container.read(liveSharingProvider.notifier).resume(), isTrue);
      expect(container.read(liveSharingProvider), isTrue);

      await container.read(liveSharingProvider.notifier).pause();
      expect(container.read(liveSharingProvider), isFalse);
      expect(container.read(liveSharingProvider.notifier).paused, isTrue);

      await container.read(liveSharingProvider.notifier).startIfAllowed();
      expect(container.read(liveSharingProvider), isFalse, reason: 'a pause I chose is respected');
    });

    test('resuming reports when location is off on the phone', () async {
      final container = ProviderContainer(
          overrides: [locationSharingProvider.overrideWithValue(_FakeSharing(locationOn: false))]);
      addTearDown(container.dispose);
      expect(await container.read(liveSharingProvider.notifier).resume(), isFalse);
    });
  });

  group('places', () {
    test('a place is only visible to its own circle', () {
      final place = Place(circleId: 'c1', name: 'Home', lat: 0, lng: 0, viewerIds: ['old']);
      expect(placeViewers(Circle(name: 'Family', memberIds: ['ana', 'bia']), place, 'ana').toSet(),
          {'ana', 'bia'});
      expect(placeViewers(null, place, 'ana').toSet(), {'old', 'ana'});
    });

    test('saving and switching a place off keeps it in its circle', () async {
      final db = FakeFirebaseFirestore();
      final service = PlaceService(PlaceRepository(db, currentUid: () => 'ana'),
          session: Session()..setProfile(uid: 'ana', name: 'Ana', email: 'ana@example.com'));
      final family = Circle(name: 'Family', memberIds: ['ana', 'bia'])..id = 'c1';
      final home = Place(circleId: 'c1', name: 'Home', lat: 40.7, lng: -74.0);

      await service.save(home, family);
      await service.setEnabled(home, family, false);

      final doc = (await db.collection('places').doc(home.id).get()).data()!;
      expect(doc['enabled'], isFalse);
      expect((doc['viewerIds'] as List).toSet(), {'ana', 'bia'});
      expect(doc['createdBy'], 'ana');

      await service.delete(home.id!);
      expect((await db.collection('places').get()).docs, isEmpty);
    });
  });

  group('trips', () {
    Trip trip(String id, DateTime start, {double km = 5, double topKmh = 50}) => Trip(
          id: id,
          userId: 'bia',
          userName: 'Bia',
          points: const [],
          startMillis: start.millisecondsSinceEpoch,
          endMillis: start.add(const Duration(minutes: 20)).millisecondsSinceEpoch,
          distanceM: km * 1000,
          maxSpeedKmh: topKmh,
        );

    test('weeks start on Monday', () {
      expect(weekStart(0, now: now), DateTime(2026, 10, 19));
      expect(weekStart(1, now: now), DateTime(2026, 10, 12));
      expect(weekStart(-1, now: now), DateTime(2026, 10, 26));
    });

    test('a week sums distance, top speed and trips over the limit', () {
      final week = TripWeek([
        trip('a', DateTime(2026, 10, 23, 9), km: 3, topKmh: 140),
        trip('b', DateTime(2026, 10, 23, 8), km: 2),
        trip('c', DateTime(2026, 10, 21, 18), km: 10),
      ]);
      expect(week.totalKm, 15);
      expect(week.topKmh, 140);
      expect(week.overLimitCount, 1);
      expect(week.byDay.keys, ['Fri · Oct 23', 'Wed · Oct 21']);
      expect(TripWeek(week.all, onlyOverLimit: true).shown.map((t) => t.id), ['a']);
    });

    test('the replay interpolates along the path', () {
      final path = TripPath(const [
        TripPoint(lat: 0, lng: 0, atMillis: 0, speedKmh: 10),
        TripPoint(lat: 0, lng: 1, atMillis: 1, speedKmh: 20),
        TripPoint(lat: 0, lng: 3, atMillis: 2, speedKmh: 30),
      ]);
      expect(path.positionAt(0), const LatLng(0, 0));
      expect(path.positionAt(.5).longitude, closeTo(1.5, 1e-9));
      expect(path.positionAt(1), const LatLng(0, 3));
      expect(path.speedAt(.5), 20);
      expect(path.passedIndex(.75), 1);
      expect(TripPath(const []).positionAt(.5), const LatLng(0, 0));
    });

    testWidgets('trip history filters the trips over the speed limit', (tester) async {
      final trips = [
        trip('a', DateTime.now(), topKmh: 140),
        trip('b', DateTime.now().subtract(const Duration(minutes: 30))),
      ];
      await tester.pumpWidget(ProviderScope(
        overrides: [
          tripsOfWeekProvider.overrideWith((ref, key) => Stream.value(trips)),
          weeklyTripCountsProvider.overrideWith((ref, userId) async => [0, 1, 0, 2]),
        ],
        child: const MaterialApp(home: TripHistoryScreen(userId: 'bia', name: 'Bia Souza')),
      ));
      await tester.pump();
      expect(find.text("Bia's trips"), findsOneWidget);
      expect(find.text('All trips 2'), findsOneWidget);
      expect(find.byType(TripCard), findsNWidgets(2));
      await tester.tap(find.text('Over 80 mph 1'));
      await tester.pump();
      expect(find.byType(TripCard), findsOneWidget);
    });
  });
}
