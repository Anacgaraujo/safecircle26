import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/data/firestore_repository.dart';
import 'package:safecircle/core/location/location_service.dart';
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/core/utils/formatters.dart';
import 'package:safecircle/features/alerts/data/alert_repository.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/journeys/domain/journey.dart';

final journeyRepositoryProvider = Provider<JourneyRepository>((ref) => JourneyRepository(
      ref.watch(firestoreProvider),
      session: ref.watch(sessionProvider),
      alerts: ref.watch(alertRepositoryProvider),
    ));

final myActiveJourneyProvider = StreamProvider.autoDispose<Journey?>(
    (ref) => ref.watch(journeyRepositoryProvider).myActiveJourneyStream());

final friendsJourneysProvider = StreamProvider.autoDispose<List<Journey>>(
    (ref) => ref.watch(journeyRepositoryProvider).friendsJourneysStream());

final journeyHistoryProvider = StreamProvider.autoDispose<List<Journey>>(
    (ref) => ref.watch(journeyRepositoryProvider).myHistoryStream());

final journeyProvider = StreamProvider.autoDispose.family<Journey?, String>(
    (ref, id) => ref.watch(journeyRepositoryProvider).journeyStream(id));

final activeJourneyOfProvider = FutureProvider.autoDispose.family<Journey?, String>(
    (ref, ownerUid) => ref.watch(journeyRepositoryProvider).activeJourneyOf(ownerUid));

class JourneyRepository extends FirestoreRepository {
  JourneyRepository(super.db, {required this.alerts, super.currentUid, super.session});

  final AlertRepository alerts;

  CollectionReference<Map<String, dynamic>> get _journeys => db.collection('journeys');

  Future<String> startJourney({
    required Circle circle,
    required List<CheckIn> checkIns,
    ScLocation? location,
    String note = '',
  }) async {
    final now = DateTime.now();
    final ref = await _journeys.add({
      'ownerId': uid,
      'ownerName': session.userName,
      'ownerPhone': session.userPhone,
      'circleId': circle.id,
      'circleName': circle.name,
      'watcherIds': circle.memberIds.where((id) => id != uid).toList(),
      'status': 'active',
      'checkIns': checkIns.map((c) => c.toMap()).toList(),
      'alertRaised': false,
      'note': note,
      'dateLabel': scDateLabel(now),
      'duration': '',
      if (location != null) ...{
        'lastLat': location.lat,
        'lastLng': location.lng,
        'lastPlace': location.label,
      },
      'lastSeen': 'Last seen ${scClock(now)}',
      'startedAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  Future<void> confirmCheckIn({
    required String journeyId,
    required List<CheckIn> checkIns,
    required bool panic,
    ScLocation? location,
  }) async {
    await _journeys.doc(journeyId).update({
      'checkIns': checkIns.map((c) => c.toMap()).toList(),
      if (panic) 'alertRaised': true,
      if (location != null) ...{
        'lastLat': location.lat,
        'lastLng': location.lng,
        'lastPlace': location.label,
      },
      'lastSeen': 'Last seen ${scClock(DateTime.now())}',
    });
    if (panic) await alerts.fireAlert(type: 'panic', location: location);
    await alerts.resolveMyAlerts(types: const {'overdue'});
  }

  Future<void> finishJourney(String journeyId, {required String duration}) async {
    await _journeys.doc(journeyId).update({
      'status': 'finished',
      'duration': duration,
      'finishedAt': FieldValue.serverTimestamp(),
    });
    await alerts.resolveMyAlerts(types: const {'overdue'});
  }

  Stream<Journey?> myActiveJourneyStream() => _journeys
      .where('ownerId', isEqualTo: uid)
      .where('status', isEqualTo: 'active')
      .limit(1)
      .snapshots()
      .map((s) => s.docs.isEmpty ? null : Journey.fromMap(s.docs.first.data(), s.docs.first.id));

  Future<void> updateJourneyLocation(String journeyId, ScLocation loc) =>
      _journeys.doc(journeyId).update({
        'lastLat': loc.lat,
        'lastLng': loc.lng,
        'lastPlace': loc.label,
        'lastSeen': 'Last seen ${scClock(DateTime.now())}',
      });

  Future<void> raiseOverdueOnJourney(Journey j, CheckIn missed, {ScLocation? location}) async {
    final ref = _journeys.doc(j.id);
    final key = missed.atMillis ?? 0;
    final claimed = await db.runTransaction<bool>((tx) async {
      final snap = await tx.get(ref);
      final already = (snap.data()?['overdueAlerted'] ?? const []) as List;
      if (already.contains(key)) return false;
      tx.update(ref, {
        'overdueAlerted': FieldValue.arrayUnion([key]),
      });
      return true;
    });
    if (!claimed) return;
    await alerts.fireAlert(type: 'overdue', location: location, detail: missed.label);
  }

  Future<void> raisePanicOnJourney(String journeyId, {ScLocation? location}) async {
    await _journeys.doc(journeyId).update({'alertRaised': true});
    await alerts.fireAlert(type: 'panic', location: location);
  }

  Stream<Journey?> journeyStream(String id) => _journeys
      .doc(id)
      .snapshots()
      .map((d) => d.exists ? Journey.fromMap(d.data()!, d.id) : null);

  Stream<List<Journey>> friendsJourneysStream() => _journeys
      .where('watcherIds', arrayContains: uid)
      .where('status', isEqualTo: 'active')
      .snapshots()
      .map((s) => s.docs.map((d) => Journey.fromMap(d.data(), d.id)).toList());

  Stream<List<Journey>> myHistoryStream() => _journeys
      .where('ownerId', isEqualTo: uid)
      .where('status', isEqualTo: 'finished')
      .snapshots()
      .map((s) => s.docs.map((d) => Journey.fromMap(d.data(), d.id)).toList());

  /// Deletes one of my finished journeys. Active journeys are never deleted
  /// from history: they still protect the traveler.
  Future<void> deleteFinishedJourney(String id) async {
    final ref = _journeys.doc(id);
    final data = (await ref.get()).data();
    if (data == null || data['ownerId'] != uid || data['status'] != 'finished') return;
    await ref.delete();
  }

  /// Deletes all of my finished journeys; returns how many were deleted.
  Future<int> deleteAllFinishedJourneys() async {
    final q = await _journeys
        .where('ownerId', isEqualTo: uid)
        .where('status', isEqualTo: 'finished')
        .get();
    // A Firestore batch holds at most 500 writes.
    for (var i = 0; i < q.docs.length; i += 400) {
      final batch = db.batch();
      for (final d in q.docs.skip(i).take(400)) {
        batch.delete(d.reference);
      }
      await batch.commit();
    }
    return q.docs.length;
  }

  Future<Journey?> activeJourneyOf(String ownerUid) async {
    final q = await (ownerUid == uid
            ? _journeys.where('ownerId', isEqualTo: uid)
            : _journeys.where('watcherIds', arrayContains: uid))
        .where('status', isEqualTo: 'active')
        .get();
    for (final d in q.docs) {
      if (d.data()['ownerId'] == ownerUid) return Journey.fromMap(d.data(), d.id);
    }
    return null;
  }
}
