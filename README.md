# SafeCircle

Personal safety and live location sharing for your trusted circle: live map,
planned journeys with scheduled check-ins, a silent panic PIN, SOS, places
(geofences) and trip history. Flutter app for Android, iOS and the web, backed
by Firebase Auth and Cloud Firestore.

## Architecture

Feature-first modules with [Riverpod](https://riverpod.dev) for state and
dependency injection.

```
lib/
  main.dart              bootstrap: Firebase, notifications, background service
  app/                   root widget, auth gate, main shell (tabs)
  core/                  shared code: session, theme, widgets, location,
                         notifications, permissions, formatters
  features/<module>/
    data/                Firestore repositories and their providers
    domain/              models and pure rules (no Flutter, no Firebase)
    application/         services that orchestrate repositories
    presentation/        screens and widgets
```

Modules: `auth`, `circles`, `contacts`, `journeys`, `alerts`, `live_map`,
`places`, `trips`, `activity`, `profile`.

- Screens are `ConsumerWidget`s that watch stream providers (circles, journeys,
  alerts, live status…) and call services for actions, never Firestore
  directly.
- Rules that decide what the user sees (check-in schedule, overdue friends,
  PIN checks, who is on the map, trip totals…) are plain functions in
  `domain/`, covered by unit tests.
- Location sharing and the journey monitor also run in the Android background
  isolate, outside the widget tree; they use the `Repositories` composition
  root in `core/data/repositories.dart`.

## Firebase

The Firebase configuration files are not committed. Follow
[docs/FIREBASE_SETUP.md](docs/FIREBASE_SETUP.md) to create a project and
generate them before the first run.

## Run

```
flutter pub get
flutter run
```

## Text messages

Cloud Functions text circle invitations, new emergency contacts, SOS and
panic alerts, missed journey check-ins and the all-clear, through Twilio.
Setup: [docs/SMS.md](docs/SMS.md).

## Push notifications

The same alerts and circle invitations also arrive as push notifications
(Firebase Cloud Messaging), even when the app is closed.
Setup: [docs/PUSH.md](docs/PUSH.md).

## Map tiles

Maps use MapTiler raster tiles. Copy `config/maps.example.json` to
`config/maps.json` (git-ignored), paste your MapTiler key, and build with it:

```
flutter build apk --release --dart-define-from-file=config/maps.json
```

Without a key the app falls back to the OpenStreetMap tile server, which is
for development only. Any other provider can be set with
`--dart-define=MAP_TILE_URL=...` and `--dart-define=MAP_ATTRIBUTION=...`.

## Test builds (Firebase Local Emulator Suite)

Test builds talk to local emulators and can never reach production (the web
build carries an API key that production rejects).

```
firebase emulators:start --only auth,firestore
flutter build web --dart-define=USE_EMULATORS=true
flutter build apk --dart-define=USE_EMULATORS=true --dart-define=EMULATOR_HOST=10.0.2.2
```

`10.0.2.2` is the host machine as seen from the Android emulator.

## Tests

```
flutter analyze
flutter test
```

Unit and widget tests in `test/` run on an in-memory Firestore
(`fake_cloud_firestore`) with `mocktail` fakes: domain rules, services,
repositories (invites, alert recipients, panic and overdue alerts) and the main
screens with overridden providers. CI runs both commands on every push
(`.github/workflows/ci.yml`).

End-to-end suite (journey, check-ins, panic, SOS, rules, places, trips) against
the emulators:

```
flutter build web -t tool/e2e/e2e_app.dart -o build/web_e2e --dart-define=USE_EMULATORS=true
```

Serve `build/web_e2e` and open it in a browser; the page reports each step.

## Firestore

Security rules live in `firestore.rules` and composite indexes in
`firestore.indexes.json`:

```
firebase deploy --only firestore:rules,firestore:indexes
```
