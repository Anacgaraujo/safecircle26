import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/data/firestore_repository.dart';
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/features/circles/domain/circle.dart';

final contactsRepositoryProvider = Provider<ContactsRepository>(
    (ref) => ContactsRepository(ref.watch(firestoreProvider), session: ref.watch(sessionProvider)));

final contactsProvider = StreamProvider.autoDispose<List<Person>>(
    (ref) => ref.watch(contactsRepositoryProvider).contactsStream());

class ContactsRepository extends FirestoreRepository {
  ContactsRepository(super.db, {super.currentUid, super.session});

  CollectionReference<Map<String, dynamic>> get _contacts =>
      db.collection('users').doc(uid).collection('contacts');

  Stream<List<Person>> contactsStream() => _contacts.orderBy('name').snapshots().map(
      (s) => s.docs.map((d) => Person.fromMap(d.data(), id: d.id)).toList());

  Future<void> addContact(Person p) => _contacts.add(p.toMap());

  Future<void> updateContact(Person p) => _contacts.doc(p.id).set(p.toMap());

  Future<void> deleteContact(String id) => _contacts.doc(id).delete();

  Future<List<Person>> getContacts() async {
    final s = await _contacts.orderBy('name').get();
    return s.docs.map((d) => Person.fromMap(d.data(), id: d.id)).toList();
  }
}
