# Flavors, signing and Firebase

Three builds must coexist on one device: `dev`, `staging`, `prod`. Set this up
**before** feature work — retrofitting flavors means changing bundle ids,
Firebase files and signing all at once (APP-03).

| Flavor | Application / bundle id | Config file | Firebase project |
| --- | --- | --- | --- |
| `dev` | `com.sgsaitechnology.app.dev` | `config/dev.json` | `sgsai-dev` |
| `staging` | `com.sgsaitechnology.app.stg` | `config/staging.json` | `sgsai-staging` |
| `prod` | `com.sgsaitechnology.app` | `config/prod.json` | `sgsai-prod` |

Run and build with the flavor **and** its config:

```bash
flutter run --flavor dev --dart-define-from-file=config/dev.json
make run FLAVOR=staging
```

`config/*.json` holds build-time, non-secret values only. Anything compiled into
the binary is readable by anyone who downloads the app. Firebase stays disabled
until native Firebase files are provisioned and `FIREBASE_ENABLED` is set to
`true` for that flavor.

`API_BASE_URL` is the origin of the SGS website whose `/api/v1` the app calls
([ADR-002](https://github.com/sgsai-lab/home/blob/main/docs/adr/0002-firestore-first-data-platform.md)): `https://www.sgsaitechnology.com` in production, the dev
Cloud Run URL of `home` for `dev`/`staging` once provisioned. The committed
`config/*.json` values still point at the retired `api.sgsaitechnology.com` hosts
and are updated in APP-07.

> Android emulators cannot reach `localhost`. For a local backend use
> `http://10.0.2.2:8080` in `config/dev.json` (iOS simulators use `localhost`).

## Android

The Android minimum is API 26 (Android 8.0); the iOS deployment target is 15.0.
The base Android manifest disallows cleartext traffic. Only the `dev` variant
may add a local-development exception; staging and prod remain HTTPS-only.

`android/app/build.gradle.kts`:

```groovy
android {
  flavorDimensions += "environment"
    productFlavors {
    create("dev") {
      dimension = "environment"
      applicationIdSuffix = ".dev"
      resValue("string", "app_name", "SGS AI Dev")
        }
    create("staging") {
      dimension = "environment"
      applicationIdSuffix = ".stg"
      resValue("string", "app_name", "SGS AI Staging")
        }
    create("prod") {
      dimension = "environment"
      resValue("string", "app_name", "SGS AI")
        }
    }
}
```

- Reference `@string/app_name` in `AndroidManifest.xml` instead of a literal label.
- Put each flavor's `google-services.json` in `android/app/src/<flavor>/`. The
  Google Services plugin is applied only when at least one flavor config exists;
  the files are gitignored — fetch them from the Firebase console (APP-04).
- Firebase Authentication is **not** used (ADR-002). For Google Sign-In create
  Android (per flavor SHA-1) and iOS OAuth client IDs in the GCP console and hand
  them to the `home` API as `GOOGLE_CLIENT_IDS`. For Sign in with Apple on
  Android, register an Apple Services ID whose return URL is
  `https://www.sgsaitechnology.com/api/v1/auth/apple/callback`; iOS uses the
  native capability.
- Release signing reads `android/key.properties` (gitignored). CI writes it from
  the `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`,
  `ANDROID_KEY_ALIAS` and `ANDROID_KEY_PASSWORD` environment secrets.
- Enable Play App Signing. Store the upload keystore and its passwords in the
  password manager with a documented recovery path in two places.

## iOS

1. Use the shared `dev`, `staging`, and `prod` schemes in
  `ios/Runner.xcodeproj/xcshareddata/xcschemes/`.
2. Each scheme maps Run/Test/Analyze to `Debug-<flavor>`, Profile to
  `Profile-<flavor>`, and Archive to `Release-<flavor>`.
3. The matching Runner configurations set `PRODUCT_BUNDLE_IDENTIFIER` and
  `APP_DISPLAY_NAME`; all configurations retain the iOS 15 deployment target.
4. Add each flavor's `GoogleService-Info.plist` under
  `ios/Runner/Firebase/<flavor>/`. The shared Xcode project build phase copies
  the matching plist into the app bundle. The plists are gitignored.
5. Signing uses `fastlane match` against a **private** certificates repo, or
   App Store Connect API keys. Never commit `.p12` or `.mobileprovision`.

## Checklist (APP-03 / APP-04)

- [ ] Three flavors install side by side on one phone with distinct names/icons
- [ ] Each build talks to its own API base URL
- [ ] Each build reports to its own Firebase project; a test crash appears in Crashlytics
- [ ] Release builds are signed in CI with no secrets on developer machines

## Remote Config service catalog

Firebase Remote Config key `pwa_services` is a JSON array. Each entry has
`id`, `name`, `description`, `url` (HTTPS only), and optional `icon`. The app
ships with clearly marked sample entries until the real PWA names and URLs are
published. The `dev`, `staging`, and `prod` Firebase projects keep separate values.

Example value (replace these URLs with the registered PWA domains before publishing):

```json
[
  {"id":"workdesk","name":"WorkDesk","description":"Team operations workspace.","url":"https://work.google.com","icon":"work"},
  {"id":"learnhub","name":"LearnHub","description":"Courses and learning resources.","url":"https://learn.google.com","icon":"learn"}
]
```
