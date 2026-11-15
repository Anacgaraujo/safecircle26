import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/data/firestore_repository.dart';
import 'package:safecircle/core/data/lookup_hash.dart';
import 'package:safecircle/core/location/location_service.dart';
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/core/utils/formatters.dart';
import 'package:safecircle/core/utils/phone.dart';
import 'package:safecircle/features/alerts/domain/safety_alert.dart';
import 'package:safecircle/features/contacts/data/contacts_repository.dart';

final alertRepositoryProvider = Provider<AlertRepository>((ref) => AlertRepository(
      ref.watch(firestoreProvider),
      session: ref.watch(sessionProvider),
      contacts: ref.watch(contactsRepositoryProvider),
    ));

final incomingAlertsProvider = StreamProvider.autoDispose<List<SafetyAlert>>(
    (ref) => ref.watch(alertRepositoryProvider).incomingAlertsStream());

final myOpenSosProvider = StreamProvider.autoDispose<List<SafetyAlert>>(
    (ref) => ref.watch(alertRepositoryProvider).myOpenSosStream());

class AlertRepository extends FirestoreRepository {
  AlertRepository(super.db, {required this.contacts, super.currentUid, super.session});

  final ContactsRepository contacts;

  Future<int> fireAlert({required String type, ScLocation? location, String detail = ''}) async {
    final circles = await db.collection('circles').where('memberIds', arrayContains: uid).get();
    final watchers = <String>{};
    for (final d in circles.docs) {
      watchers.addAll(((d.data()['memberIds'] ?? []) as List).cast<String>());
    }
    for (final c in await contacts.getContacts()) {
      if (nationalDigits(c.digits, country: c.countryCode).length < 7) continue;
      final q = await db
          .collection('users')
          .where('phoneHash', isEqualTo: lookupHash(phoneE164(c.countryCode, c.digits)))
          .limit(1)
          .get();
      if (q.docs.isNotEmpty) watchers.add(q.docs.first.id);
    }
    watchers.remove(uid);

    await db.collection('alerts').add({
      'fromUid': uid,
      'fromName': session.userName,
      'fromPhone': session.userPhone,
      'type': type,
      'detail': detail,
      'watcherIds': watchers.toList(),
      'location': location?.label ?? '',
      if (location != null) ...{'lat': location.lat, 'lng': location.lng},
      'resolved': false,
      'timeLabel': scClock(DateTime.now()),
      'createdAt': FieldValue.serverTimestamp(),
    });
    return watchers.length;
  }

  Future<int> fireSos({ScLocation? location}) => fireAlert(type: 'sos', location: location);

  Future<void> resolveMyAlerts({Set<String> types = const {'sos'}}) async {
    final q = await db
        .collection('alerts')
        .where('fromUid', isEqualTo: uid)
        .where('resolved', isEqualTo: false)
        .get();
    for (final d in q.docs) {
      if (types.contains(d.data()['type'])) {
        await d.reference.update({'resolved': true});
      }
    }
  }

  Future<void> resolveAlert(String id, {required bool resolved}) =>
      db.collection('alerts').doc(id).update({'resolved': resolved});

  Stream<List<SafetyAlert>> myOpenSosStream() => db
      .collection('alerts')
      .where('fromUid', isEqualTo: uid)
      .where('resolved', isEqualTo: false)
      .snapshots()
      .map((s) => s.docs
          .map((d) => SafetyAlert.fromMap(d.data(), d.id))
          .where((a) => a.type == 'sos')
          .toList());

  Stream<List<SafetyAlert>> incomingAlertsStream() => db
      .collection('alerts')
      .where('watcherIds', arrayContains: uid)
      .where('resolved', isEqualTo: false)
      .snapshots()
      .map((s) => s.docs.map((d) => SafetyAlert.fromMap(d.data(), d.id)).toList());
}
