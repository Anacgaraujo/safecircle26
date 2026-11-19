// Pure helpers for SMS invitations: no Firebase, no network, unit-tested.
const { parsePhoneNumberFromString } = require('libphonenumber-js');

const DEFAULT_COUNTRY = 'US';
const MAX_NAME = 40;

/// True when the person agreed to get texts at their number (the app's
/// consent checkbox). Carrier A2P rules: never text anyone without it.
function hasSmsConsent(person) {
  return Boolean(person && person.smsConsent === true);
}

/// The circle members who should get a text: they agreed to texts, have a
/// valid phone number and haven't joined yet. Returns [{ phone (E.164), name, email }], one per
/// phone number.
function recipientsToText(circle) {
  const joined = new Set(circle.memberIds || []);
  const seen = new Set();
  const out = [];
  for (const m of circle.members || []) {
    if (m.uid && joined.has(m.uid)) continue;
    if (!hasSmsConsent(m)) continue;
    const phone = toE164(m.digits, m.countryCode);
    if (!phone || seen.has(phone)) continue;
    seen.add(phone);
    out.push({ phone, name: m.name || '', email: (m.email || '').trim().toLowerCase() });
  }
  return out;
}

function toE164(digits, countryCode) {
  const raw = String(digits || '').trim();
  if (!raw) return null;
  const parsed = parsePhoneNumberFromString(raw, (countryCode || DEFAULT_COUNTRY).toUpperCase());
  return parsed && parsed.isValid() ? parsed.number : null;
}

function clip(text) {
  const t = String(text || '').trim().replace(/\s+/g, ' ');
  return t.length > MAX_NAME ? `${t.slice(0, MAX_NAME - 1)}…` : t;
}

function inviteMessage({ fromName, circleName, email, link }) {
  const from = clip(fromName) || 'Someone';
  const circle = clip(circleName);
  const parts = [
    circle
      ? `${from} added you to their SafeCircle circle "${circle}".`
      : `${from} added you to their SafeCircle circle.`,
    link ? `Get the app: ${link}` : 'Get the SafeCircle app',
    email ? `and sign up with ${email} to join.` : 'to join.',
    'Reply STOP to opt out.',
  ];
  return parts.join(' ');
}

/// UTC day, so daily limits reset at the same moment for everyone.
function dayKey(date) {
  return date.toISOString().slice(0, 10);
}

/// How many of `wanted` texts fit under both daily limits.
function allowedCount({ wanted, userCount, totalCount, perUser, total }) {
  return Math.max(0, Math.min(wanted, perUser - userCount, total - totalCount));
}

/// Seconds left before a number may be texted again (0 = go ahead).
function resendWaitSeconds({ lastSentMs, nowMs, cooldownMinutes }) {
  if (!lastSentMs) return 0;
  const left = lastSentMs + cooldownMinutes * 60 * 1000 - nowMs;
  return left > 0 ? Math.ceil(left / 1000) : 0;
}

module.exports = { hasSmsConsent, recipientsToText, toE164, inviteMessage, dayKey, allowedCount, resendWaitSeconds };
