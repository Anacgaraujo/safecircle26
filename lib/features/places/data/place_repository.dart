import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/data/firestore_repository.dart';
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/features/live_map/domain/tracking.dart';

final placeRepositoryProvider = Provider<PlaceRepository>(
    (ref) => PlaceRepository(ref.watch(firestoreProvider), session: ref.watch(sessionProvider)));

final placesProvider = StreamProvider.autoDispose<List<Place>>(
    (ref) => ref.watch(placeRepositoryProvider).placesStream());

class PlaceRepository extends FirestoreRepository {
  PlaceRepository(super.db, {super.currentUid, super.session});

  CollectionReference<Map<String, dynamic>> get _places => db.collection('places');

  Stream<List<Place>> placesStream() => _places
      .where('viewerIds', arrayContains: uid)
      .snapshots()
      .map((s) => s.docs.map((d) => Place.fromMap(d.data(), d.id)).toList());

  Future<List<Place>> getPlaces() async {
    final q = await _places.where('viewerIds', arrayContains: uid).get();
    return q.docs.map((d) => Place.fromMap(d.data(), d.id)).toList();
  }

  Future<String> savePlace(Place p, {required List<String> viewerIds}) async {
    final data = {...p.toMap(), 'viewerIds': viewerIds};
    if (p.id == null) {
      final ref = await _places.add({
        ...data,
        'createdBy': uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
      p.id = ref.id;
      return ref.id;
    }
    await _places.doc(p.id).update(data);
    return p.id!;
  }

  Future<void> deletePlace(String id) => _places.doc(id).delete();
}
