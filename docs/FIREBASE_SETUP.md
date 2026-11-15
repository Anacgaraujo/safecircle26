# Firebase setup

SafeCircle uses **Firebase Authentication** (email and password) and **Cloud
Firestore**. It needs no Cloud Functions and runs on the free Spark plan.

The three Firebase configuration files are **not** committed to this
repository. Each environment generates its own with the FlutterFire CLI:

| File | Platform |
|---|---|
| `lib/firebase_options.dart` | all (used at start-up) |
| `android/app/google-services.json` | Android |
| `ios/Runner/GoogleService-Info.plist` | iOS |

## 1. Tools

```
npm install -g firebase-tools
dart pub global activate flutterfire_cli
firebase login
```

Flutter 3.47 or newer is required.

## 2. Create the Firebase project

1. In the [Firebase console](https://console.firebase.google.com), create a
   project (Google Analytics is optional).
2. **Authentication → Sign-in method:** enable **Email/Password**.
3. **Firestore Database → Create database:** production mode. Pick a region
   close to your users (for the US, `nam5` or `us-east1`). The region cannot
   be changed later.

## 3. Choose the app identifiers

The Android `applicationId` and the iOS bundle identifier must match the apps
registered in Firebase. Set your own before configuring (the template value
`com.example.safecircle` is rejected by the stores):

- Android: `applicationId` and `namespace` in `android/app/build.gradle`.
- iOS: `PRODUCT_BUNDLE_IDENTIFIER` in `ios/Runner.xcodeproj/project.pbxproj`.

## 4. Generate the configuration

From the project root:

```
flutterfire configure --project=YOUR_PROJECT_ID --platforms=android,ios,web
```

This registers the apps in the project (or reuses them) and writes the three
files listed above. Then point the Firebase CLI at the same project by
editing `.firebaserc`:

```json
{ "projects": { "default": "YOUR_PROJECT_ID" } }
```

## 5. Deploy the security rules and indexes

```
firebase deploy --only firestore:rules,firestore:indexes
```

- `firestore.rules`: who can read and write each collection.
- `firestore.indexes.json`: the composite indexes the app's queries need.
  New indexes take a few minutes to build; queries that depend on them fail
  until they are ready.

Run this again whenever either file changes.

## 6. Web (optional)

Authentication only accepts requests from authorized domains. `localhost` is
allowed by default; add your hosting domain under **Authentication →
Settings → Authorized domains**.

## 7. Run

```
flutter run --dart-define-from-file=config/maps.json
```

See the main [README](../README.md) for the map key (`config/maps.json`).

## Local development with the emulators

The Firebase Local Emulator Suite runs Auth and Firestore on your machine, so
tests never touch real data:

```
firebase emulators:start --only auth,firestore
flutter run --dart-define=USE_EMULATORS=true
```

On the Android emulator also pass `--dart-define=EMULATOR_HOST=10.0.2.2`
(the host machine as seen from the emulator). Test web builds carry an API
key that production rejects, so a stray request can never reach the live
project.

## Data model

| Collection | Contents | Who can read |
|---|---|---|
| `users/{uid}` | name, email/phone lookup hashes, settings | signed-in users |
| `users/{uid}/private/profile` | email, phone | the owner |
| `users/{uid}/private/secrets` | safety and panic PIN hashes | the owner |
| `users/{uid}/contacts/{id}` | emergency contacts | the owner |
| `circles/{id}` | name, owner, members | owner, members, invitees |
| `invites/{id}` | circle invitations by email | sender and recipient |
| `journeys/{id}` | planned journeys and check-ins | owner and watchers |
| `alerts/{id}` | SOS, panic and missed check-in alerts | sender and watchers |
| `status/{uid}` | live position and battery | the member and their circles |
| `places/{id}` | geofences | the circle |
| `trips/{id}` | detected trips | the member and their circles |
| `activity/{id}` | arrivals, departures, low battery | the circle |
