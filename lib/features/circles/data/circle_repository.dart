import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/data/firestore_repository.dart';
import 'package:safecircle/core/data/lookup_hash.dart';
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/circles/domain/circle_invite.dart';

final circleRepositoryProvider = Provider<CircleRepository>(
    (ref) => CircleRepository(ref.watch(firestoreProvider), session: ref.watch(sessionProvider)));

final myCirclesProvider = StreamProvider.autoDispose<List<Circle>>(
    (ref) => ref.watch(circleRepositoryProvider).myCirclesStream());

final pendingInvitesProvider = StreamProvider.autoDispose<List<CircleInvite>>(
    (ref) => ref.watch(circleRepositoryProvider).pendingInvitesStream());

/// For a circle I own: invitation status ('pending', 'accepted'…) by email.
final sentInviteStatusProvider = StreamProvider.autoDispose.family<Map<String, String>, String>(
    (ref, circleId) => ref.watch(circleRepositoryProvider).sentInviteStatusStream(circleId));

class CircleRepository extends FirestoreRepository {
  CircleRepository(super.db, {super.currentUid, super.session});

  Stream<List<Circle>> myCirclesStream() => db
      .collection('circles')
      .where('memberIds', arrayContains: uid)
      .snapshots()
      .map((s) => s.docs.map((d) => Circle.fromMap(d.data(), id: d.id)).toList());

  Future<List<String>> circlePeers() async {
    final circles = await db.collection('circles').where('memberIds', arrayContains: uid).get();
    final ids = <String>{};
    for (final d in circles.docs) {
      ids.addAll(((d.data()['memberIds'] ?? const []) as List).cast<String>());
    }
    ids.add(uid);
    return ids.toList();
  }

  Future<String> createCircle(Circle c) async {
    c.ownerId = uid;
    c.ownerName = session.userName;
    if (!c.memberIds.contains(uid)) c.memberIds.add(uid);
    final ref = await db.collection('circles').add(c.toMap());
    c.id = ref.id;
    return ref.id;
  }

  Future<void> updateCircle(Circle c) => db.collection('circles').doc(c.id).update({
        'name': c.name,
        'members': c.members.map((p) => p.toMap()).toList(),
      });

  Future<(String uid, String name)?> findUserByEmail(String email) async {
    final q = await db
        .collection('users')
        .where('emailHash', isEqualTo: emailHash(email))
        .limit(1)
        .get();
    if (q.docs.isEmpty) return null;
    final doc = q.docs.first;
    return (doc.id, (doc.data()['name'] ?? '') as String);
  }

  Future<void> removeMember(Circle c, Person member) async {
    final ref = db.collection('circles').doc(c.id);
    var memberUid = member.uid;
    if ((memberUid == null || memberUid.isEmpty) && (member.email ?? '').isNotEmpty) {
      memberUid = (await findUserByEmail(member.email!))?.$1;
    }
    await ref.update({
      'members': c.members.map((p) => p.toMap()).toList(),
      if (memberUid != null && memberUid.isNotEmpty) ...{
        'memberIds': FieldValue.arrayRemove([memberUid]),
        'invitedUids': FieldValue.arrayRemove([memberUid]),
      },
    });
  }

  Future<void> leaveCircle(String id) async {
    final ref = db.collection('circles').doc(id);
    final data = (await ref.get()).data();
    if (data == null || data['ownerId'] == uid) return;
    await ref.update(leavingUpdate(data));
  }

  Map<String, dynamic> leavingUpdate(Map<String, dynamic> circle) {
    final email = session.userEmail.toLowerCase();
    bool isMe(Map<String, dynamic> m) =>
        m['uid'] == uid || (email.isNotEmpty && (m['email'] as String?)?.toLowerCase() == email);
    return {
      'members': ((circle['members'] ?? []) as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .where((m) => !isMe(m))
          .toList(),
      'memberIds': FieldValue.arrayRemove([uid]),
    };
  }

  Future<void> deleteCircle(String id) async {
    final invites = await db
        .collection('invites')
        .where('fromUid', isEqualTo: uid)
        .where('circleId', isEqualTo: id)
        .get();
    for (final d in invites.docs) {
      await d.reference.delete();
    }
    await db.collection('circles').doc(id).delete();
  }

  Future<bool> sendInvite({required Circle circle, required String toEmail}) async {
    final target = await findUserByEmail(toEmail);
    if (target == null) return false;
    final (targetUid, _) = target;
    if (targetUid == uid || circle.memberIds.contains(targetUid)) return true;
    final dup = await db
        .collection('invites')
        .where('fromUid', isEqualTo: uid)
        .where('circleId', isEqualTo: circle.id)
        .where('toUid', isEqualTo: targetUid)
        .where('status', isEqualTo: 'pending')
        .limit(1)
        .get();
    if (dup.docs.isNotEmpty) return true;
    await db.collection('circles').doc(circle.id).update({
      'invitedUids': FieldValue.arrayUnion([targetUid]),
    });
    await db.collection('invites').add({
      'circleId': circle.id,
      'circleName': circle.name,
      'fromUid': uid,
      'fromName': session.userName,
      'toEmail': toEmail.trim().toLowerCase(),
      'toUid': targetUid,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
    return true;
  }

  Stream<Map<String, String>> sentInviteStatusStream(String circleId) => db
      .collection('invites')
      .where('fromUid', isEqualTo: uid)
      .where('circleId', isEqualTo: circleId)
      .snapshots()
      .map((s) => {
            for (final d in s.docs)
              ((d.data()['toEmail'] ?? '') as String): ((d.data()['status'] ?? '') as String),
          });

  Stream<List<CircleInvite>> pendingInvitesStream() => db
      .collection('invites')
      .where('toEmail', isEqualTo: session.userEmail.toLowerCase())
      .where('status', isEqualTo: 'pending')
      .snapshots()
      .map((s) => s.docs.map((d) => CircleInvite.fromMap(d.data(), id: d.id)).toList());

  Future<void> acceptInvite(CircleInvite invite) async {
    final circleId = invite.circleId;
    await db.collection('circles').doc(circleId).update({
      'memberIds': FieldValue.arrayUnion([uid]),
      'invitedUids': FieldValue.arrayRemove([uid]),
    });
    await db.collection('invites').doc(invite.id).update({'status': 'accepted'});
  }

  Future<void> declineInvite(String inviteId) =>
      db.collection('invites').doc(inviteId).update({'status': 'declined'});
}
