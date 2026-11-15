import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safecircle/app/app.dart';
import 'package:safecircle/core/data/lookup_hash.dart';
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/features/auth/data/auth_repository.dart';
import 'package:safecircle/features/auth/data/session_loader.dart';
import 'package:safecircle/features/auth/domain/auth_error.dart';
import 'package:safecircle/features/auth/presentation/onboarding_screen.dart';
import 'package:safecircle/features/circles/data/circle_repository.dart';
import 'package:safecircle/features/profile/data/user_repository.dart';

class _MockUser extends Mock implements User {}

class _FailingLoader extends SessionLoader {
  _FailingLoader({required super.users, required super.session});

  int calls = 0;

  @override
  Future<bool> load(SessionUser user) async {
    calls++;
    throw 'offline';
  }
}

void main() {
  late FakeFirebaseFirestore db;
  late Session session;
  late Map<String, bool> applied;

  UserRepository users() => UserRepository(db,
      circles: CircleRepository(db, currentUid: () => session.uid),
      currentUid: () => session.uid);

  SessionLoader loader() => SessionLoader(
        users: users(),
        session: session,
        applyNotificationSettings: (s) => applied = s,
        pause: Duration.zero,
      );

  const ana = (uid: 'ana', email: 'Ana@Example.com');

  setUp(() {
    db = FakeFirebaseFirestore();
    session = Session();
    applied = {};
  });

  group('session loader', () {
    test('an account with PINs opens the app with its profile and settings', () async {
      await db.collection('users').doc('ana').set({
        'name': 'Ana Ribeiro',
        'emailHash': emailHash('ana@example.com'),
        'lookupV': kLookupVersion,
        'settings': {'circleAlerts': false, 'mapHome': false},
      });
      await db.doc('users/ana/private/profile').set({'phone': '+1 (718) 555-0142'});
      await db.doc('users/ana/private/secrets').set({
        'safetyPinHash': hashPin('ana', '1234'),
        'panicPinHash': hashPin('ana', '9876'),
      });

      expect(await loader().load(ana), isTrue);

      expect(session.uid, 'ana');
      expect(session.userName, 'Ana Ribeiro');
      expect(session.userEmail, 'ana@example.com');
      expect(session.userPhone, '+1 (718) 555-0142');
      expect(session.matchesSafety('1234'), isTrue);
      expect(session.matchesPanic('9876'), isTrue);
      expect(session.mapHome, isFalse);
      expect(applied['circleAlerts'], isFalse);
      expect(applied['checkinReminder'], isTrue);
    });

    test('an account without PINs resumes onboarding', () async {
      await db.collection('users').doc('ana').set({'name': 'Ana Ribeiro'});
      expect(await loader().load(ana), isFalse);
      expect(session.safetyPin, isEmpty);
    });

    test('a missing profile falls back to the email prefix and is healed', () async {
      expect(await loader().load(ana), isFalse);
      expect(session.userName, 'ana');

      await pumpEventQueue();
      final doc = (await db.doc('users/ana').get()).data()!;
      expect(doc['emailHash'], emailHash('ana@example.com'));
      expect(doc['lookupV'], kLookupVersion);
      expect((await db.doc('users/ana/private/profile').get())['email'], 'ana@example.com');
    });

    test('a legacy profile with a raw email and phone is moved out of the public doc', () async {
      await db.collection('users').doc('ana').set({
        'name': 'Ana Ribeiro',
        'email': 'ana@example.com',
        'phone': '+1 (718) 555-0142',
      });

      await loader().load(ana);
      expect(session.userPhone, '+1 (718) 555-0142');

      await pumpEventQueue();
      final doc = (await db.doc('users/ana').get()).data()!;
      expect(doc.containsKey('email'), isFalse);
      expect(doc.containsKey('phone'), isFalse);
      expect(doc['name'], 'Ana Ribeiro');
      expect(doc['phoneHash'], phoneHash('+1 (718) 555-0142'));
    });
  });

  group('auth errors', () {
    test('known codes get short messages', () {
      expect(describeAuthError(FirebaseAuthException(code: 'invalid-credential')),
          'Wrong email or password.');
      expect(describeAuthError(FirebaseAuthException(code: 'email-already-in-use')),
          'This email is already registered.');
      expect(describeAuthError(FirebaseAuthException(code: 'network-request-failed')),
          'Network error. Check your connection.');
    });

    test('unknown errors fall back to a generic message', () {
      expect(describeAuthError(FirebaseAuthException(code: 'x', message: 'Boom')), 'Boom');
      expect(describeAuthError(StateError('x')), 'Something went wrong. Try again.');
    });
  });

  group('auth gate', () {
    testWidgets('signed out shows onboarding', (tester) async {
      await tester.pumpWidget(ProviderScope(
        overrides: [authStateProvider.overrideWith((ref) => Stream.value(null))],
        child: const MaterialApp(home: AuthGate()),
      ));
      await tester.pump();
      expect(find.byType(OnboardingFlow), findsOneWidget);
    });

    testWidgets('a session that fails to load offers a retry', (tester) async {
      final user = _MockUser();
      when(() => user.uid).thenReturn('ana');
      when(() => user.email).thenReturn('ana@example.com');
      final failing = _FailingLoader(users: users(), session: session);

      await tester.pumpWidget(ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream.value(user)),
          sessionLoaderProvider.overrideWithValue(failing),
        ],
        child: const MaterialApp(home: AuthGate()),
      ));
      await tester.pump();
      await tester.pump();
      expect(find.text("We couldn't load your account"), findsOneWidget);

      await tester.tap(find.text('Try again'));
      await tester.pump();
      await tester.pump();
      expect(failing.calls, 2);
      expect(find.text("We couldn't load your account"), findsOneWidget);
    });
  });
}
