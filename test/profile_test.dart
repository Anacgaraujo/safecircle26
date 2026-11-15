import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safecircle/core/data/lookup_hash.dart';
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/features/auth/data/auth_repository.dart';
import 'package:safecircle/features/circles/data/circle_repository.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/contacts/data/contacts_repository.dart';
import 'package:safecircle/features/journeys/data/journey_repository.dart';
import 'package:safecircle/features/journeys/domain/journey.dart';
import 'package:safecircle/features/profile/application/profile_service.dart';
import 'package:safecircle/features/profile/data/user_repository.dart';
import 'package:safecircle/features/profile/domain/profile_rules.dart';
import 'package:safecircle/features/profile/presentation/profile_screen.dart';

class _MockAuth extends Mock implements AuthRepository {}

void main() {
  Session signedIn() => Session()
    ..setProfile(uid: 'ana', name: 'Ana Ribeiro', email: 'ana@example.com', phone: '+1 (718) 555-0142')
    ..setPins(safety: hashPin('ana', '1234'), panic: hashPin('ana', '9876'));

  group('rules', () {
    test('circles summary counts circles and members', () {
      expect(circlesSummary([]), '0 circles · 0 members');
      expect(
          circlesSummary([
            Circle(name: 'Family', members: [Person(name: 'Bia')]),
            Circle(name: 'Work', members: [Person(name: 'Carlos'), Person(name: 'Dani')]),
          ]),
          '2 circles · 3 members');
    });

    test('a new PIN needs the current one and must differ from the other PIN', () {
      final s = signedIn();
      expect(pinChangeError(s, PinKind.safety, '0000', '4321'), 'Current PIN is incorrect.');
      expect(pinChangeError(s, PinKind.safety, '1234', '43'), 'The new PIN must have 4 digits.');
      expect(pinChangeError(s, PinKind.safety, '1234', '9876'), 'It must differ from your panic PIN.');
      expect(pinChangeError(s, PinKind.panic, '9876', '1234'), 'It must differ from your safety PIN.');
      expect(pinChangeError(s, PinKind.panic, '1234', '5555'), 'Current panic PIN is incorrect.');
      expect(pinChangeError(s, PinKind.safety, '1234', '4321'), isNull);
    });

    test('email and password changes are checked before reaching the server', () {
      expect(emailChangeError('ana', 'secret'), 'Enter a valid email.');
      expect(emailChangeError('ana@new.com', ''), 'Enter your current password.');
      expect(emailChangeError(' ana@new.com ', 'secret'), isNull);
      expect(passwordChangeError('12345', '12345'), 'New password must have at least 6 characters.');
      expect(passwordChangeError('123456', '123457'), "Passwords don't match.");
      expect(passwordChangeError('123456', '123456'), isNull);
    });
  });

  group('profile service', () {
    late FakeFirebaseFirestore db;
    late Session session;
    late _MockAuth auth;
    late Map<String, bool> applied;

    ProfileService service() {
      final circles = CircleRepository(db, session: session);
      return ProfileService(
        users: UserRepository(db, circles: circles, session: session),
        auth: auth,
        session: session,
        applyNotificationSetting: (k, v) => applied[k] = v,
      );
    }

    setUp(() {
      db = FakeFirebaseFirestore();
      session = signedIn();
      auth = _MockAuth();
      applied = {};
    });

    test('editing the profile updates the account and the session', () async {
      await service().updateProfile(name: '  Ana R.  ', phone: '+1 (212) 555-0000');
      expect(session.userName, 'Ana R.');
      expect(session.userPhone, '+1 (212) 555-0000');
      expect((await db.doc('users/ana').get())['name'], 'Ana R.');

      await service().updateProfile(name: '', phone: '');
      expect(session.userName, 'Ana R.', reason: 'an empty name keeps the current one');
    });

    test('a new photo is remembered', () async {
      await service().updatePhoto('/photos/me.jpg');
      expect(session.userPhoto, '/photos/me.jpg');
      expect((await db.doc('users/ana').get())['photoPath'], '/photos/me.jpg');
    });

    test('changing a PIN stores only its hash', () async {
      await service().changePin(PinKind.safety, current: '1234', next: '4321');
      expect(session.matchesSafety('4321'), isTrue);
      final secrets = (await db.doc('users/ana/private/secrets').get()).data()!;
      expect(secrets['safetyPinHash'], hashPin('ana', '4321'));
      expect(secrets.values, isNot(contains('4321')));
    });

    test('a refused PIN change never reaches Firestore', () async {
      await expectLater(
        service().changePin(PinKind.panic, current: '9876', next: '1234'),
        throwsA(isA<ProfileException>()
            .having((e) => e.message, 'message', 'It must differ from your safety PIN.')),
      );
      expect((await db.doc('users/ana/private/secrets').get()).exists, isFalse);
    });

    test('an email change goes to auth with the current address', () async {
      when(() => auth.changeEmail(
              currentEmail: any(named: 'currentEmail'),
              password: any(named: 'password'),
              newEmail: any(named: 'newEmail')))
          .thenAnswer((_) async {});
      await service().changeEmail(newEmail: ' Ana@New.com ', password: 'secret');
      verify(() => auth.changeEmail(
          currentEmail: 'ana@example.com', password: 'secret', newEmail: 'ana@new.com')).called(1);
    });

    test('notification toggles apply here and follow me across devices', () async {
      await service().setNotificationSetting('circleAlerts', false);
      expect(applied, {'circleAlerts': false});
      expect((await db.doc('users/ana').get())['settings'], {'circleAlerts': false});
    });

    test('deleting the account signs out even when auth asks for a recent login', () async {
      await db.doc('users/ana').set({'name': 'Ana Ribeiro'});
      when(() => auth.deleteAccount()).thenThrow(Exception('requires-recent-login'));
      when(() => auth.logout()).thenAnswer((_) async {});
      await service().deleteAccount();
      verify(() => auth.logout()).called(1);
    });
  });

  testWidgets('the profile tab shows the account and its counts', (tester) async {
    final session = signedIn();
    await tester.pumpWidget(ProviderScope(
      overrides: [
        sessionProvider.overrideWithValue(session),
        contactsProvider.overrideWith((ref) => Stream.value([Person(name: 'Carlos')])),
        myCirclesProvider.overrideWith((ref) => Stream.value([
              Circle(name: 'Family', members: [Person(name: 'Bia'), Person(name: 'Carlos')]),
            ])),
        journeyHistoryProvider.overrideWith((ref) => Stream.value(const <Journey>[])),
      ],
      child: const MaterialApp(home: Scaffold(body: ProfileScreen())),
    ));
    await tester.pump();
    expect(find.text('1 person will be alerted'), findsOneWidget);
    expect(find.text('1 circle · 2 members'), findsOneWidget);
    expect(find.text('0 completed journeys'), findsOneWidget);
    expect(find.text('Ana Ribeiro'), findsWidgets);

    session.setProfile(uid: 'ana', name: 'Ana R.', email: 'ana@example.com');
    await tester.pump();
    expect(find.text('Ana R.'), findsWidgets, reason: 'the tab follows profile changes');
  });
}
