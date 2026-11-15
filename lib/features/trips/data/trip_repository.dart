import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/data/firestore_repository.dart';
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/features/live_map/domain/tracking.dart';
import 'package:safecircle/features/trips/domain/trip_rules.dart';

final tripRepositoryProvider = Provider<TripRepository>(
    (ref) => TripRepository(ref.watch(firestoreProvider), session: ref.watch(sessionProvider)));

final tripsOfWeekProvider =
    StreamProvider.autoDispose.family<List<Trip>, ({String userId, int weeksAgo})>((ref, key) =>
        ref.watch(tripRepositoryProvider).tripsStream(key.userId,
            from: weekStart(key.weeksAgo), to: weekStart(key.weeksAgo - 1)));

final weeklyTripCountsProvider =
    FutureProvider.autoDispose.family<List<int>, String>((ref, userId) async {
  final trips = ref.watch(tripRepositoryProvider);
  final out = <int>[];
  for (var w = 3; w >= 0; w--) {
    try {
      out.add((await trips.tripsStream(userId, from: weekStart(w), to: weekStart(w - 1)).first)
          .length);
    } catch (_) {
      out.add(0);
    }
  }
  return out;
});

class TripRepository extends FirestoreRepository {
  TripRepository(super.db, {super.currentUid, super.session});

  Future<String> saveTrip(Trip t, {required List<String> viewerIds}) async {
    final ref = await db.collection('trips').add({...t.toMap(), 'viewerIds': viewerIds});
    return ref.id;
  }

  Stream<List<Trip>> tripsStream(String userId, {required DateTime from, required DateTime to}) =>
      db
          .collection('trips')
          .where('viewerIds', arrayContains: uid)
          .where('userId', isEqualTo: userId)
          .where('startMillis', isGreaterThanOrEqualTo: from.millisecondsSinceEpoch)
          .where('startMillis', isLessThan: to.millisecondsSinceEpoch)
          .orderBy('startMillis', descending: true)
          .snapshots()
          .map((s) => s.docs.map((d) => Trip.fromMap(d.data(), d.id)).toList());

  Future<(int trips, double meters)> todayTotals(String userId) async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    final q = await db
        .collection('trips')
        .where('viewerIds', arrayContains: uid)
        .where('userId', isEqualTo: userId)
        .where('startMillis', isGreaterThanOrEqualTo: midnight.millisecondsSinceEpoch)
        .get();
    var meters = .0;
    for (final d in q.docs) {
      meters += ((d.data()['distanceM'] ?? 0) as num).toDouble();
    }
    return (q.docs.length, meters);
  }
}
