# Internal distribution setup

The distribution workflow triggers on pushes to `develop` and can also be run
manually. Jobs remain skipped until their repository variables are enabled; this
keeps a fresh clone from failing before Firebase and signing setup is complete.

## GitHub environment

Create a protected GitHub environment named `internal-testing`. Add required
reviewers before enabling release signing secrets.

Repository variables (job-level `if:` conditions run before the environment is
resolved, so these must be set on the repository, not the environment):

| Variable | Value |
| --- | --- |
| `INTERNAL_ANDROID_DISTRIBUTION` | `true` when Android Firebase App Distribution is ready |
| `INTERNAL_IOS_DISTRIBUTION` | `true` when iOS signing and distribution are ready |

Environment variables on `internal-testing`:

| Variable | Value |
| --- | --- |
| `INTERNAL_API_BASE_URL` | `https://` origin of the `home` API the tester build calls (overrides the `localhost` default in `config/dev.json`; currently `https://www.sgsaitechnology.com`) |
| `FIREBASE_ANDROID_APP_ID` | Firebase Android app ID for `com.sgsaitechnology.app.dev` |
| `FIREBASE_IOS_APP_ID` | Firebase iOS app ID for `com.sgsaitechnology.app.dev` |
| `FIREBASE_TESTER_GROUPS` | Comma-separated Firebase tester group aliases |
| `GCP_WIF_PROVIDER` | Full resource name of the Workload Identity provider for this repository (`projects/<number>/locations/global/workloadIdentityPools/github-actions/providers/github-mobile-app`) |
| `GCP_WIF_SERVICE_ACCOUNT` | Service account the job impersonates (`github-app-distribution@<project>.iam.gserviceaccount.com`) |
| `APPLE_TEAM_ID` | Apple Developer team ID |

Environment secrets:

| Secret | Contents |
| --- | --- |
| `FIREBASE_ANDROID_CONFIG_BASE64` | Base64 of the dev Android `google-services.json` |
| `IOS_FIREBASE_CONFIG_BASE64` | Base64 of the dev iOS `GoogleService-Info.plist` |
| `IOS_DISTRIBUTION_CERT_BASE64` | Base64 PKCS#12 distribution certificate |
| `IOS_DISTRIBUTION_CERT_PASSWORD` | PKCS#12 export password |
| `IOS_DEV_PROFILE_BASE64` | Base64 ad-hoc profile for `com.sgsaitechnology.app.dev`, including internal tester devices |
| `IOS_KEYCHAIN_PASSWORD` | One-run temporary keychain password |

Firebase config files and Apple assets are written only to the ephemeral runner,
used by that job, and deleted in an `if: always()` cleanup step. Never commit
these files or paste their contents into issue comments or logs.

## Google Cloud access (keyless)

The organisation policy forbids service-account keys, so the jobs authenticate
with Workload Identity Federation (`google-github-actions/auth`) and the Firebase
CLI picks up the resulting Application Default Credentials. Jobs request
`id-token: write`. The current setup, in GCP project `home-509818` (the project
that also hosts the `home` API and is the Firebase project for the dev build):

- Service account `github-app-distribution` with only `roles/firebaseappdistro.admin`.
- Provider `github-mobile-app` in the existing `github-actions` pool, restricted
  by attribute condition to `sgsai-lab/mobile-app` **and** the GitHub
  environment `internal-testing`. Jobs outside that environment cannot mint a
  token for the service account.
- `roles/iam.workloadIdentityUser` on the service account for
  `principalSet://…/attribute.repository/sgsai-lab/mobile-app`.

To rotate or revoke, delete the provider or the binding; there is no key to
leak.

## App registration

- Register the Android dev application and iOS dev bundle ID
  (`com.sgsaitechnology.app.dev`) in the Firebase project. Until the per-flavor
  `sgsai-*` projects from APP-04 exist, the dev app lives in `home-509818`
  (Android app `1:1017079440680:android:84df7c7424b0402e09dc1d`).
- Enable Firebase App Distribution and create the tester group aliases
  (`internal` exists).
- Grant the service account the minimum App Distribution permissions.
- Keep the downloaded `google-services.json` in `android/app/src/dev/`; it is
  gitignored (`**/google-services.json`) and only needed for local builds.
- Register tester UDIDs with the Apple Developer team and include them in the
  ad-hoc profile; otherwise iOS installs will fail.
- Test each distribution job manually before setting its enablement variable.

The workflow uploads an immutable build artifact and submits that same build to
Firebase. It does not rebuild for different tester groups.

## Hosted API, never localhost

`config/dev.json` points at `http://localhost:8080` for local development. The
distribution jobs pass `--dart-define=API_BASE_URL=$INTERNAL_API_BASE_URL` after
`--dart-define-from-file`, which takes precedence, and fail when the variable is
not an `https://` origin. To build the same binary locally:

```bash
flutter build apk --debug --flavor dev \
  --dart-define-from-file=config/dev.json \
  --dart-define=API_BASE_URL=https://www.sgsaitechnology.com
```

Bump the `+<build>` suffix of `version:` in `pubspec.yaml` before every
distribution; testers are only prompted to update when the build number grows.
