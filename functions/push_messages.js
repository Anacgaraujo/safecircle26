// Pure helpers for push notifications: no Firebase, no network, unit-tested.
const { smsSafe } = require('./alert_texts');

const MAX_NAME = 40;

function name(raw) {
  const t = smsSafe(raw);
  if (!t) return 'Someone';
  return t.length > MAX_NAME ? `${t.slice(0, MAX_NAME - 3)}...` : t;
}

function firstName(raw) {
  return name(raw).split(' ')[0];
}

function where(alert) {
  const place = smsSafe(alert.location);
  return place ? ` near ${place}` : '';
}

/** Pushed alerts: the same events that are texted. */
const PUSHED_ALERTS = new Set(['sos', 'panic', 'overdue']);
const ALL_CLEAR_PUSHES = new Set(['sos', 'overdue']);

/** Title and body for an alerts/{id} doc, or null if it isn't pushed. */
function alertPush(alert) {
  if (!alert || !PUSHED_ALERTS.has(alert.type)) return null;
  const who = name(alert.fromName);
  switch (alert.type) {
    case 'panic':
      // Their phone may be in someone else's hands: no calling back.
      return {
        title: 'SafeCircle EMERGENCY',
        body: `${who} entered their silent panic PIN${where(alert)} and may be in danger. Do NOT call or text ${firstName(alert.fromName)}. Tap to see where they are.`,
      };
    case 'overdue': {
      const what = smsSafe(alert.detail) ? ` ("${smsSafe(alert.detail)}")` : '';
      return {
        title: 'SafeCircle: missed check-in',
        body: `${who} missed a check-in${what} and has not confirmed they are OK. Tap to see their last location.`,
      };
    }
    default:
      return {
        title: 'SafeCircle EMERGENCY',
        body: `${who} pressed SOS${where(alert)} and needs help. Tap to see where they are.`,
      };
  }
}

/** Sent when an SOS or missed check-in is resolved (never for panic). */
function allClearPush(alert) {
  if (!alert || !ALL_CLEAR_PUSHES.has(alert.type)) return null;
  const kind = alert.type === 'overdue' ? 'missed check-in' : 'SOS';
  return { title: 'SafeCircle', body: `${name(alert.fromName)}'s ${kind} is resolved. They're OK.` };
}

/** Sent to a SafeCircle user invited to a circle. */
function invitePush(invite) {
  const circle = smsSafe(invite && invite.circleName);
  return {
    title: 'Circle invitation',
    body: circle
      ? `${name(invite.fromName)} invited you to their circle "${circle}". Tap to answer.`
      : `${name(invite && invite.fromName)} invited you to their circle. Tap to answer.`,
  };
}

/** Error codes meaning the token is gone for good and should be forgotten. */
const DEAD_TOKEN_ERRORS = new Set([
  'messaging/registration-token-not-registered',
  'messaging/invalid-registration-token',
]);

module.exports = { alertPush, allClearPush, invitePush, PUSHED_ALERTS, ALL_CLEAR_PUSHES, DEAD_TOKEN_ERRORS };
