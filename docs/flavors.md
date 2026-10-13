# Flavors, signing and Firebase

Three builds must coexist on one device: `dev`, `staging`, `prod`. Set this up
**before** feature work — retrofitting flavors means changing bundle ids,
Firebase files and signing all at once (APP-03).

| Flavor | Application / bundle id | Config file | Firebase project |
| --- | --- | --- | --- |
| `dev` | `com.sgsai.app.dev` | `config/dev.json` | `sgsai-dev` |
| `staging` | `com.sgsai.app.stg` | `config/staging.json` | `sgsai-staging` |
| `prod` | `com.sgsai.app` | `config/prod.json` | `sgsai-prod` |

Run and build with the flavor **and** its config:

```bash
flutter run --flavor dev --dart-define-from-file=config/dev.json
make run FLAVOR=staging
```

`config/*.json` holds build-time, non-secret values only. Anything compiled into
the binary is readable by anyone who downloads the app.

> Android emulators cannot reach `localhost`. For a local backend use
> `http://10.0.2.2:8080` in `config/dev.json` (iOS simulators use `localhost`).

## Android

`android/app/build.gradle`:

```groovy
android {
    flavorDimensions "env"
    productFlavors {
        dev {
            dimension "env"
            applicationIdSuffix ".dev"
            resValue "string", "app_name", "SGS AI Dev"
        }
        staging {
            dimension "env"
            applicationIdSuffix ".stg"
            resValue "string", "app_name", "SGS AI Staging"
        }
        prod {
            dimension "env"
            resValue "string", "app_name", "SGS AI"
        }
    }
}
```

- Reference `@string/app_name` in `AndroidManifest.xml` instead of a literal label.
- Put each flavor's `google-services.json` in `android/app/src/<flavor>/`. These
  files are gitignored — fetch them from the Firebase console (APP-04).
- Release signing reads `android/key.properties` (gitignored). CI writes it from
  the `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`,
  `ANDROID_KEY_ALIAS` and `ANDROID_KEY_PASSWORD` environment secrets.
- Enable Play App Signing. Store the upload keystore and its passwords in the
  password manager with a documented recovery path in two places.

## iOS

1. Xcode → duplicate the `Runner` scheme into `dev`, `staging`, `prod`.
2. Add one `.xcconfig` per flavor setting `PRODUCT_BUNDLE_IDENTIFIER` and
   `PRODUCT_NAME`; attach them to the matching build configurations.
3. Add each flavor's `GoogleService-Info.plist` under
   `ios/Runner/Firebase/<flavor>/` and copy the right one in a build phase.
   The plists are gitignored.
4. Signing uses `fastlane match` against a **private** certificates repo, or
   App Store Connect API keys. Never commit `.p12` or `.mobileprovision`.

## Checklist (APP-03 / APP-04)

- [ ] Three flavors install side by side on one phone with distinct names/icons
- [ ] Each build talks to its own API base URL
- [ ] Each build reports to its own Firebase project; a test crash appears in Crashlytics
- [ ] Release builds are signed in CI with no secrets on developer machines
