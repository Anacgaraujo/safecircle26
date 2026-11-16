// SafeCircle Cloud Functions. See docs/SMS.md for setup.
const { onCall, HttpsError } = require('firebase-functions/v2/https');
const { defineString, defineInt } = require('firebase-functions/params');
const logger = require('firebase-functions/logger');
const { initializeApp } = require('firebase-admin/app');
const { getFirestore, FieldValue } = require('firebase-admin/firestore');

const { recipientsToText, toE164, inviteMessage, resendWaitSeconds } = require('./invite_texts');

initializeApp();

const { TWILIO_SECRETS, sendSms, reserveTexts } = require('./sms');
const emergency = require('./emergency');

exports.textAlert = emergency.textAlert;
exports.textAllClear = emergency.textAllClear;
exports.textNewEmergencyContact = emergency.textNewEmergencyContact;
exports.checkOverdueJourneys = emergency.checkOverdueJourneys;

// Non-secret settings live in functions/.env.
const APP_INVITE_URL = defineString('APP_INVITE_URL', { default: '' });
const DAILY_TEXTS_PER_USER = defineInt('DAILY_TEXTS_PER_USER', { default: 20 });
const DAILY_TEXTS_TOTAL = defineInt('DAILY_TEXTS_TOTAL', { default: 200 });
const RESEND_COOLDOWN_MINUTES = defineInt('RESEND_COOLDOWN_MINUTES', { default: 5 });

/**
 * Texts an invitation to every member of a circle who has a phone number,
 * hasn't joined, and hasn't been texted for this circle before.
 *
 * Called by the app right after it saves a circle: { circleId }.
 * To resend to one person: { circleId, resend: { countryCode, digits } }.
 * A resend ignores the "already texted" record but waits
 * RESEND_COOLDOWN_MINUTES between texts to the same number, and refuses
 * people who already joined.
 * Only the circle's owner may call it. Phone numbers are read from the circle
 * document on the server, never taken from the request. Daily limits per
 * user and for the whole project cap what an abuser could cost you.
 *
 * Returns { sent, failed, skipped, limited, retryAfter } (retryAfter: seconds
 * until a resend is allowed, only when it was refused for being too soon).
 */
exports.sendCircleInviteTexts = onCall(
  {
    secrets: TWILIO_SECRETS,
    maxInstances: 5,
  },
  async (request) => {
    const uid = request.auth && request.auth.uid;
    if (!uid) throw new HttpsError('unauthenticated', 'Sign in first.');

    const circleId = request.data && request.data.circleId;
    if (typeof circleId !== 'string' || !/^[A-Za-z0-9_-]{1,128}$/.test(circleId)) {
      throw new HttpsError('invalid-argument', 'circleId is required.');
    }

    const db = getFirestore();
    const circleRef = db.collection('circles').doc(circleId);
    const circleSnap = await circleRef.get();
    if (!circleSnap.exists) throw new HttpsError('not-found', 'Circle not found.');
    const circle = circleSnap.data();
    if (circle.ownerId !== uid) {
      throw new HttpsError('permission-denied', 'Only the circle owner can send invitations.');
    }

    if (request.data.resend !== undefined) {
      return resendOne({ db, uid, circleId, circleRef, circle, resend: request.data.resend });
    }

    const candidates = recipientsToText(circle);
    if (candidates.length === 0) return { sent: 0, failed: 0, skipped: 0, limited: 0 };

    // One record per phone number per circle, so saving the circle again
    // never texts the same person twice.
    const sentRefs = candidates.map((c) => circleRef.collection('smsInvites').doc(c.phone));
    const sentSnaps = await db.getAll(...sentRefs);
    const pending = candidates.filter((_, i) => !sentSnaps[i].exists);
    const skipped = candidates.length - pending.length;
    if (pending.length === 0) return { sent: 0, failed: 0, skipped, limited: 0 };

    const { sent, failed, limited } = await reserveAndSend({
      db, uid, circleId, circleRef, circle, recipients: pending,
    });
    return { sent, failed, skipped, limited };
  },
);

/** Texts one person again, e.g. when they lost the first text. */
async function resendOne({ db, uid, circleId, circleRef, circle, resend }) {
  const phone = resend && toE164(resend.digits, resend.countryCode);
  const recipient = phone && recipientsToText(circle).find((r) => r.phone === phone);
  if (!recipient) throw new HttpsError('not-found', 'That phone number is not in this circle.');

  if (recipient.email) {
    const joined = await db
      .collection('invites')
      .where('circleId', '==', circleId)
      .where('toEmail', '==', recipient.email)
      .where('status', '==', 'accepted')
      .limit(1)
      .get();
    if (!joined.empty) throw new HttpsError('failed-precondition', 'They already joined this circle.');
  }

  const last = await circleRef.collection('smsInvites').doc(phone).get();
  const lastSent = last.exists && last.data().sentAt;
  const retryAfter = resendWaitSeconds({
    lastSentMs: lastSent ? lastSent.toMillis() : 0,
    nowMs: Date.now(),
    cooldownMinutes: RESEND_COOLDOWN_MINUTES.value(),
  });
  if (retryAfter > 0) return { sent: 0, failed: 0, skipped: 1, limited: 0, retryAfter };

  const result = await reserveAndSend({
    db, uid, circleId, circleRef, circle, recipients: [recipient],
  });
  return { ...result, skipped: 0 };
}

/** Reserves daily quota, then texts as many recipients as it allows. */
async function reserveAndSend({ uid, circleId, circleRef, circle, recipients }) {
  const allowed = await reserveTexts({
    bucket: 'smsQuota',
    uid,
    wanted: recipients.length,
    perUser: DAILY_TEXTS_PER_USER.value(),
    total: DAILY_TEXTS_TOTAL.value(),
  });
  const limited = recipients.length - allowed;
  if (limited > 0) logger.warn('SMS daily limit reached', { uid, circleId, limited });

  let sent = 0;
  let failed = 0;
  for (const r of recipients.slice(0, allowed)) {
    const body = inviteMessage({
      fromName: circle.ownerName,
      circleName: circle.name,
      email: r.email,
      link: APP_INVITE_URL.value(),
    });
    try {
      await sendSms(r.phone, body);
      await circleRef.collection('smsInvites').doc(r.phone).set({
        sentAt: FieldValue.serverTimestamp(),
        byUid: uid,
      });
      sent++;
    } catch (e) {
      failed++;
      logger.error('SMS invite failed', { uid, circleId, error: String(e) });
    }
  }
  return { sent, failed, limited };
}
