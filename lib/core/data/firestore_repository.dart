import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/session/session.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

abstract class FirestoreRepository {
  FirestoreRepository(this.db, {String Function()? currentUid, Session? session})
      : session = session ?? Session.instance,
        _currentUid = currentUid ?? (() => (session ?? Session.instance).uid);

  final FirebaseFirestore db;

  final Session session;
  final String Function() _currentUid;

  String get uid => _currentUid();
}

Future<DocumentSnapshot<Map<String, dynamic>>> readWithCacheFallback(
    DocumentReference<Map<String, dynamic>> ref) async {
  try {
    return await ref.get().timeout(const Duration(seconds: 5));
  } catch (_) {
    return ref.get(const GetOptions(source: Source.cache));
  }
}
