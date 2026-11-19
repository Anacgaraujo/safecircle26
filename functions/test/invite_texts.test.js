const test = require('node:test');
const assert = require('node:assert/strict');
const {
  hasSmsConsent,
  recipientsToText,
  toE164,
  inviteMessage,
  dayKey,
  allowedCount,
  resendWaitSeconds,
} = require('../invite_texts');

test('formats national numbers as E.164', () => {
  assert.equal(toE164('(415) 555-2671', 'US'), '+14155552671');
  assert.equal(toE164('11 98765-4321', 'BR'), '+5511987654321');
  assert.equal(toE164('', 'US'), null);
  assert.equal(toE164('123', 'US'), null);
});

test('texts consenting members with a phone who have not joined, once per number', () => {
  const ok = { smsConsent: true };
  const circle = {
    memberIds: ['owner', 'joined'],
    members: [
      { name: 'Bia', digits: '4155552671', countryCode: 'US', email: 'Bia@Example.com', ...ok },
      { name: 'Bia again', digits: '415 555 2671', countryCode: 'US', ...ok },
      { name: 'Carlos', digits: '4155550000', countryCode: 'US', uid: 'joined', ...ok },
      { name: 'No consent', digits: '4155551111', countryCode: 'US' },
      { name: 'No phone', digits: '', countryCode: 'US', ...ok },
      { name: 'Bad phone', digits: '12', countryCode: 'US', ...ok },
    ],
  };
  assert.deepEqual(recipientsToText(circle), [
    { phone: '+14155552671', name: 'Bia', email: 'bia@example.com' },
  ]);
});

test('builds the invitation text', () => {
  assert.equal(
    inviteMessage({ fromName: 'Ana', circleName: 'Family', email: 'bia@example.com', link: 'https://x.co/app' }),
    'Ana added you to their SafeCircle circle "Family". Get the app: https://x.co/app and sign up with bia@example.com to join. Reply STOP to opt out.',
  );
  assert.equal(
    inviteMessage({ fromName: '', circleName: '', email: '', link: '' }),
    'Someone added you to their SafeCircle circle. Get the SafeCircle app to join. Reply STOP to opt out.',
  );
});

test('daily limits', () => {
  assert.equal(dayKey(new Date('2026-11-16T23:59:00Z')), '2026-11-16');
  assert.equal(allowedCount({ wanted: 3, userCount: 0, totalCount: 0, perUser: 20, total: 200 }), 3);
  assert.equal(allowedCount({ wanted: 3, userCount: 19, totalCount: 0, perUser: 20, total: 200 }), 1);
  assert.equal(allowedCount({ wanted: 3, userCount: 0, totalCount: 200, perUser: 20, total: 200 }), 0);
  assert.equal(allowedCount({ wanted: 3, userCount: 25, totalCount: 0, perUser: 20, total: 200 }), 0);
});

test('resend cooldown', () => {
  const now = Date.parse('2026-11-16T12:00:00Z');
  assert.equal(resendWaitSeconds({ lastSentMs: 0, nowMs: now, cooldownMinutes: 5 }), 0);
  assert.equal(resendWaitSeconds({ lastSentMs: now - 60_000, nowMs: now, cooldownMinutes: 5 }), 240);
  assert.equal(resendWaitSeconds({ lastSentMs: now - 300_000, nowMs: now, cooldownMinutes: 5 }), 0);
});

test('only an explicit yes counts as texting consent', () => {
  assert.equal(hasSmsConsent({ smsConsent: true }), true);
  assert.equal(hasSmsConsent({ smsConsent: 'true' }), false);
  assert.equal(hasSmsConsent({}), false);
  assert.equal(hasSmsConsent(null), false);
});
