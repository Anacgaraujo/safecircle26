import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safecircle/core/location/location_service.dart';
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/features/alerts/application/sos_service.dart';
import 'package:safecircle/features/alerts/data/alert_repository.dart';
import 'package:safecircle/features/alerts/domain/alert_position.dart';
import 'package:safecircle/features/alerts/domain/safety_alert.dart';
import 'package:safecircle/features/alerts/presentation/emergency_screen.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/contacts/data/contacts_repository.dart';
import 'package:safecircle/features/journeys/domain/journey.dart';
import 'package:safecircle/features/live_map/domain/tracking.dart';

void main() {
  final now = DateTime(2026, 10, 23, 20, 10);
  final alert = SafetyAlert(
    id: 'a1',
    fromUid: 'bia',
    fromName: 'Bia Souza',
    type: 'sos',
    resolved: false,
    location: 'Union Square',
    lat: 40.7359,
    lng: -73.9911,
  );

  MemberStatus status({bool sharing = true, Duration age = Duration.zero, String place = 'Soho'}) =>
      MemberStatus(
        uid: 'bia',
        name: 'Bia Souza',
        lat: 40.7233,
        lng: -74.003,
        place: place,
        sharing: sharing,
        updatedAt: now.subtract(age),
      );

  group('alert position', () {
    test('follows the live position while it is shared', () {
      final p = AlertPosition(alert, status(), now);
      expect(p.isLive, isTrue);
      expect((p.lat, p.place), (40.7233, 'Soho'));
    });

    test('falls back to where the alert was raised', () {
      for (final live in [null, status(sharing: false), status(age: const Duration(hours: 2))]) {
        final p = AlertPosition(alert, live, now);
        expect(p.isLive, isFalse);
        expect((p.lat, p.place), (40.7359, 'Union Square'));
      }
    });

    test('keeps the alert place when the live one has no name', () {
      expect(AlertPosition(alert, status(place: ''), now).place, 'Union Square');
    });
  });

  test('a journey knows its last confirmed check-in', () {
    CheckIn c(String label, bool confirmed) =>
        CheckIn(label: label, date: 'Today', time: '8:00 PM', confirmed: confirmed);
    final j = Journey(
      id: 'j',
      ownerId: 'bia',
      ownerName: 'Bia',
      circleId: 'c',
      circleName: 'Family',
      status: 'active',
      alertRaised: false,
      checkIns: [c('First', true), c('Second', true), c('Check-out', false)],
    );
    expect(j.lastConfirmed?.label, 'Second');
  });

  group('sos service', () {
    late FakeFirebaseFirestore db;
    const here = ScLocation(lat: 40.7128, lng: -74.006, label: 'Lower Manhattan');

    SosService service() => SosService(
          AlertRepository(db,
              contacts: ContactsRepository(db, currentUid: () => 'ana'), currentUid: () => 'ana'),
          locate: () async => here,
        );

    setUp(() async {
      db = FakeFirebaseFirestore();
      Session.instance.setProfile(uid: 'ana', name: 'Ana Ribeiro', email: 'ana@example.com');
      await db.collection('circles').add({'name': 'Family', 'ownerId': 'ana', 'memberIds': ['ana', 'bia']});
    });

    test('an SOS carries the position and reaches the circle', () async {
      final sos = service();
      expect(await sos.send(await sos.currentPosition()), 1);
      final a = (await db.collection('alerts').get()).docs.single.data();
      expect(a['type'], 'sos');
      expect(a['location'], 'Lower Manhattan');
      expect(a['watcherIds'], ['bia']);
    });

    test('cancelling resolves my SOS; a watcher can resolve and reopen', () async {
      await service().send(here);
      final id = (await db.collection('alerts').get()).docs.single.id;
      await service().cancel();
      expect((await db.collection('alerts').doc(id).get())['resolved'], isTrue);
      await service().setResolved(id, false);
      expect((await db.collection('alerts').doc(id).get())['resolved'], isFalse);
    });
  });

  group('emergency screen', () {
    Widget host({required List<SafetyAlert> open, required List<Person> contacts}) => ProviderScope(
          overrides: [
            myOpenSosProvider.overrideWith((ref) => Stream.value(open)),
            contactsProvider.overrideWith((ref) => Stream.value(contacts)),
          ],
          child: const MaterialApp(home: Scaffold(body: EmergencyScreen())),
        );

    testWidgets('without contacts it asks to add one first', (tester) async {
      await tester.pumpWidget(host(open: const [], contacts: const []));
      await tester.pump();
      expect(find.text('Emergency SOS'), findsOneWidget);
      expect(find.text('Add emergency contact'), findsOneWidget);
    });

    testWidgets('fits a short screen (folded phone) by scrolling', (tester) async {
      // About a folded phone's height once the app bar and tabs are taken.
      tester.view.physicalSize = const Size(1080, 1500);
      tester.view.devicePixelRatio = 2.625;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(host(open: const [], contacts: const []));
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.text('Add emergency contact'), findsOneWidget);
      await tester.dragUntilVisible(find.textContaining('YOUR EMERGENCY CONTACTS'),
          find.byType(SingleChildScrollView), const Offset(0, -100));
      expect(find.textContaining('YOUR EMERGENCY CONTACTS'), findsOneWidget);
    });

    testWidgets('an SOS still open shows the alert as sent', (tester) async {
      final open = SafetyAlert(
        id: 'a1',
        fromUid: 'ana',
        fromName: 'Ana',
        type: 'sos',
        resolved: false,
        location: 'Lower Manhattan',
        timeLabel: '8:10 PM',
      );
      await tester.pumpWidget(host(open: [open], contacts: [Person(name: 'Carlos Lima')]));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('Alert sent'), findsOneWidget);
      expect(find.text('8:10 PM · just now'), findsOneWidget);
      expect(find.text("Cancel alert — I'm safe"), findsOneWidget);
    });
  });
}
