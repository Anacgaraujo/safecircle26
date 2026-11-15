import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/data/firestore_repository.dart';
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/features/live_map/domain/tracking.dart';

final activityRepositoryProvider = Provider<ActivityRepository>(
    (ref) => ActivityRepository(ref.watch(firestoreProvider), session: ref.watch(sessionProvider)));

final activityFeedProvider = StreamProvider.autoDispose<List<ActivityEvent>>(
    (ref) => ref.watch(activityRepositoryProvider).activityStream());

final recentActivityProvider = StreamProvider.autoDispose<List<ActivityEvent>>(
    (ref) => ref.watch(activityRepositoryProvider).activityStream(limit: 10));

class ActivityRepository extends FirestoreRepository {
  ActivityRepository(super.db, {super.currentUid, super.session});

  Future<void> logActivity({
    required String type,
    required List<String> viewerIds,
    String placeName = '',
    String detail = '',
  }) =>
      db.collection('activity').add({
        'userId': uid,
        'userName': session.userName,
        'type': type,
        'placeName': placeName,
        'detail': detail,
        'atMillis': DateTime.now().millisecondsSinceEpoch,
        'viewerIds': viewerIds,
      });

  Stream<List<ActivityEvent>> activityStream({int limit = 30}) => db
      .collection('activity')
      .where('viewerIds', arrayContains: uid)
      .orderBy('atMillis', descending: true)
      .limit(limit)
      .snapshots()
      .map((s) => s.docs.map((d) => ActivityEvent.fromMap(d.data(), d.id)).toList());
}
