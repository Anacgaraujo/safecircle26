import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safecircle/core/firebase/firebase_bootstrap.dart';
import 'package:safecircle/core/data/repositories.dart';
import 'package:safecircle/core/data/lookup_hash.dart';
import 'package:safecircle/core/location/location_service.dart';
import 'package:safecircle/features/trips/domain/trip_rules.dart' show weekStart;
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/journeys/domain/journey.dart';
import 'package:safecircle/features/live_map/domain/tracking.dart';
import 'package:safecircle/core/session/session.dart';

const _emailA = 'owner@safecircle.test';
const _emailB = 'watcher@safecircle.test';
const _emailC = 'leaver@safecircle.test';
const _password = 'e2e-throwaway';

final _repo = Repositories.instance;
final _app = Session.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  assert(kUseEmulators, 'Build the E2E suite with --dart-define=USE_EMULATORS=true');
  if (!kUseEmulators) {
    runApp(const Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: Text('Refusing to run: build with --dart-define=USE_EMULATORS=true')),
    ));
    return;
  }
  await initFirebase();
  runApp(const _E2EApp());
}

class Check {
  Check(this.name);
  final String name;
  String status = 'running';
  String detail = '';
}

class Fail implements Exception {
  Fail(this.message);
  final String message;
  @override
  String toString() => message;
}

void expect(Object? actual, Object? expected, String what) {
  final ok = actual is List && expected is List
      ? actual.length == expected.length &&
          Iterable.generate(actual.length).every((i) => actual[i] == expected[i])
      : actual == expected;
  if (!ok) throw Fail('$what: expected $expected, got $actual');
}

void expectTrue(bool v, String what) {
  if (!v) throw Fail('$what: expected true');
}

void expectFalse(bool v, String what) {
  if (v) throw Fail('$what: expected false');
}

Future<void> expectDenied(Future<void> Function() op, String what) async {
  try {
    await op();
  } on FirebaseException catch (e) {
    if (e.code == 'permission-denied') return;
    throw Fail('$what: unexpected error ${e.code}');
  }
  throw Fail('$what: was allowed but rules must deny it');
}

Future<T> waitFor<T>(Stream<T> stream, bool Function(T) test, String what) {
  return stream.firstWhere(test).timeout(const Duration(seconds: 15),
      onTimeout: () => throw Fail('timeout waiting for $what'));
}

Future<String> signInAs(String email, {required String name, String phone = ''}) async {
  final auth = FirebaseAuth.instance;
  await auth.signOut();
  UserCredential cred;
  try {
    cred = await auth.signInWithEmailAndPassword(email: email, password: _password);
  } on FirebaseAuthException {
    cred = await auth.createUserWithEmailAndPassword(email: email, password: _password);
  }
  final uid = cred.user!.uid;
  _app.setProfile(uid: uid, name: name, email: email, phone: phone);
  await _repo.users.createUserDoc(uid: uid, name: name, email: email, phone: phone);
  final storedPhone = ((await _repo.users.getPrivateProfile())?['phone'] ?? '') as String;
  _app.setProfile(uid: uid, name: name, email: email, phone: storedPhone);
  final (safety, panic) = await _repo.users.getPins();
  _app.setPins(safety: safety, panic: panic);
  return uid;
}

CheckIn checkInAt(DateTime at, String label) => CheckIn(
      label: label,
      date: '${at.day}/${at.month}',
      time: '${at.hour}:${at.minute.toString().padLeft(2, '0')}',
      atMillis: at.millisecondsSinceEpoch,
    );

class _E2EApp extends StatefulWidget {
  const _E2EApp();
  @override
  State<_E2EApp> createState() => _E2EAppState();
}

class _E2EAppState extends State<_E2EApp> {
  final List<Check> checks = [];
  bool done = false;

  late String uidA;
  late String uidB;
  late Circle circle;
  late String journeyId;
  late List<CheckIn> checkIns;

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> step(String name, Future<void> Function() body) async {
    final c = Check(name);
    setState(() => checks.add(c));
    try {
      await body();
      c.status = 'pass';
    } catch (e) {
      c.status = 'fail';
      c.detail = '$e';
    }
    debugPrint('[E2E] ${c.status.toUpperCase()} $name ${c.detail}');
    if (mounted) setState(() {});
    if (c.status == 'fail') throw Fail('stopped at "$name"');
  }

  Future<void> _run() async {
    try {
      await step('1. Accounts A/B with hashed PINs, no plaintext email/phone in public profile', () async {
        uidA = await signInAs(_emailA, name: 'Ana Owner', phone: '(+55) 71 90000-0001');
        await _repo.users.savePins(safety: '1111', panic: '9999');
        expectTrue(_app.matchesSafety('1111'), 'safety PIN matches');
        expectTrue(_app.matchesPanic('9999'), 'panic PIN matches');
        expectFalse(_app.matchesSafety('9999'), 'panic PIN is not the safety PIN');
        final pub = (await _repo.users.getUserDoc(uidA))!;
        expect(pub['emailHash'], emailHash(_emailA), 'emailHash');
        expectFalse(pub.containsKey('email'), 'raw email absent from public doc');
        expectFalse(pub.containsKey('phone'), 'raw phone absent from public doc');
        expect((await _repo.users.getPrivateProfile())!['email'], _emailA, 'private profile email');

        uidB = await signInAs(_emailB, name: 'Bia Watcher', phone: '(+55) 71 90000-0002');
        await _repo.users.savePins(safety: '2222', panic: '8888');
        expectTrue(uidA != uidB, 'distinct uids');
      });

      await step('2. A creates a circle and invites B by email (unknown email rejected, no duplicate invite)', () async {
        await signInAs(_emailA, name: 'Ana Owner');
        circle = Circle(name: '🏠 Test circle', members: [
          Person(name: 'Bia Watcher', digits: '71900000002', email: _emailB),
        ]);
        await _repo.circles.createCircle(circle);
        expect(circle.memberIds, [uidA], 'owner is the only member id');

        expectFalse(await _repo.circles.sendInvite(circle: circle, toEmail: 'nobody@safecircle.test'), 'unknown email');
        expectTrue(await _repo.circles.sendInvite(circle: circle, toEmail: _emailB), 'invite B');
        expectTrue(await _repo.circles.sendInvite(circle: circle, toEmail: _emailB), 'second invite is a no-op');
        final invites = await FirebaseFirestore.instance
            .collection('invites')
            .where('fromUid', isEqualTo: uidA)
            .where('circleId', isEqualTo: circle.id)
            .get();
        expect(invites.docs.length, 1, 'invite documents');
      });

      await step('3. B receives the invite and accepts once — no duplicate member', () async {
        await signInAs(_emailB, name: 'Bia Watcher');
        final pending = await waitFor(_repo.circles.pendingInvitesStream(),
            (l) => l.any((i) => i.circleId == circle.id), 'invite');
        final invite = pending.firstWhere((i) => i.circleId == circle.id);
        expect(invite.circleName, '🏠 Test circle', 'invite circle name');
        await _repo.circles.acceptInvite(invite);
        final mine = await waitFor(
            _repo.circles.myCirclesStream(), (l) => l.any((c) => c.id == circle.id), 'circle visible to B');
        final c = mine.firstWhere((c) => c.id == circle.id);
        expectTrue(c.memberIds.contains(uidA) && c.memberIds.contains(uidB), 'both member ids');
        expect(c.memberIds.where((m) => m == uidB).length, 1, 'B appears once');
        expect(c.members.length, 1, 'member entries');
        expect((await _repo.circles.pendingInvitesStream().first).where((i) => i.circleId == circle.id).length, 0,
            'pending invites after accept');
      });

      await step('4. Rules: B cannot rename the circle nor read A\'s private PINs', () async {
        await signInAs(_emailB, name: 'Bia Watcher');
        final ref = FirebaseFirestore.instance.collection('circles').doc(circle.id);
        await expectDenied(() => ref.update({'name': 'hacked'}), 'rename by non-owner');
        await expectDenied(
            () => FirebaseFirestore.instance
                .collection('users')
                .doc(uidA)
                .collection('private')
                .doc('secrets')
                .get(),
            'read another user\'s secrets');
      });

      await step('5. A starts a journey (2 check-ins); B sees it live as watcher', () async {
        await signInAs(_emailA, name: 'Ana Owner');
        circle = (await _repo.circles.myCirclesStream().first).firstWhere((c) => c.id == circle.id);
        final now = DateTime.now();
        checkIns = [
          checkInAt(now.add(const Duration(seconds: 2)), 'Arrived'),
          checkInAt(now.add(const Duration(minutes: 30)), 'Leaving'),
        ];
        journeyId = await _repo.journeys.startJourney(
          circle: circle,
          checkIns: checkIns,
          location: const ScLocation(lat: 40.67, lng: -73.91, label: 'Brooklyn'),
          note: 'e2e',
        );
        expect((await _repo.journeys.activeJourneyOf(uidA))!.id, journeyId, 'active journey resumes');
        final raw = await FirebaseFirestore.instance.collection('journeys').doc(journeyId).get();
        expect(List<String>.from(raw.data()!['watcherIds'] as List), [uidB], 'watcherIds');

        await signInAs(_emailB, name: 'Bia Watcher');
        final friends = await waitFor(_repo.journeys.friendsJourneysStream(),
            (l) => l.any((j) => j.id == journeyId), 'journey visible to watcher');
        final j = friends.firstWhere((j) => j.id == journeyId);
        expect(j.ownerName, 'Ana Owner', 'owner name');
        expect(j.lastPlace, 'Brooklyn', 'start location');
        expect(j.checkIns.length, 2, 'check-ins');
      });

      await step('6. First check-in turns "due now" on time, "overdue" after the 5-min grace', () async {
        await Future.delayed(const Duration(seconds: 3));
        final j = (await _repo.journeys.journeyStream(journeyId).first)!;
        final now = DateTime.now();
        final first = j.checkIns.first;
        expectTrue(first.isDueNow(now), 'due now');
        expectFalse(first.isLate(now), 'not late inside grace');
        expectFalse(j.isOverdue(now), 'journey not overdue inside grace');
        final later = now.add(kCheckInGrace + const Duration(seconds: 1));
        expectTrue(first.isLate(later), 'late after grace');
        expectTrue(j.isOverdue(later), 'journey overdue after grace');
        expect(j.missedCheckIn(later)?.label, 'Arrived', 'missed check-in');
        expectFalse(j.checkIns[1].isDueNow(later), 'future check-in untouched');
      });

      await step('6b. Owner side raises a "missed check-in" alert once; confirming clears it', () async {
        await signInAs(_emailA, name: 'Ana Owner');
        final j = (await _repo.journeys.journeyStream(journeyId).first)!;
        final missed = j.checkIns.first;
        await _repo.journeys.raiseOverdueOnJourney(j, missed,
            location: const ScLocation(lat: 40.67, lng: -73.91, label: 'Park Slope'));
        await _repo.journeys.raiseOverdueOnJourney(j, missed);
        await signInAs(_emailB, name: 'Bia Watcher');
        final alerts = await waitFor(_repo.alerts.incomingAlertsStream(), (l) => l.isNotEmpty, 'overdue alert');
        expect(alerts.length, 1, 'exactly one overdue alert');
        expect(alerts.single.type, 'overdue', 'alert type');
        expect(alerts.single.headline, 'Ana missed a check-in', 'headline');
        expect(alerts.single.location, 'Park Slope', 'alert location');
      });

      await step('7. A confirms check-in 1 with location; B sees it confirmed, overdue alert cleared', () async {
        await signInAs(_emailA, name: 'Ana Owner');
        checkIns[0]
          ..confirmed = true
          ..lat = 40.68
          ..lng = -73.90
          ..place = 'Rio Vermelho';
        await _repo.journeys.confirmCheckIn(journeyId: journeyId, checkIns: checkIns, panic: false);
        await signInAs(_emailB, name: 'Bia Watcher');
        final j = await waitFor(_repo.journeys.journeyStream(journeyId),
            (j) => j!.checkIns.first.confirmed, 'confirmation');
        expect(j!.checkIns.first.place, 'Rio Vermelho', 'confirmed place');
        expectFalse(j.alertRaised, 'no panic');
        await waitFor(_repo.alerts.incomingAlertsStream(), (l) => l.isEmpty, 'overdue alert resolved');
      });

      await step('8. Panic PIN on check-in 2: silent for A, alert with location for B', () async {
        await signInAs(_emailA, name: 'Ana Owner');
        checkIns[1].confirmed = true;
        await _repo.journeys.confirmCheckIn(
          journeyId: journeyId,
          checkIns: checkIns,
          panic: true,
          location: const ScLocation(lat: 40.69, lng: -73.89, label: 'Prospect Park'),
        );
        expect((await _repo.alerts.myOpenSosStream().first).length, 0, 'owner never sees the panic');
        await signInAs(_emailB, name: 'Bia Watcher');
        final alerts = await waitFor(_repo.alerts.incomingAlertsStream(), (l) => l.isNotEmpty, 'panic alert');
        final a = alerts.single;
        expect(a.type, 'panic', 'alert type');
        expect(a.fromUid, uidA, 'alert from');
        expect(a.fromPhone, '(+55) 71 90000-0001', 'owner phone on alert');
        expect(a.location, 'Prospect Park', 'alert location');
        expect(a.lat, 40.69, 'alert lat');
        final j = await waitFor(_repo.journeys.journeyStream(journeyId), (j) => j!.alertRaised, 'alertRaised');
        expectTrue(j!.checkIns.every((c) => c.confirmed), 'all confirmed');
      });

      await step('9. Finishing moves the journey to history; watcher list empties; B resolves the panic', () async {
        await signInAs(_emailA, name: 'Ana Owner');
        await _repo.journeys.finishJourney(journeyId, duration: '12 min');
        final history = await waitFor(_repo.journeys.myHistoryStream(), (l) => l.any((j) => j.id == journeyId), 'history');
        expect(history.firstWhere((j) => j.id == journeyId).status, 'finished', 'status');
        expectTrue(await _repo.journeys.activeJourneyOf(uidA) == null, 'no active journey');
        await signInAs(_emailB, name: 'Bia Watcher');
        await waitFor(_repo.journeys.friendsJourneysStream(), (l) => l.every((j) => j.id != journeyId), 'gone from watcher');
        final open = await _repo.alerts.incomingAlertsStream().first;
        expect(open.where((a) => a.type == 'panic').length, 1, 'panic still open');
        await _repo.alerts.resolveAlert(open.first.id, resolved: true);
        await waitFor(_repo.alerts.incomingAlertsStream(), (l) => l.isEmpty, 'panic resolved');
      });

      await step('10. SOS reaches B; watcher can only resolve; owner cancels', () async {
        await signInAs(_emailA, name: 'Ana Owner');
        final reached = await _repo.alerts.fireSos(location: const ScLocation(lat: 40.6, lng: -73.9, label: 'Home'));
        expect(reached, 1, 'users reached');
        final open = await waitFor(_repo.alerts.myOpenSosStream(), (l) => l.isNotEmpty, 'own open SOS');
        expect(open.single.type, 'sos', 'open type');
        await signInAs(_emailB, name: 'Bia Watcher');
        final incoming = await waitFor(_repo.alerts.incomingAlertsStream(), (l) => l.any((a) => a.type == 'sos'), 'SOS at watcher');
        expect(incoming.single.location, 'Home', 'SOS location');
        await expectDenied(
            () => FirebaseFirestore.instance.collection('alerts').doc(incoming.single.id).update({'type': 'panic'}),
            'watcher editing alert fields');
        await signInAs(_emailA, name: 'Ana Owner');
        await _repo.alerts.resolveMyAlerts();
        await waitFor(_repo.alerts.myOpenSosStream(), (l) => l.isEmpty, 'SOS cancelled');
        await signInAs(_emailB, name: 'Bia Watcher');
        await waitFor(_repo.alerts.incomingAlertsStream(), (l) => l.isEmpty, 'SOS gone at watcher');
      });

      await step('12. Live status: A publishes a position, B sees it; outsiders do not', () async {
        await signInAs(_emailA, name: 'Ana Owner');
        final peers = await _repo.circles.circlePeers();
        expectTrue(peers.contains(uidA) && peers.contains(uidB), 'peers are both members');
        await _repo.status.publishStatus(
          viewerIds: peers,
          lat: 40.67,
          lng: -73.91,
          place: 'Prospect Park',
          moving: true,
          speedKmh: 42,
          battery: 14,
          charging: false,
          since: DateTime.now(),
        );
        await signInAs(_emailB, name: 'Bia Watcher');
        final seen = await waitFor(
            _repo.status.circleStatusStream(), (l) => l.any((s) => s.uid == uidA), 'A on the map');
        final a = seen.firstWhere((s) => s.uid == uidA);
        expect(a.place, 'Prospect Park', 'place');
        expect(a.moving, true, 'moving');
        expectTrue(a.lowBattery, 'low battery badge');
        expect(a.speedKmh, 42.0, 'speed');
      });

      await step('12b. Pausing sharing erases the position for everyone', () async {
        await signInAs(_emailA, name: 'Ana Owner');
        await _repo.status.setSharing(false);
        await signInAs(_emailB, name: 'Bia Watcher');
        final seen = await waitFor(_repo.status.circleStatusStream(),
            (l) => l.any((s) => s.uid == uidA && !s.sharing), 'paused status');
        final a = seen.firstWhere((s) => s.uid == uidA);
        expectFalse(a.hasPosition, 'no coordinates left after pausing');
        expect(a.place, '', 'no place left after pausing');
      });

      await step('13. Places: A creates a geofence, B sees it, B can toggle it', () async {
        await signInAs(_emailA, name: 'Ana Owner');
        final peers = await _repo.circles.circlePeers();
        final place = Place(
          circleId: circle.id!,
          name: 'Home',
          icon: 'home',
          lat: 40.68,
          lng: -73.90,
          radiusM: 150,
        );
        await _repo.places.savePlace(place, viewerIds: peers);
        expectTrue(place.id != null, 'place id');
        await signInAs(_emailB, name: 'Bia Watcher');
        final places = await waitFor(_repo.places.placesStream(), (l) => l.isNotEmpty, 'place visible');
        expect(places.single.name, 'Home', 'place name');
        expect(places.single.ruleLabel, 'Alert on arrive & leave', 'rule label');
        places.single.enabled = false;
        await _repo.places.savePlace(places.single, viewerIds: await _repo.circles.circlePeers());
        await waitFor(_repo.places.placesStream(), (l) => l.single.enabled == false, 'toggle');
      });

      await step('14. Activity: an arrival from A reaches the feed of B', () async {
        await signInAs(_emailA, name: 'Ana Owner');
        await _repo.activity.logActivity(
            type: 'arrive', viewerIds: await _repo.circles.circlePeers(), placeName: 'Home');
        await signInAs(_emailB, name: 'Bia Watcher');
        final feed = await waitFor(_repo.activity.activityStream(), (l) => l.isNotEmpty, 'activity');
        expect(feed.first.title, 'Ana arrived at Home', 'activity title');
      });

      await step('15. Trips: a recorded trip is stored, visible to B, and counted today', () async {
        await signInAs(_emailA, name: 'Ana Owner');
        final now = DateTime.now();
        final start = now.subtract(const Duration(minutes: 20));
        final trip = Trip(
          id: '',
          userId: uidA,
          userName: 'Ana Owner',
          startMillis: start.millisecondsSinceEpoch,
          endMillis: now.millisecondsSinceEpoch,
          fromLabel: 'Home',
          toLabel: 'Work',
          distanceM: 6800,
          maxSpeedKmh: 145,
          points: [
            TripPoint(lat: 40.68, lng: -73.90, atMillis: start.millisecondsSinceEpoch),
            TripPoint(
                lat: 40.67,
                lng: -73.89,
                atMillis: start.add(const Duration(minutes: 10)).millisecondsSinceEpoch,
                speedKmh: 145),
            TripPoint(lat: 40.66, lng: -73.88, atMillis: now.millisecondsSinceEpoch),
          ],
        );
        await _repo.trips.saveTrip(trip, viewerIds: await _repo.circles.circlePeers());
        final totals = await _repo.trips.todayTotals(uidA);
        expect(totals.$1, 1, 'trips today');
        expect(totals.$2, 6800.0, 'metres today');

        await signInAs(_emailB, name: 'Bia Watcher');
        final week = await waitFor(
            _repo.trips.tripsStream(uidA, from: weekStart(0), to: weekStart(-1)),
            (l) => l.isNotEmpty,
            'trip visible to the circle');
        final t = week.single;
        expect(t.title, 'Home → Work', 'trip title');
        expectTrue(t.overLimit, 'over the speed limit');
        expect(t.overLimitAt.length, 1, 'one speeding event');
        expect(t.points.length, 3, 'points stored');
      });

      await step('16. Deleting an account wipes its position, trips and activity', () async {
        final uidC = await signInAs(_emailC, name: 'Caio Leaver');
        final me = [uidC];
        await _repo.status.publishStatus(viewerIds: me, lat: 40.6, lng: -73.9, place: 'Here');
        await _repo.activity.logActivity(type: 'arrive', viewerIds: me, placeName: 'Gym');
        final now = DateTime.now();
        await _repo.trips.saveTrip(
          Trip(
            id: '',
            userId: uidC,
            userName: 'Caio Leaver',
            startMillis: now.subtract(const Duration(minutes: 9)).millisecondsSinceEpoch,
            endMillis: now.millisecondsSinceEpoch,
            distanceM: 900,
            points: const [],
          ),
          viewerIds: me,
        );
        await _repo.users.deleteMyData();
        final fs = FirebaseFirestore.instance;
        expectFalse((await fs.collection('status').doc(uidC).get()).exists, 'status deleted');
        expect((await fs.collection('trips').where('userId', isEqualTo: uidC).get()).docs.length, 0,
            'trips deleted');
        expect(
            (await fs.collection('activity').where('userId', isEqualTo: uidC).get()).docs.length, 0,
            'activity deleted');
      });

      await step('11. Removing B stops B watching; deleting the circle cleans up', () async {
        await signInAs(_emailA, name: 'Ana Owner');
        circle = (await _repo.circles.myCirclesStream().first).firstWhere((c) => c.id == circle.id);
        final member = circle.members.single;
        circle.members.remove(member);
        await _repo.circles.removeMember(circle, member);
        final l = await waitFor(_repo.circles.myCirclesStream(),
            (l) => !l.firstWhere((c) => c.id == circle.id).memberIds.contains(uidB), 'B removed');
        expect(l.firstWhere((c) => c.id == circle.id).memberIds, [uidA], 'member ids after removal');
        await signInAs(_emailB, name: 'Bia Watcher');
        await waitFor(_repo.circles.myCirclesStream(), (l) => l.every((c) => c.id != circle.id), 'circle gone for B');
        await signInAs(_emailA, name: 'Ana Owner');
        await _repo.circles.deleteCircle(circle.id!);
        await waitFor(_repo.circles.myCirclesStream(), (l) => l.every((c) => c.id != circle.id), 'circle deleted');
      });
    } catch (e) {
      debugPrint('[E2E] $e');
    }
    if (mounted) setState(() => done = true);
    final passed = checks.where((c) => c.status == 'pass').length;
    debugPrint('[E2E] DONE $passed/${checks.length} passed');
  }

  @override
  Widget build(BuildContext context) {
    final passed = checks.where((c) => c.status == 'pass').length;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF8F6F7),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                done ? 'E2E done — $passed/${checks.length} passed' : 'E2E running…',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              for (final c in checks)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 28,
                        child: Text(
                          c.status == 'pass' ? '✅' : c.status == 'fail' ? '❌' : '⏳',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            if (c.detail.isNotEmpty)
                              Text(c.detail, style: const TextStyle(fontSize: 12, color: Color(0xFFDC2626))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
