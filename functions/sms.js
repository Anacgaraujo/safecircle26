// Twilio sending and daily cost guards, shared by every function that texts.
const { defineSecret } = require('firebase-functions/params');
const { getFirestore } = require('firebase-admin/firestore');

const { dayKey, allowedCount } = require('./invite_texts');

const TWILIO_ACCOUNT_SID = defineSecret('TWILIO_ACCOUNT_SID');
const TWILIO_AUTH_TOKEN = defineSecret('TWILIO_AUTH_TOKEN');
const TWILIO_FROM_NUMBER = defineSecret('TWILIO_FROM_NUMBER');

/** Every function that sends texts must list these in its options. */
const TWILIO_SECRETS = [TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, TWILIO_FROM_NUMBER];

async function sendSms(to, body) {
  const sid = TWILIO_ACCOUNT_SID.value();
  const auth = Buffer.from(`${sid}:${TWILIO_AUTH_TOKEN.value()}`).toString('base64');
  const res = await fetch(`https://api.twilio.com/2010-04-01/Accounts/${sid}/Messages.json`, {
    method: 'POST',
    headers: {
      Authorization: `Basic ${auth}`,
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: new URLSearchParams({ To: to, From: TWILIO_FROM_NUMBER.value(), Body: body }),
  });
  if (!res.ok) throw new Error(`Twilio ${res.status}: ${await res.text()}`);
}

/**
 * Reserves up to `wanted` texts for `uid` today under both daily limits and
 * returns how many may be sent. Counters live in the server-only collection
 * `bucket` (one doc per user plus `_total`), so each kind of text has its own
 * budget: invitations can never use up the budget for emergencies.
 */
async function reserveTexts({ bucket, uid, wanted, perUser, total }) {
  if (wanted <= 0) return 0;
  const db = getFirestore();
  const today = dayKey(new Date());
  const userRef = db.collection(bucket).doc(uid);
  const totalRef = db.collection(bucket).doc('_total');
  return db.runTransaction(async (tx) => {
    const [u, t] = await tx.getAll(userRef, totalRef);
    const countOf = (s) => (s.exists && s.data().day === today ? s.data().count || 0 : 0);
    const userCount = countOf(u);
    const totalCount = countOf(t);
    const n = allowedCount({ wanted, userCount, totalCount, perUser, total });
    if (n > 0) {
      tx.set(userRef, { day: today, count: userCount + n });
      tx.set(totalRef, { day: today, count: totalCount + n });
    }
    return n;
  });
}

module.exports = { TWILIO_SECRETS, sendSms, reserveTexts };
