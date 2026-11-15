import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safecircle/core/data/lookup_hash.dart';
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/features/alerts/data/alert_repository.dart';
import 'package:safecircle/features/circles/data/circle_repository.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/contacts/data/contacts_repository.dart';
import 'package:safecircle/features/journeys/data/journey_repository.dart';
import 'package:safecircle/features/journeys/domain/journey.dart';

void main() {
  late FakeFirebaseFirestore db;
  var me = 'ana';

  CircleRepository circles() => CircleRepository(db, currentUid: () => me);
  ContactsRepository contacts() => ContactsRepository(db, currentUid: () => me);
  AlertRepository alerts() => AlertRepository(db, contacts: contacts(), currentUid: () => me);
  JourneyRepository journeys() => JourneyRepository(db, alerts: alerts(), currentUid: () => me);

  Future<void> registerUser(String uid, String name, {String email = '', String phone = ''}) =>
      db.collection('users').doc(uid).set({
        'name': name,
        if (email.isNotEmpty) 'emailHash': emailHash(email),
        if (phone.isNotEmpty) 'phoneHash': phoneHash(phone),
      });

  setUp(() {
    db = FakeFirebaseFirestore();
    me = 'ana';
    Session.instance.setProfile(uid: 'ana', name: 'Ana Ribeiro', email: 'ana@example.com');
  });

  group('circles', () {
    test('inviting by email, accepting, then leaving', () async {
      await registerUser('bia', 'Bia Souza', email: 'bia@example.com');
      final circle = Circle(name: 'Family', members: [
        Person(name: 'Bia Souza', email: 'bia@example.com'),
      ]);
      await circles().createCircle(circle);
      expect(await circles().sendInvite(circle: circle, toEmail: 'bia@example.com'), isTrue);
      expect(await circles().sendInvite(circle: circle, toEmail: 'nobody@example.com'), isFalse);

      me = 'bia';
      Session.instance.setProfile(uid: 'bia', name: 'Bia Souza', email: 'bia@example.com');
      final invites = await circles().pendingInvitesStream().first;
      expect(invites, hasLength(1));
      await circles().acceptInvite(invites.single);
      expect((await circles().myCirclesStream().first).single.memberIds, containsAll(['ana', 'bia']));

      await circles().leaveCircle(circle.id!);
      final after = (await db.collection('circles').doc(circle.id).get()).data()!;
      expect(after['memberIds'], ['ana']);
      expect(after['members'], isEmpty, reason: 'her entry (email only) is removed too');
    });

    test('the owner cannot "leave" their own circle', () async {
      final circle = Circle(name: 'Family');
      await circles().createCircle(circle);
      await circles().leaveCircle(circle.id!);
      expect((await db.collection('circles').doc(circle.id).get()).exists, isTrue);
    });
  });

  group('alerts', () {
    test('a panic alert reaches the circle and contacts who use the app', () async {
      await registerUser('bia', 'Bia Souza');
      await registerUser('carlos', 'Carlos Lima', phone: '+1 (718) 555-0142');
      await db.collection('circles').add({
        'name': 'Family',
        'ownerId': 'ana',
        'memberIds': ['ana', 'bia'],
      });
      await contacts().addContact(Person(name: 'Carlos Lima', countryCode: 'US', digits: '7185550142'));
      await contacts().addContact(Person(name: 'Neighbor', countryCode: 'US', digits: '2125550000'));

      final reached = await alerts().fireAlert(type: 'panic');

      expect(reached, 2);
      final alert = (await db.collection('alerts').get()).docs.single.data();
      expect(alert['type'], 'panic');
      expect((alert['watcherIds'] as List).toSet(), {'bia', 'carlos'},
          reason: 'never the sender; contacts without an account are not app watchers');
    });

    test('a contact in another country with the same digits is not matched', () async {
      await registerUser('stranger', 'Stranger', phone: '+55 71 98354-4219');
      await contacts().addContact(Person(name: 'Friend', countryCode: 'US', digits: '7198354421'));
      expect(await alerts().fireAlert(type: 'sos'), 0);
    });

    test('the sender can clear SOS but never their own panic alert', () async {
      await alerts().fireAlert(type: 'sos');
      await alerts().fireAlert(type: 'panic');
      await alerts().resolveMyAlerts();
      final byType = {
        for (final d in (await db.collection('alerts').get()).docs) d['type']: d['resolved'],
      };
      expect(byType, {'sos': true, 'panic': false});
    });
  });

  group('journeys', () {
    Future<String> start() async {
      final circle = Circle(name: 'Family', memberIds: ['ana', 'bia'])..id = 'c1';
      return journeys().startJourney(circle: circle, checkIns: [
        CheckIn(label: 'First check-in', date: 'Today', time: '8:10 PM', atMillis: 1),
      ]);
    }

    test('the circle (minus the owner) watches the journey', () async {
      final id = await start();
      final j = (await db.collection('journeys').doc(id).get()).data()!;
      expect(j['watcherIds'], ['bia']);
      expect(j['status'], 'active');
    });

    test('confirming with the panic PIN raises a silent alert', () async {
      await db.collection('circles').add({'name': 'Family', 'ownerId': 'ana', 'memberIds': ['ana', 'bia']});
      final id = await start();
      final checkIns = [
        CheckIn(label: 'First check-in', date: 'Today', time: '8:10 PM', atMillis: 1)..confirmed = true,
      ];
      await journeys().confirmCheckIn(journeyId: id, checkIns: checkIns, panic: true);

      final j = (await db.collection('journeys').doc(id).get()).data()!;
      expect(j['alertRaised'], isTrue);
      final alerts = (await db.collection('alerts').get()).docs;
      expect(alerts.single['type'], 'panic');
      expect(alerts.single['watcherIds'], ['bia']);
    });

    test('a missed check-in alerts only once, even if noticed twice', () async {
      await db.collection('circles').add({'name': 'Family', 'ownerId': 'ana', 'memberIds': ['ana', 'bia']});
      final id = await start();
      final journey = Journey.fromMap((await db.collection('journeys').doc(id).get()).data()!, id);
      final missed = journey.checkIns.first;
      await journeys().raiseOverdueOnJourney(journey, missed);
      await journeys().raiseOverdueOnJourney(journey, missed);
      expect((await db.collection('alerts').get()).docs, hasLength(1));
    });
  });
}
