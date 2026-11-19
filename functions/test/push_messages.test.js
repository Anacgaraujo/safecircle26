const test = require('node:test');
const assert = require('node:assert/strict');
const { alertPush, allClearPush, invitePush } = require('../push_messages');

const ana = { fromName: 'Ana Souza', location: 'Union Square' };

test('SOS and missed check-in pushes', () => {
  assert.deepEqual(alertPush({ ...ana, type: 'sos' }), {
    title: 'SafeCircle EMERGENCY',
    body: 'Ana Souza pressed SOS near Union Square and needs help. Tap to see where they are.',
  });
  assert.equal(
    alertPush({ ...ana, type: 'overdue', detail: 'Arrive at work' }).body,
    'Ana Souza missed a check-in ("Arrive at work") and has not confirmed they are OK. Tap to see their last location.',
  );
});

test('the panic push says not to call back', () => {
  const p = alertPush({ ...ana, type: 'panic' });
  assert.match(p.body, /silent panic PIN/);
  assert.match(p.body, /Do NOT call or text Ana\./);
});

test('other alert types are not pushed', () => {
  assert.equal(alertPush({ ...ana, type: 'checkin' }), null);
  assert.equal(alertPush(null), null);
});

test('all-clear only for SOS and missed check-ins', () => {
  assert.equal(allClearPush({ ...ana, type: 'sos' }).body, "Ana Souza's SOS is resolved. They're OK.");
  assert.equal(allClearPush({ ...ana, type: 'panic' }), null);
});

test('invitation push', () => {
  assert.equal(
    invitePush({ fromName: 'Ana Souza', circleName: 'Family' }).body,
    'Ana Souza invited you to their circle "Family". Tap to answer.',
  );
  assert.equal(invitePush({}).body, 'Someone invited you to their circle. Tap to answer.');
});
