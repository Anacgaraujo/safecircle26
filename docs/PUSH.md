# Push notifications

Push notifications reach people even when SafeCircle is closed. They are sent
by Cloud Functions in `functions/push.js`, through Firebase Cloud Messaging
(FCM), next to the text messages in [SMS.md](SMS.md).

| When | Who gets the push | Function | Tapping opens |
|---|---|---|---|
| **SOS** is pressed | Watchers in the sender's circles and contacts | `pushAlert` | The alert |
| The **panic PIN** is entered | Same people; says not to call back | `pushAlert` | The alert |
| A journey check-in is missed | Same people | `pushAlert` | The alert |
| An SOS or missed check-in is resolved | Same people | `pushAllClear` | The alert |
| Someone with an account is invited to a circle | That person | `pushInvite` | Circles tab |

## How it works

- **The app** (`lib/core/notifications/push_service.dart`) asks for permission
  after sign-in and saves the phone's token in `users/{uid}/private/push`
  (`tokens`). Signing out removes it; deleting the account deletes the doc.
- **While the app is open** its own listeners already show these
  notifications, so pushes are not shown on top (iOS foreground presentation
  is off; Android doesn't show FCM notifications in the foreground).
- **Recipients are checked on the server**: an alert's `watcherIds` only
  count if they share a circle with the sender or are their emergency contact
  with an account. Invitation pushes need the sender to own the circle and
  the person to be in its `invitedUids`.
- Each push is sent once (`pushes/{key}`, server-only), and tokens of
  uninstalled apps are removed when FCM reports them dead.

## Setup (done once)

- **Apple:** an APNs key (.p8) with Sandbox & Production, uploaded in the
  Firebase console under Project settings → Cloud Messaging for
  `org.SafeCircle` (both slots).
- **iOS project:** `ios/Runner/Runner.entitlements` (`aps-environment`) and
  the `remote-notification` background mode in `Info.plist`. Xcode switches
  the entitlement to production when archiving for the App Store.
- **Android:** nothing to upload. Pushes use the `safecircle_alerts` channel
  and the `ic_stat_safecircle` icon (`AndroidManifest.xml`).

## Testing

Push notifications don't arrive in the iOS Simulator reliably: test on a real
iPhone (Xcode run or TestFlight) and an Android phone or emulator with Google
Play. Sign in on two phones, put both in the same circle, close the app on
one, and press SOS on the other.
