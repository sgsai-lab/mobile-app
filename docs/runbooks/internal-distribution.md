# Internal distribution setup

The distribution workflow triggers on pushes to `develop` and can also be run
manually. Jobs remain skipped until their repository variables are enabled; this
keeps a fresh clone from failing before Firebase and signing setup is complete.

## GitHub environment

Create a protected GitHub environment named `internal-testing`. Add required
reviewers before enabling release signing secrets.

Repository/environment variables:

| Variable | Value |
| --- | --- |
| `INTERNAL_ANDROID_DISTRIBUTION` | `true` when Android Firebase App Distribution is ready |
| `INTERNAL_IOS_DISTRIBUTION` | `true` when iOS signing and distribution are ready |
| `FIREBASE_ANDROID_APP_ID` | Firebase Android app ID for `com.sgsaitechnology.app.dev` |
| `FIREBASE_IOS_APP_ID` | Firebase iOS app ID for `com.sgsaitechnology.app.dev` |
| `FIREBASE_TESTER_GROUPS` | Comma-separated Firebase tester group aliases |
| `APPLE_TEAM_ID` | Apple Developer team ID |

Environment secrets:

| Secret | Contents |
| --- | --- |
| `FIREBASE_SERVICE_ACCOUNT_JSON` | Service account JSON with Firebase App Distribution access for the environment's Firebase project |
| `FIREBASE_ANDROID_CONFIG_BASE64` | Base64 of the `sgsai-dev` Android `google-services.json` |
| `IOS_FIREBASE_CONFIG_BASE64` | Base64 of the `sgsai-dev` iOS `GoogleService-Info.plist` |
| `IOS_DISTRIBUTION_CERT_BASE64` | Base64 PKCS#12 distribution certificate |
| `IOS_DISTRIBUTION_CERT_PASSWORD` | PKCS#12 export password |
| `IOS_DEV_PROFILE_BASE64` | Base64 ad-hoc profile for `com.sgsaitechnology.app.dev`, including internal tester devices |
| `IOS_KEYCHAIN_PASSWORD` | One-run temporary keychain password |

The JSON credential and Apple assets are written only to the ephemeral runner,
used by that job, and deleted in an `if: always()` cleanup step. Never commit
these files or paste their contents into issue comments or logs.

## App registration

- Register the Android dev application and iOS dev bundle ID
  (`com.sgsaitechnology.app.dev`) in the `sgsai-dev` Firebase project.
- Enable Firebase App Distribution and create the tester group aliases.
- Grant the service account the minimum App Distribution permissions.
- Register tester UDIDs with the Apple Developer team and include them in the
  ad-hoc profile; otherwise iOS installs will fail.
- Test each distribution job manually before setting its enablement variable.

The workflow uploads an immutable build artifact and submits that same build to
Firebase. It does not rebuild for different tester groups.
