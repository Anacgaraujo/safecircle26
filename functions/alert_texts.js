// Pure helpers for emergency texts: no Firebase, no network, unit-tested.
const { toE164 } = require('./invite_texts');

const MAX_NAME = 40;

/**
 * Replaces characters that are not in the SMS (GSM-7) alphabet. One of them
 * anywhere in a text cuts each billed segment from 160 to 70 characters,
 * and place names here often contain "·".
 */
function smsSafe(text) {
  return String(text || '')
    .replace(/[·•]/g, '-')
    .replace(/[“”]/g, '"')
    .replace(/[‘’]/g, "'")
    .replace(/[–—]/g, '-')
    .replace(/…/g, '...')
    .replace(/\s+/g, ' ')
    .trim();
}

function shortName(name, fallback = 'Someone') {
  const t = smsSafe(name);
  if (!t) return fallback;
  return t.length > MAX_NAME ? `${t.slice(0, MAX_NAME - 3)}...` : t;
}

function firstName(name) {
  return shortName(name).split(' ')[0];
}

/** "Location: Stockton St - Union Square https://maps.google.com/?q=37.78,-122.4" */
function locationLine({ place, lat, lng }, label = 'Location') {
  const where = smsSafe(place);
  const hasPoint = typeof lat === 'number' && typeof lng === 'number';
  const link = hasPoint ? `https://maps.google.com/?q=${lat.toFixed(5)},${lng.toFixed(5)}` : '';
  if (!where && !link) return `${label} unknown.`;
  return `${label}: ${[where, link].filter(Boolean).join(' ')}`;
}

/** The text sent to everyone watching when `alert` (an alerts/{id} doc) is raised. */
function alertMessage(alert) {
  const name = shortName(alert.fromName);
  const first = firstName(alert.fromName);
  const at = smsSafe(alert.timeLabel) ? ` at ${smsSafe(alert.timeLabel)}` : '';
  const phone = smsSafe(alert.fromPhone);
  const loc = locationLine({ place: alert.location, lat: alert.lat, lng: alert.lng });
  switch (alert.type) {
    case 'panic':
      // Their phone may be in someone else's hands: no calling back.
      return [
        `SafeCircle EMERGENCY: ${name} entered their silent panic PIN${at} and may be in danger.`,
        loc,
        `Do NOT call or text ${first} - it could put them at risk.`,
        'If you think they are in danger, call your local emergency number.',
      ].join(' ');
    case 'overdue': {
      const what = smsSafe(alert.detail) ? ` ("${smsSafe(alert.detail)}")` : '';
      return [
        `SafeCircle ALERT: ${name} missed a check-in${what}${at} during a journey and has not confirmed they are OK.`,
        locationLine({ place: alert.location, lat: alert.lat, lng: alert.lng }, 'Last known location'),
        phone ? `Try calling ${first}: ${phone}` : `Try reaching ${first}.`,
      ].join(' ');
    }
    default:
      return [
        `SafeCircle EMERGENCY: ${name} pressed SOS${at} and needs help.`,
        loc,
        phone ? `Call ${first}: ${phone}` : '',
      ]
        .filter(Boolean)
        .join(' ');
  }
}

/** Sent to the same people once the alert is resolved (never for panic). */
function allClearMessage(alert) {
  const name = shortName(alert.fromName);
  const at = smsSafe(alert.timeLabel) ? ` from ${smsSafe(alert.timeLabel)}` : '';
  const kind = alert.type === 'overdue' ? 'missed check-in alert' : 'SOS';
  return `SafeCircle update: ${name}'s ${kind}${at} is resolved.`;
}

function contactAddedMessage({ fromName }) {
  const name = shortName(fromName);
  const first = firstName(fromName);
  return (
    `${name} added you as an emergency contact on SafeCircle. ` +
    `You'll get a text if ${first} sends an SOS or misses a check-in. Reply STOP to opt out.`
  );
}

/** Whether an alert of this type gets texted, and an all-clear when resolved. */
const TEXTED_ALERTS = new Set(['sos', 'panic', 'overdue']);
const ALL_CLEAR_ALERTS = new Set(['sos', 'overdue']);

/**
 * Builds the list of numbers to text from several sources, in priority
 * order. Each source is a list of { digits, countryCode } or { phone } (any
 * format, e.g. "+1 (415) 555-2671"). Skips `exclude` (E.164 numbers, e.g. the
 * sender's own), invalid numbers and duplicates; returns at most `max`.
 */
function collectPhones(sources, { exclude = [], max = Infinity } = {}) {
  const skip = new Set(exclude.filter(Boolean));
  const out = [];
  for (const list of sources) {
    for (const p of list || []) {
      const e164 = p.phone ? toE164(p.phone, p.countryCode) : toE164(p.digits, p.countryCode);
      if (!e164 || skip.has(e164)) continue;
      skip.add(e164);
      out.push(e164);
      if (out.length >= max) return out;
    }
  }
  return out;
}

/**
 * The check-in the server should raise an overdue alert for, or null. Mirrors
 * Journey.missedCheckIn in the app: the first unconfirmed check-in, once its
 * time plus the grace period has passed. Check-ins older than `maxAgeMs` are
 * ignored so abandoned journeys don't alert days later.
 */
function overdueCheckIn(journey, nowMs, { graceMs, maxAgeMs }) {
  if (!journey || journey.status !== 'active') return null;
  const next = (journey.checkIns || []).find((c) => !c.confirmed);
  if (!next || typeof next.atMillis !== 'number') return null;
  if (nowMs <= next.atMillis + graceMs) return null;
  if (nowMs - next.atMillis > maxAgeMs) return null;
  if ((journey.overdueAlerted || []).includes(next.atMillis)) return null;
  return next;
}

module.exports = {
  smsSafe,
  locationLine,
  alertMessage,
  allClearMessage,
  contactAddedMessage,
  collectPhones,
  overdueCheckIn,
  TEXTED_ALERTS,
  ALL_CLEAR_ALERTS,
};
