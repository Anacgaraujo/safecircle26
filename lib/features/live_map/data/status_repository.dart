import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/data/firestore_repository.dart';
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/features/live_map/domain/tracking.dart';

final statusRepositoryProvider = Provider<StatusRepository>(
    (ref) => StatusRepository(ref.watch(firestoreProvider), session: ref.watch(sessionProvider)));

final memberStatusProvider = StreamProvider.autoDispose.family<MemberStatus?, String>(
    (ref, uid) => ref.watch(statusRepositoryProvider).statusOf(uid));

final circleStatusProvider = StreamProvider.autoDispose<List<MemberStatus>>(
    (ref) => ref.watch(statusRepositoryProvider).circleStatusStream());

class StatusRepository extends FirestoreRepository {
  StatusRepository(super.db, {super.currentUid, super.session});

  DocumentReference<Map<String, dynamic>> get _mine => db.collection('status').doc(uid);

  Future<void> publishStatus({
    required List<String> viewerIds,
    double? lat,
    double? lng,
    String place = '',
    bool moving = false,
    double speedKmh = 0,
    int battery = -1,
    bool charging = false,
    bool sharing = true,
    DateTime? since,
    int? tripsToday,
    double? metersToday,
  }) {
    return _mine.set({
      'name': session.userName,
      'photo': session.userPhoto,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      'place': place,
      'moving': moving,
      'speedKmh': speedKmh,
      'battery': battery,
      'charging': charging,
      'sharing': sharing,
      if (since != null) 'sinceMillis': since.millisecondsSinceEpoch,
      'updatedMillis': DateTime.now().millisecondsSinceEpoch,
      if (tripsToday != null) 'tripsToday': tripsToday,
      if (metersToday != null) 'metersToday': metersToday,
      'viewerIds': viewerIds,
    }, SetOptions(merge: true));
  }

  Future<void> setSharing(bool on) => _mine.set({
        'sharing': on,
        'updatedMillis': DateTime.now().millisecondsSinceEpoch,
        if (!on) ...{
          'lat': FieldValue.delete(),
          'lng': FieldValue.delete(),
          'place': '',
          'moving': false,
          'speedKmh': 0,
        },
      }, SetOptions(merge: true));

  Stream<List<MemberStatus>> circleStatusStream() => db
      .collection('status')
      .where('viewerIds', arrayContains: uid)
      .snapshots()
      .map((s) => s.docs.map((d) => MemberStatus.fromMap(d.data(), d.id)).toList());

  Stream<MemberStatus?> statusOf(String memberUid) => db
      .collection('status')
      .doc(memberUid)
      .snapshots()
      .map((d) => d.exists ? MemberStatus.fromMap(d.data()!, d.id) : null);

  Future<MemberStatus?> myStatus() async {
    DocumentSnapshot<Map<String, dynamic>> d;
    try {
      d = await _mine.get().timeout(const Duration(seconds: 4));
    } catch (_) {
      try {
        d = await _mine.get(const GetOptions(source: Source.cache));
      } catch (_) {
        return null;
      }
    }
    return d.exists ? MemberStatus.fromMap(d.data()!, d.id) : null;
  }
}
