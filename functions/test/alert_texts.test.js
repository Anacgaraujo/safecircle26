const test = require('node:test');
const assert = require('node:assert/strict');
const {
  smsSafe,
  alertMessage,
  allClearMessage,
  contactAddedMessage,
  collectPhones,
  overdueCheckIn,
} = require('../alert_texts');

const base = {
  fromName: 'Ana Friedland',
  fromPhone: '+1 415 555 2671',
  timeLabel: '11:05 AM',
  location: 'Stockton St · Union Square',
  lat: 37.787994,
  lng: -122.407437,
};

test('SOS text has who, when, where and how to call', () => {
  assert.equal(
    alertMessage({ ...base, type: 'sos' }),
    'SafeCircle EMERGENCY: Ana Friedland pressed SOS at 11:05 AM and needs help. ' +
      'Location: Stockton St - Union Square https://maps.google.com/?q=37.78799,-122.40744 ' +
      'Call Ana: +1 415 555 2671',
  );
});

test('panic text tells people not to call back', () => {
  const text = alertMessage({ ...base, type: 'panic' });
  assert.match(text, /silent panic PIN at 11:05 AM/);
  assert.match(text, /Do NOT call or text Ana/);
  assert.doesNotMatch(text, /\+1 415/);
});

test('missed check-in text names the check-in and last known location', () => {
  assert.equal(
    alertMessage({ ...base, type: 'overdue', detail: 'Arrive at work', lat: undefined, lng: undefined }),
    'SafeCircle ALERT: Ana Friedland missed a check-in ("Arrive at work") at 11:05 AM during a journey ' +
      'and has not confirmed they are OK. Last known location: Stockton St - Union Square ' +
      'Try calling Ana: +1 415 555 2671',
  );
});

test('texts work with missing details', () => {
  assert.equal(
    alertMessage({ type: 'sos' }),
    'SafeCircle EMERGENCY: Someone pressed SOS and needs help. Location unknown.',
  );
  assert.equal(allClearMessage({ ...base, type: 'sos' }), "SafeCircle update: Ana Friedland's SOS from 11:05 AM is resolved.");
  assert.equal(
    allClearMessage({ ...base, type: 'overdue' }),
    "SafeCircle update: Ana Friedland's missed check-in alert from 11:05 AM is resolved.",
  );
  assert.equal(
    contactAddedMessage({ fromName: 'Ana Friedland' }),
    "Ana Friedland added you as an emergency contact on SafeCircle. You'll get a text if Ana sends an SOS " +
      'or misses a check-in. Reply STOP to opt out.',
  );
});

test('texts stay in the plain SMS alphabet', () => {
  assert.equal(smsSafe('“Home” · Work — now…'), '"Home" - Work - now...');
});

test('collects each phone once, in priority order, skipping the sender', () => {
  const phones = collectPhones(
    [
      [{ digits: '4155552671', countryCode: 'US' }, { digits: '12', countryCode: 'US' }],
      [{ digits: '(415) 555-2671', countryCode: 'US' }, { digits: '11 98765-4321', countryCode: 'BR' }],
      [{ phone: '+1 (415) 555-0000' }, { phone: '+1 415 555 9999' }],
    ],
    { exclude: ['+14155550000'], max: 3 },
  );
  assert.deepEqual(phones, ['+14155552671', '+5511987654321', '+14155559999']);
});

test('finds the missed check-in the server should alert on', () => {
  const now = Date.parse('2026-11-16T12:00:00Z');
  const min = 60 * 1000;
  const opts = { graceMs: 5 * min, maxAgeMs: 6 * 60 * min };
  const journey = (checkIns, extra = {}) => ({ status: 'active', checkIns, ...extra });
  const late = { label: 'Arrive', atMillis: now - 6 * min, confirmed: false };

  assert.equal(overdueCheckIn(journey([late]), now, opts), late);
  assert.equal(overdueCheckIn(journey([{ ...late, atMillis: now - 4 * min }]), now, opts), null);
  assert.equal(overdueCheckIn(journey([{ ...late, confirmed: true }]), now, opts), null);
  assert.equal(overdueCheckIn(journey([late], { status: 'finished' }), now, opts), null);
  assert.equal(overdueCheckIn(journey([late], { overdueAlerted: [late.atMillis] }), now, opts), null);
  assert.equal(overdueCheckIn(journey([{ ...late, atMillis: now - 7 * 60 * min }]), now, opts), null);
  const confirmedFirst = { label: 'Leave', atMillis: now - 60 * min, confirmed: true };
  assert.equal(overdueCheckIn(journey([confirmedFirst, late]), now, opts), late);
});
