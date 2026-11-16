import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safecircle/core/data/lookup_hash.dart';
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/features/circles/application/circle_service.dart';
import 'package:safecircle/features/circles/data/circle_repository.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/circles/domain/circle_invite.dart';
import 'package:safecircle/features/circles/presentation/circles_screen.dart';
import 'package:safecircle/features/contacts/data/contacts_repository.dart';
import 'package:safecircle/features/contacts/presentation/contacts_screen.dart';

void main() {
  late FakeFirebaseFirestore db;
  var me = 'ana';

  CircleRepository circles() => CircleRepository(db, currentUid: () => me);
  CircleService service() => CircleService(circles());

  Future<void> registerUser(String uid, String name, String email) =>
      db.collection('users').doc(uid).set({'name': name, 'emailHash': emailHash(email)});

  Future<List<Map<String, dynamic>>> invites() async =>
      (await db.collection('invites').get()).docs.map((d) => d.data()).toList();

  setUp(() {
    db = FakeFirebaseFirestore();
    me = 'ana';
    Session.instance.setProfile(uid: 'ana', name: 'Ana Ribeiro', email: 'ana@example.com');
  });

  group('invite texts', () {
    test('asks the server to text members with a phone number', () async {
      final calls = <String>[];
      final svc = CircleService(circles(), sendTexts: (req) async {
        calls.add(req['circleId'] as String);
        return {'sent': 2};
      });
      final circle = Circle(name: 'Family', members: [Person(name: 'Bia', digits: '4155552671')])
        ..id = 'c1';
      expect(await svc.sendInviteTexts(circle), 2);
      expect(calls, ['c1']);
    });

    test('skips circles without phone numbers and never throws', () async {
      var called = false;
      final svc = CircleService(circles(), sendTexts: (_) async {
        called = true;
        throw Exception('function not deployed');
      });
      final noPhones = Circle(name: 'Family', members: [Person(name: 'Bia', email: 'b@x.com')])
        ..id = 'c1';
      expect(await svc.sendInviteTexts(noPhones), 0);
      expect(called, isFalse);

      final withPhone = Circle(name: 'Family', members: [Person(name: 'Bia', digits: '4155552671')])
        ..id = 'c1';
      expect(await svc.sendInviteTexts(withPhone), 0);
      expect(called, isTrue);
    });

    test('resend texts one person again and reports what happened', () async {
      await registerUser('bia', 'Bia Souza', 'bia@example.com');
      final requests = <Map<String, dynamic>>[];
      var reply = <String, dynamic>{'sent': 1};
      final svc = CircleService(circles(), sendTexts: (req) async {
        requests.add(req);
        return reply;
      });
      final bia = Person(name: 'Bia Souza', email: 'bia@example.com', countryCode: 'US', digits: '4155552671');
      final circle = Circle(name: 'Family', members: [bia]);
      await svc.saveAndInvite(circle, isNew: true);

      final sent = await svc.resendInvitation(circle, bia);
      expect(requests.single, {
        'circleId': circle.id,
        'resend': {'countryCode': 'US', 'digits': '4155552671'},
      });
      expect(sent.message('Bia'), 'Invitation texted to Bia again.');

      reply = {'sent': 0, 'retryAfter': 240};
      expect((await svc.resendInvitation(circle, bia)).message('Bia'),
          'You just texted Bia. Try again in 4 minutes.');

      reply = {'joined': true};
      expect((await svc.resendInvitation(circle, bia)).message('Bia'), 'Bia already joined this circle.');
    });

    test('resend without a phone only repeats the in-app invitation', () async {
      await registerUser('bia', 'Bia Souza', 'bia@example.com');
      var texted = false;
      final svc = CircleService(circles(), sendTexts: (_) async {
        texted = true;
        return {'sent': 1};
      });
      final bia = Person(name: 'Bia Souza', email: 'bia@example.com');
      final carlos = Person(name: 'Carlos', email: 'carlos@example.com');
      final circle = Circle(name: 'Family', members: [bia, carlos]);
      await svc.saveAndInvite(circle, isNew: true);

      expect((await svc.resendInvitation(circle, bia)).message('Bia'), 'In-app invitation sent to Bia again.');
      expect((await svc.resendInvitation(circle, carlos)).message('Carlos'),
          'No SafeCircle account yet for Carlos. Add a phone number to text them.');
      expect(texted, isFalse);
    });
  });

  group('invite model', () {
    test('reads the invite and summarizes it', () {
      final invite = CircleInvite.fromMap(
          {'circleId': 'c1', 'circleName': '🏠 Family', 'fromName': 'Ana Ribeiro'},
          id: 'i1');
      expect(invite.id, 'i1');
      expect(invite.circleId, 'c1');
      expect(invite.summary, 'Ana invited you to 🏠 Family');
    });

    test('falls back when the sender or circle name is missing', () {
      final invite = CircleInvite.fromMap({'circleId': 'c1'}, id: 'i1');
      expect(invite.summary, 'Someone invited you to a circle');
    });
  });

  group('circle service', () {
    test('a new circle is created and its members invited', () async {
      await registerUser('bia', 'Bia Souza', 'bia@example.com');
      final circle = Circle(name: 'Family', members: [
        Person(name: 'Bia Souza', email: 'bia@example.com'),
        Person(name: 'Carlos', email: 'carlos@example.com'),
        Person(name: 'Grandma'),
      ]);

      final missing = await service().saveAndInvite(circle, isNew: true);

      expect(missing, ['carlos@example.com']);
      final saved = (await db.collection('circles').doc(circle.id).get()).data()!;
      expect(saved['ownerId'], 'ana');
      expect(saved['memberIds'], ['ana']);
      expect(saved['invitedUids'], ['bia']);
      final sent = await invites();
      expect(sent.single['toUid'], 'bia');
      expect(sent.single['fromName'], 'Ana Ribeiro');
    });

    test('saving an existing circle again does not duplicate invites', () async {
      await registerUser('bia', 'Bia Souza', 'bia@example.com');
      final circle = Circle(name: 'Family', members: [
        Person(name: 'Bia Souza', email: 'bia@example.com'),
      ]);
      await service().saveAndInvite(circle, isNew: true);
      circle.name = 'Family 🏠';
      await service().saveAndInvite(circle, isNew: false);

      expect(await invites(), hasLength(1));
      expect((await db.collection('circles').doc(circle.id).get())['name'], 'Family 🏠');
    });

    test('removing a member drops them from the circle and its watchers', () async {
      await registerUser('bia', 'Bia Souza', 'bia@example.com');
      final bia = Person(name: 'Bia Souza', email: 'bia@example.com');
      final circle = Circle(name: 'Family', members: [bia]);
      await service().saveAndInvite(circle, isNew: true);
      await db.collection('circles').doc(circle.id).update({
        'memberIds': ['ana', 'bia'],
      });

      await service().removeMember(circle, bia);

      expect(circle.members, isEmpty);
      final saved = (await db.collection('circles').doc(circle.id).get()).data()!;
      expect(saved['members'], isEmpty);
      expect(saved['memberIds'], ['ana']);
      expect(saved['invitedUids'], isEmpty);
    });
  });

  group('screens', () {
    Widget host(Widget child, List overrides) => ProviderScope(
          overrides: [...overrides],
          child: MaterialApp(home: Scaffold(body: child)),
        );

    testWidgets('circles tab shows the empty state', (tester) async {
      await tester.pumpWidget(host(const CirclesScreen(), [
        myCirclesProvider.overrideWith((ref) => Stream.value(const <Circle>[])),
        pendingInvitesProvider.overrideWith((ref) => Stream.value(const <CircleInvite>[])),
      ]));
      await tester.pump();
      expect(find.text("You don't have any circle created"), findsOneWidget);
    });

    testWidgets('circles tab lists invites and circles', (tester) async {
      await tester.pumpWidget(host(const CirclesScreen(), [
        myCirclesProvider.overrideWith((ref) => Stream.value([
              Circle(name: '🏠 Family', ownerId: 'ana', memberIds: ['ana'], members: [
                Person(name: 'Bia Souza', email: 'bia@example.com'),
              ]),
            ])),
        pendingInvitesProvider.overrideWith((ref) => Stream.value(const [
              CircleInvite(id: 'i1', circleId: 'c2', circleName: 'Work', fromName: 'Carlos Lima'),
            ])),
      ]));
      await tester.pump();
      expect(find.text('Carlos invited you to Work'), findsOneWidget);
      expect(find.text('Family'), findsOneWidget);
      expect(find.text('1 member'), findsOneWidget);
    });

    testWidgets('emergency contacts ask for at least two contacts', (tester) async {
      await tester.pumpWidget(ProviderScope(
        overrides: [
          contactsProvider.overrideWith((ref) => Stream.value([
                Person(name: 'Carlos Lima', countryCode: 'US', digits: '7185550142'),
              ])),
        ],
        child: const MaterialApp(home: EmergencyContactsScreen()),
      ));
      await tester.pump();
      expect(find.text('Carlos Lima'), findsOneWidget);
      expect(find.text('ALWAYS ALERTED · 1 CONTACT'), findsOneWidget);
      expect(find.text('Add at least 2 emergency contacts to start a journey.'), findsOneWidget);
    });
  });
}
