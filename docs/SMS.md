# Text messages (Twilio)

SafeCircle sends texts from Cloud Functions in `functions/`, through Twilio.
Nothing is sent from the phone itself, so the texts still go out when the
traveler's phone is dead, off or out of signal.

| When | Who gets the text | Function |
|---|---|---|
| A circle is saved | Each new participant with a phone number | `sendCircleInviteTexts` |
| The owner taps **Resend invitation** | That participant | `sendCircleInviteTexts` |
| Someone is added as an emergency contact | That contact (once per number) | `textNewEmergencyContact` |
| **SOS** is pressed | Emergency contacts, circle participants, watchers | `textAlert` |
| The **panic PIN** is entered | Same people; the text says not to call back | `textAlert` |
| A journey check-in is missed (5 min grace) | Same people | `checkOverdueJourneys` raises the alert, `textAlert` texts it |
| An SOS or missed check-in is resolved | The people who got the alert | `textAllClear` |

Examples:

> SafeCircle EMERGENCY: Ana Friedland pressed SOS at 11:05 AM and needs help.
> Location: Stockton St - Union Square https://maps.google.com/?q=37.78799,-122.40744
> Call Ana: +1 415 555 2671

> SafeCircle ALERT: Ana Friedland missed a check-in ("Arrive at work") at
> 3:00 PM during a journey and has not confirmed they are OK. Last known
> location: ... Try calling Ana: +1 415 555 2671

> Ana added you to their SafeCircle circle "Family". Get the app: <link> and
> sign up with bia@example.com to join. Reply STOP to opt out.

How people opt in (carrier A2P rules):

- Circle participants and emergency contacts are texted only when the user
  ticked **"They agreed to get SafeCircle texts at this number"** under their
  phone number (`smsConsent: true`, unticked by default). The servers skip
  every number without it, including older records saved before the box
  existed; edit the person and tick the box to start texting them.
- Users' own profile numbers count as consent: the profile form says adding
  the number means agreeing to safety-alert texts.
- The public pages Twilio reviewers check live in `site/` (Firebase Hosting):
  `/privacy`, `/terms` and `/sms`, which shows the opt-in flow and sample texts.
  Deploy them with `firebase deploy --only hosting`.

How it stays safe and cheap:

- Phone numbers are always read on the server (circles, contacts, profiles),
  never taken from the app's request.
- Only a circle's owner can send its invitations. Each number is texted once
  per circle; a resend waits `RESEND_COOLDOWN_MINUTES` and stops once the
  person joins.
- Each alert is texted once, even if the event is delivered twice
  (`alertTexts/{alertId}`), to at most `EMERGENCY_RECIPIENTS_MAX` people.
- Missed check-ins: `checkOverdueJourneys` runs every minute. The app raises
  the same alert while it is open; both claim the check-in on the journey, so
  only one alert (and one round of texts) goes out. Check-ins missed more
  than 6 hours ago are ignored, so old abandoned journeys never alert.
- No all-clear for the panic PIN: whoever has the phone could be the danger.
- Daily limits (UTC), with separate budgets so invitations can never use up
  emergency texts: invitations and contact notices share
  `DAILY_TEXTS_PER_USER` / `DAILY_TEXTS_TOTAL` (`smsQuota/*`); emergencies use
  `EMERGENCY_TEXTS_PER_USER` / `EMERGENCY_TEXTS_TOTAL` (`smsQuotaEmergency/*`).
- Server-only records (`smsQuota`, `smsQuotaEmergency`, `alertTexts`,
  `contactTexts`, `circles/*/smsInvites`) have no Firestore rule, so apps
  can't read or change them.
- Texting is best effort on top of the in-app alerts and invitations. Until
  the functions are deployed, the app works as before and sends no texts.

## 1. Upgrade Firebase to Blaze

Cloud Functions need the pay-as-you-go **Blaze** plan. In the Firebase
console, open **Usage and billing → Details & settings → Modify plan** and add
a card. Then, in Google Cloud **Billing → Budgets & alerts**, create a budget
(for example $5) so you're warned before any surprise.

## 2. Twilio

1. Create an account at twilio.com and verify your email and phone.
2. **Phone Numbers → Buy a number** (with SMS capability).
3. US numbers must be registered before carriers deliver app texts:
   **Messaging → Regulatory Compliance → A2P 10DLC** (brand + campaign).
   Pick the **Mixed** use case and describe all the messages: invitations,
   emergency-contact notices, and safety alerts (SOS, missed check-in,
   all-clear). Paste the examples above as sample messages. Carriers block
   texts that don't match the registered campaign. Approval takes days to weeks and has one-time
   fees. Toll-free numbers need **Toll-free verification** instead.
4. On a trial account, Twilio only texts numbers you've verified under
   **Phone Numbers → Verified Caller IDs**, and prefixes every message.
5. Copy the **Account SID** and **Auth Token** from the Twilio console.

## 3. Store the Twilio keys as secrets

From the project root (each command asks for the value; nothing is saved in
the repository):

```
firebase functions:secrets:set TWILIO_ACCOUNT_SID
firebase functions:secrets:set TWILIO_AUTH_TOKEN
firebase functions:secrets:set TWILIO_FROM_NUMBER
```

`TWILIO_FROM_NUMBER` is the number you bought, in E.164 form, e.g.
`+14155550123`.

## 4. Settings

Edit `functions/.env`:

- `APP_INVITE_URL`: link included in the text (App Store, Play Store or
  website). Leave empty until you have one.
- `DAILY_TEXTS_PER_USER`, `DAILY_TEXTS_TOTAL`: daily limits for invitations
  and emergency-contact notices.
- `EMERGENCY_RECIPIENTS_MAX`, `EMERGENCY_TEXTS_PER_USER`,
  `EMERGENCY_TEXTS_TOTAL`: the limits for emergency texts.
- `RESEND_COOLDOWN_MINUTES`: minimum wait before "Resend invitation" can
  text the same number again (default 5).

## 5. Deploy

```
cd functions && npm install && cd ..
firebase deploy --only functions
```

The first deploy enables the Cloud Functions, Cloud Build, Artifact Registry,
Eventarc, Cloud Scheduler and Secret Manager APIs, which takes a few minutes.
If it stops asking you to retry because Eventarc permissions are still
propagating, wait a minute and run it again.

## 6. Test

Create a circle in the app and add a participant with your own phone number.
You should get the text within seconds, and the app shows "Text invitation
sent to 1 person."

To test again without making a new circle, open the circle and tap the send
icon next to the participant (**Resend invitation**). It texts them again,
at most once every `RESEND_COOLDOWN_MINUTES`, and only while they haven't
joined. Resends count toward the daily limits.

Emergency texts (use your own number, and warn the people in your circle
first, because they get real alerts):

1. **Emergency contact:** add yourself under **Emergency** → contacts with a
   second phone, or a friend who agreed to help. They get one notice.
2. **SOS:** hold the SOS button. Everyone gets the emergency text; tap
   **Cancel alert — I'm safe** and they get the all-clear.
3. **Missed check-in:** start a journey with a check-in 1 minute away and
   don't confirm it. About 6 minutes later the alert goes out, even if you
   force-quit the app. Confirm the check-in to send the all-clear.

If nothing arrives:

```
firebase functions:log
```

and check **Monitor → Logs → Messaging** in Twilio (error 30034 means the
number isn't registered for A2P 10DLC yet).

## Tests

```
cd functions && npm test
```
