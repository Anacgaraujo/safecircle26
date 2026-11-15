import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/data/firestore_repository.dart';
import 'package:safecircle/core/data/lookup_hash.dart';
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/features/circles/data/circle_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) => UserRepository(
      ref.watch(firestoreProvider),
      session: ref.watch(sessionProvider),
      circles: ref.watch(circleRepositoryProvider),
    ));

class UserRepository extends FirestoreRepository {
  UserRepository(super.db, {required this.circles, super.currentUid, super.session});

  final CircleRepository circles;

  DocumentReference<Map<String, dynamic>> _user(String id) => db.collection('users').doc(id);

  DocumentReference<Map<String, dynamic>> get _profile =>
      _user(uid).collection('private').doc('profile');

  DocumentReference<Map<String, dynamic>> get _secrets =>
      _user(uid).collection('private').doc('secrets');

  Future<void> createUserDoc({
    required String uid,
    required String name,
    required String email,
    String phone = '',
  }) async {
    await _user(uid).set({
      'name': name,
      'emailHash': emailHash(email),
      if (phone.isNotEmpty) 'phoneHash': phoneHash(phone),
      'lookupV': kLookupVersion,
      'email': FieldValue.delete(),
      'phone': FieldValue.delete(),
      'phoneDigits': FieldValue.delete(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    await _user(uid).collection('private').doc('profile').set({
      'email': email.trim().toLowerCase(),
      if (phone.isNotEmpty) 'phone': phone,
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getUserDoc(String uid) async =>
      (await readWithCacheFallback(_user(uid))).data();

  Future<Map<String, dynamic>?> getPrivateProfile() async =>
      (await readWithCacheFallback(_profile)).data();

  Future<void> updateUserProfile({String? name, String? phone, String? photoPath}) async {
    await _user(uid).set({
      if (name != null) 'name': name,
      if (phone != null) 'phoneHash': phone.isEmpty ? FieldValue.delete() : phoneHash(phone),
      if (phone != null) 'lookupV': kLookupVersion,
      if (photoPath != null) 'photoPath': photoPath,
    }, SetOptions(merge: true));
    if (phone != null) {
      await _profile.set({'phone': phone}, SetOptions(merge: true));
    }
  }

  Future<void> savePins({String? safety, String? panic}) async {
    final data = <String, dynamic>{
      if (safety != null) 'safetyPinHash': hashPin(uid, safety),
      if (panic != null) 'panicPinHash': hashPin(uid, panic),
      'safetyPin': FieldValue.delete(),
      'panicPin': FieldValue.delete(),
    };
    await _secrets.set(data, SetOptions(merge: true));
    session.setPins(
      safety: safety != null ? data['safetyPinHash'] as String : session.safetyPin,
      panic: panic != null ? data['panicPinHash'] as String : session.panicPin,
    );
  }

  Future<(String safety, String panic)> getPins() async {
    final d = (await readWithCacheFallback(_secrets)).data();
    var safety = (d?['safetyPinHash'] ?? '') as String;
    var panic = (d?['panicPinHash'] ?? '') as String;
    final legacySafety = (d?['safetyPin'] ?? '') as String;
    final legacyPanic = (d?['panicPin'] ?? '') as String;
    if (safety.isEmpty && legacySafety.isNotEmpty) {
      await savePins(safety: legacySafety, panic: legacyPanic.isEmpty ? null : legacyPanic);
      safety = hashPin(uid, legacySafety);
      panic = legacyPanic.isEmpty ? '' : hashPin(uid, legacyPanic);
    }
    return (safety, panic);
  }

  Future<void> saveSetting(String key, bool value) =>
      _user(uid).set({'settings': {key: value}}, SetOptions(merge: true));

  Future<Map<String, bool>> getSettings() async {
    final snap = await readWithCacheFallback(_user(uid));
    final raw = (snap.data()?['settings'] ?? {}) as Map<String, dynamic>;
    return {
      'checkinReminder': (raw['checkinReminder'] ?? true) as bool,
      'circleAlerts': (raw['circleAlerts'] ?? true) as bool,
      'overdueAlerts': (raw['overdueAlerts'] ?? true) as bool,
      'mapHome': (raw['mapHome'] ?? true) as bool,
    };
  }

  Future<void> deleteMyData() async {
    Future<void> wipe(Query<Map<String, dynamic>> q) async {
      for (final d in (await q.get()).docs) {
        await d.reference.delete();
      }
    }

    await wipe(_user(uid).collection('contacts'));
    await _secrets.delete();
    await _profile.delete();
    final joined = await db.collection('circles').where('memberIds', arrayContains: uid).get();
    for (final d in joined.docs) {
      final data = d.data();
      if (data['ownerId'] == uid) continue;
      await d.reference.update(circles.leavingUpdate(data));
    }
    await wipe(db.collection('circles').where('ownerId', isEqualTo: uid));
    await wipe(db.collection('journeys').where('ownerId', isEqualTo: uid));
    await wipe(db.collection('alerts').where('fromUid', isEqualTo: uid));
    await wipe(db.collection('invites').where('fromUid', isEqualTo: uid));
    await wipe(db.collection('trips').where('userId', isEqualTo: uid));
    await wipe(db.collection('activity').where('userId', isEqualTo: uid));
    await db.collection('status').doc(uid).delete();
    await _user(uid).delete();
  }
}
