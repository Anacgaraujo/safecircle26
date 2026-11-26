// Push notifications (Firebase Cloud Messaging) for SOS, panic, missed
// check-ins, all-clears and circle invitations, so they reach people even
// when the app is closed. Device tokens live in users/{uid}/private/push
// (`tokens`), saved by lib/core/notifications/push_service.dart.
const { onDocumentCreated, onDocumentUpdated } = require('firebase-functions/v2/firestore');
const logger = require('firebase-functions/logger');
const { getFirestore, FieldValue } = require('firebase-admin/firestore');
const { getMessaging } = require('firebase-admin/messaging');

const { alertPush, allClearPush, invitePush, placePush, DEAD_TOKEN_ERRORS } = require('./push_messages');
const { lookupHash } = require('./emergency');
const { toE164 } = require('./invite_texts');

const options = { maxInstances: 10 };

/** Pushes `{title, body}` with `data` to every phone of `uids`. */
async function pushTo(db, uids, { title, body }, data, context) {
  const ids = [...new Set((uids || []).filter(Boolean))];
  if (!ids.length) return 0;
  const docs = await db.getAll(...ids.map((id) => db.doc(`users/${id}/private/push`)));
  const owners = [];
  for (const d of docs) {
    for (const token of (d.exists && d.data().tokens) || []) owners.push({ token, ref: d.ref });
  }
  if (!owners.length) {
    // Usually: the person never allowed notifications, or hasn't opened a
    // build with push since installing it.
    logger.info('No phones to push', { ...context, people: ids.length });
    return 0;
  }

  let sent = 0;
  for (let i = 0; i < owners.length; i += 500) {
    const batch = owners.slice(i, i + 500);
    const res = await getMessaging().sendEachForMulticast({
      tokens: batch.map((o) => o.token),
      notification: { title, body },
      data,
      android: { priority: 'high', notification: { channelId: 'safecircle_alerts', sound: 'default' } },
      apns: { headers: { 'apns-priority': '10' }, payload: { aps: { sound: 'default' } } },
    });
    sent += res.successCount;
    const dead = [];
    res.responses.forEach((r, j) => {
      if (r.success) return;
      const code = r.error && r.error.code;
      if (DEAD_TOKEN_ERRORS.has(code)) dead.push(batch[j]);
      logger.warn('Push failed', { ...context, code, message: r.error && r.error.message });
    });
    // Forget phones that uninstalled the app or signed out elsewhere.
    await Promise.all(
      dead.map((o) => o.ref.set({ tokens: FieldValue.arrayRemove(o.token) }, { merge: true })),
    );
  }
  logger.info('Pushed', { ...context, phones: owners.length, sent });
  return sent;
}

/**
 * The people `uid` may alert: everyone in a circle with them (members and
 * owners) and their emergency contacts who have an account. Alerts are
 * written by the app, so their `watcherIds` are only trusted within this set.
 */
async function trustedWatchers(db, uid) {
  const [memberOf, owned, contacts] = await Promise.all([
    db.collection('circles').where('memberIds', 'array-contains', uid).get(),
    db.collection('circles').where('ownerId', '==', uid).get(),
    db.collection(`users/${uid}/contacts`).get(),
  ]);
  const ids = new Set();
  for (const c of [...memberOf.docs, ...owned.docs]) {
    for (const id of c.data().memberIds || []) ids.add(id);
    if (c.data().ownerId) ids.add(c.data().ownerId);
  }
  const phones = contacts.docs.map((c) => toE164(c.data().digits, c.data().countryCode)).filter(Boolean);
  const found = await Promise.all(
    phones.map((p) => db.collection('users').where('phoneHash', '==', lookupHash(p)).limit(1).get()),
  );
  for (const q of found) if (!q.empty) ids.add(q.docs[0].id);
  ids.delete(uid);
  return ids;
}

/** The alert's watchers that `fromUid` is really connected to. */
async function alertAudience(db, alert) {
  const trusted = await trustedWatchers(db, alert.fromUid);
  return (alert.watcherIds || []).filter((id) => trusted.has(id));
}

/** Claims `pushes/{key}` so a retried event never pushes twice. */
async function claim(db, key) {
  try {
    await db.collection('pushes').doc(key).create({ at: FieldValue.serverTimestamp() });
    return true;
  } catch (e) {
    return false;
  }
}

/** SOS, silent panic or missed check-in: push everyone watching. */
exports.pushAlert = onDocumentCreated({ document: 'alerts/{alertId}', ...options }, async (event) => {
  const alert = event.data && event.data.data();
  const message = alertPush(alert);
  if (!message || alert.resolved) return;
  const db = getFirestore();
  const { alertId } = event.params;
  if (!(await claim(db, `alert_${alertId}`))) return;
  const watchers = await alertAudience(db, alert);
  const sent = await pushTo(db, watchers, message, { kind: 'alert', alertId }, { alertId, type: alert.type });
  logger.info('Alert pushed', { alertId, type: alert.type, sent });
});

/** An SOS or missed check-in was resolved: tell the same people. */
exports.pushAllClear = onDocumentUpdated({ document: 'alerts/{alertId}', ...options }, async (event) => {
  const before = event.data.before.data();
  const after = event.data.after.data();
  const message = allClearPush(after);
  if (before.resolved || !after.resolved || !message) return;
  const db = getFirestore();
  const { alertId } = event.params;
  if (!(await claim(db, `allclear_${alertId}`))) return;
  const watchers = await alertAudience(db, after);
  await pushTo(db, watchers, message, { kind: 'alert', alertId }, { alertId, allClear: true });
});

/** Everyone who shares a circle with `uid` (members and owners). */
async function circleMates(db, uid) {
  const [memberOf, owned] = await Promise.all([
    db.collection('circles').where('memberIds', 'array-contains', uid).get(),
    db.collection('circles').where('ownerId', '==', uid).get(),
  ]);
  const ids = new Set();
  for (const c of [...memberOf.docs, ...owned.docs]) {
    for (const id of c.data().memberIds || []) ids.add(id);
    if (c.data().ownerId) ids.add(c.data().ownerId);
  }
  ids.delete(uid);
  return ids;
}

/**
 * Someone arrived at or left a place: push the people the app shows it to.
 * The phone writes `viewerIds`, so only those really in a circle with the
 * person are pushed.
 */
exports.pushPlaceEvent = onDocumentCreated({ document: 'activity/{eventId}', ...options }, async (event) => {
  const activity = event.data && event.data.data();
  const message = placePush(activity);
  if (!message || !activity.userId) return;
  // Old events (a phone catching up after being offline) aren't news.
  if (Date.now() - Number(activity.atMillis || 0) > 30 * 60 * 1000) return;
  const db = getFirestore();
  const { eventId } = event.params;
  if (!(await claim(db, `place_${eventId}`))) return;
  const mates = await circleMates(db, activity.userId);
  const viewers = (activity.viewerIds || []).filter((id) => mates.has(id));
  await pushTo(db, viewers, message, { kind: 'place' }, { eventId, type: activity.type });
});

/** A SafeCircle user was invited to a circle. */
exports.pushInvite = onDocumentCreated({ document: 'invites/{inviteId}', ...options }, async (event) => {
  const invite = event.data && event.data.data();
  if (!invite || !invite.toUid || invite.status !== 'pending') return;
  const db = getFirestore();
  // Only real invitations: the sender owns the circle and invited this person.
  const circle = invite.circleId && (await db.doc(`circles/${invite.circleId}`).get());
  const c = circle && circle.exists ? circle.data() : null;
  if (!c || c.ownerId !== invite.fromUid || !(c.invitedUids || []).includes(invite.toUid)) {
    logger.warn('Invite push refused', { inviteId: event.params.inviteId });
    return;
  }
  const { inviteId } = event.params;
  if (!(await claim(db, `invite_${inviteId}`))) return;
  await pushTo(db, [invite.toUid], invitePush(invite), { kind: 'invite', inviteId }, { inviteId });
});
