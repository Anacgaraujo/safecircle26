// Emergency texts: SOS, silent panic, missed journey check-ins, the all-clear
// that follows, and the notice a person gets when added as an emergency
// contact. See docs/SMS.md.
const crypto = require('node:crypto');
const { onDocumentCreated, onDocumentUpdated, onDocumentWritten } = require('firebase-functions/v2/firestore');
const { onSchedule } = require('firebase-functions/v2/scheduler');
const { defineInt } = require('firebase-functions/params');
const logger = require('firebase-functions/logger');
const { getFirestore, FieldValue } = require('firebase-admin/firestore');

const { TWILIO_SECRETS, sendSms, reserveTexts } = require('./sms');
const { toE164 } = require('./invite_texts');
const {
  alertMessage,
  allClearMessage,
  contactAddedMessage,
  collectPhones,
  overdueCheckIn,
  TEXTED_ALERTS,
  ALL_CLEAR_ALERTS,
} = require('./alert_texts');

// Emergency texts have their own budget, separate from invitations.
const EMERGENCY_RECIPIENTS_MAX = defineInt('EMERGENCY_RECIPIENTS_MAX', { default: 15 });
const EMERGENCY_TEXTS_PER_USER = defineInt('EMERGENCY_TEXTS_PER_USER', { default: 60 });
const EMERGENCY_TEXTS_TOTAL = defineInt('EMERGENCY_TEXTS_TOTAL', { default: 1000 });
// Shared with invitations: adding contacts is something anyone can repeat.
const DAILY_TEXTS_PER_USER = defineInt('DAILY_TEXTS_PER_USER', { default: 20 });
const DAILY_TEXTS_TOTAL = defineInt('DAILY_TEXTS_TOTAL', { default: 200 });

// Same grace as kCheckInGrace in lib/features/journeys/domain/journey.dart.
const CHECK_IN_GRACE_MS = 5 * 60 * 1000;
const OVERDUE_MAX_AGE_MS = 6 * 60 * 60 * 1000;

const options = { secrets: TWILIO_SECRETS, maxInstances: 10 };

/** Same as lookupHash in lib/core/data/lookup_hash.dart. */
function lookupHash(value) {
  return crypto.createHash('sha256').update(`sc:${value}`).digest('hex');
}

async function profilePhone(db, uid) {
  const snap = await db.doc(`users/${uid}/private/profile`).get();
  return (snap.exists && snap.data().phone) || '';
}

/**
 * Everyone to text when `uid` raises an alert: their emergency contacts
 * first, then the people in their circles, then anyone else watching
 * (`watcherIds`) who has a phone number on their profile.
 */
async function alertRecipients(db, uid, watcherIds) {
  const [contacts, circles, ownPhone] = await Promise.all([
    db.collection(`users/${uid}/contacts`).get(),
    db.collection('circles').where('memberIds', 'array-contains', uid).get(),
    profilePhone(db, uid),
  ]);
  const members = [];
  const ownerIds = new Set();
  for (const c of circles.docs) {
    members.push(...(c.data().members || []));
    if (c.data().ownerId) ownerIds.add(c.data().ownerId);
  }
  const others = [...new Set([...(watcherIds || []), ...ownerIds])].filter((id) => id !== uid);
  const profiles = others.length
    ? await db.getAll(...others.map((id) => db.doc(`users/${id}/private/profile`)))
    : [];
  return collectPhones(
    [
      contacts.docs.map((d) => d.data()),
      members,
      profiles.filter((p) => p.exists && p.data().phone).map((p) => ({ phone: p.data().phone })),
    ],
    { exclude: [toE164(ownPhone)], max: EMERGENCY_RECIPIENTS_MAX.value() },
  );
}

/** Sends `body` to `phones` within the sender's emergency budget. */
async function sendEmergency({ uid, phones, body, context }) {
  const allowed = await reserveTexts({
    bucket: 'smsQuotaEmergency',
    uid,
    wanted: phones.length,
    perUser: EMERGENCY_TEXTS_PER_USER.value(),
    total: EMERGENCY_TEXTS_TOTAL.value(),
  });
  if (allowed < phones.length) {
    logger.warn('Emergency SMS limit reached', { uid, ...context, dropped: phones.length - allowed });
  }
  const sentTo = [];
  for (const phone of phones.slice(0, allowed)) {
    try {
      await sendSms(phone, body);
      sentTo.push(phone);
    } catch (e) {
      logger.error('Emergency SMS failed', { uid, ...context, error: String(e) });
    }
  }
  return sentTo;
}

/** SOS, silent panic or missed check-in: text everyone watching. */
exports.textAlert = onDocumentCreated({ document: 'alerts/{alertId}', ...options }, async (event) => {
  const alert = event.data && event.data.data();
  if (!alert || !TEXTED_ALERTS.has(alert.type) || alert.resolved) return;
  const db = getFirestore();
  const record = db.collection('alertTexts').doc(event.params.alertId);
  try {
    // Claim first: a retried or duplicated event must not text twice.
    await record.create({ fromUid: alert.fromUid, type: alert.type, at: FieldValue.serverTimestamp() });
  } catch (e) {
    return;
  }
  const phones = await alertRecipients(db, alert.fromUid, alert.watcherIds);
  const sentTo = await sendEmergency({
    uid: alert.fromUid,
    phones,
    body: alertMessage(alert),
    context: { alertId: event.params.alertId, type: alert.type },
  });
  await record.update({ sentTo });
  logger.info('Alert texted', { alertId: event.params.alertId, type: alert.type, sent: sentTo.length });
});

/** When an SOS or missed check-in is resolved, tell the same people. */
exports.textAllClear = onDocumentUpdated({ document: 'alerts/{alertId}', ...options }, async (event) => {
  const before = event.data.before.data();
  const after = event.data.after.data();
  if (before.resolved || !after.resolved || !ALL_CLEAR_ALERTS.has(after.type)) return;
  const db = getFirestore();
  const record = db.collection('alertTexts').doc(event.params.alertId);
  const phones = await db.runTransaction(async (tx) => {
    const snap = await tx.get(record);
    if (!snap.exists || snap.data().allClearAt || !(snap.data().sentTo || []).length) return [];
    tx.update(record, { allClearAt: FieldValue.serverTimestamp() });
    return snap.data().sentTo;
  });
  if (!phones.length) return;
  await sendEmergency({
    uid: after.fromUid,
    phones,
    body: allClearMessage(after),
    context: { alertId: event.params.alertId, allClear: true },
  });
});

/** A new emergency contact (or a contact's new number) gets a one-time notice. */
exports.textNewEmergencyContact = onDocumentWritten(
  { document: 'users/{uid}/contacts/{contactId}', ...options },
  async (event) => {
    const after = event.data.after.exists ? event.data.after.data() : null;
    if (!after) return;
    const phone = toE164(after.digits, after.countryCode);
    if (!phone) return;
    const before = event.data.before.exists ? event.data.before.data() : null;
    if (before && toE164(before.digits, before.countryCode) === phone) return;

    const { uid } = event.params;
    const db = getFirestore();
    // Once per person per number, even if they're removed and added again.
    const record = db.collection('contactTexts').doc(`${uid}_${phone}`);
    try {
      await record.create({ at: FieldValue.serverTimestamp() });
    } catch (e) {
      return;
    }
    const allowed = await reserveTexts({
      bucket: 'smsQuota',
      uid,
      wanted: 1,
      perUser: DAILY_TEXTS_PER_USER.value(),
      total: DAILY_TEXTS_TOTAL.value(),
    });
    if (!allowed) {
      await record.delete();
      logger.warn('Contact notice skipped: daily limit', { uid });
      return;
    }
    const user = await db.doc(`users/${uid}`).get();
    try {
      await sendSms(phone, contactAddedMessage({ fromName: user.exists ? user.data().name : '' }));
    } catch (e) {
      await record.delete();
      logger.error('Contact notice failed', { uid, error: String(e) });
    }
  },
);

/** People to show the alert to in the app, like AlertRepository.fireAlert. */
async function watchersOf(db, uid, journeyWatchers) {
  const [circles, contacts] = await Promise.all([
    db.collection('circles').where('memberIds', 'array-contains', uid).get(),
    db.collection(`users/${uid}/contacts`).get(),
  ]);
  const ids = new Set(journeyWatchers || []);
  for (const c of circles.docs) for (const id of c.data().memberIds || []) ids.add(id);
  for (const c of contacts.docs) {
    const phone = toE164(c.data().digits, c.data().countryCode);
    if (!phone) continue;
    const q = await db.collection('users').where('phoneHash', '==', lookupHash(phone)).limit(1).get();
    if (!q.empty) ids.add(q.docs[0].id);
  }
  ids.delete(uid);
  return [...ids];
}

/**
 * Every minute: raise the alert for journeys whose traveler missed a
 * check-in. The traveler's phone does this too while the app runs, but the
 * server must not depend on it: a dead or lost phone is the case that
 * matters. Both claim the check-in through `overdueAlerted`, so only one
 * alert is raised; the new alert then triggers textAlert.
 */
exports.checkOverdueJourneys = onSchedule({ schedule: 'every 1 minutes', maxInstances: 1 }, async () => {
  const db = getFirestore();
  const now = Date.now();
  const active = await db.collection('journeys').where('status', '==', 'active').get();
  for (const doc of active.docs) {
    const missed = overdueCheckIn(doc.data(), now, { graceMs: CHECK_IN_GRACE_MS, maxAgeMs: OVERDUE_MAX_AGE_MS });
    if (!missed) continue;
    try {
      const claimed = await db.runTransaction(async (tx) => {
        const fresh = await tx.get(doc.ref);
        const j = fresh.data();
        if (!overdueCheckIn(j, now, { graceMs: CHECK_IN_GRACE_MS, maxAgeMs: OVERDUE_MAX_AGE_MS })) return null;
        tx.update(doc.ref, { overdueAlerted: FieldValue.arrayUnion(missed.atMillis) });
        return j;
      });
      if (!claimed) continue;
      await db.collection('alerts').add({
        fromUid: claimed.ownerId,
        fromName: claimed.ownerName || '',
        fromPhone: claimed.ownerPhone || '',
        type: 'overdue',
        detail: missed.label || '',
        watcherIds: await watchersOf(db, claimed.ownerId, claimed.watcherIds),
        location: claimed.lastPlace || '',
        ...(typeof claimed.lastLat === 'number' && typeof claimed.lastLng === 'number'
          ? { lat: claimed.lastLat, lng: claimed.lastLng }
          : {}),
        resolved: false,
        timeLabel: missed.time || '',
        raisedBy: 'server',
        createdAt: FieldValue.serverTimestamp(),
      });
      logger.info('Overdue alert raised', { journeyId: doc.id });
    } catch (e) {
      logger.error('Overdue check failed', { journeyId: doc.id, error: String(e) });
    }
  }
});
