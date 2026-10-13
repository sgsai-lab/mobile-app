# Store signing runbook

Signing keys and profiles are not present in this repository. This runbook records
the required controls; it is not evidence that the external account setup is
complete.

## Android

1. Generate a dedicated upload keystore using the team's managed JDK and store
   the keystore plus passwords in the approved password manager:

   ```bash
   keytool -genkeypair -v -keystore upload-keystore.jks -alias upload \
     -keyalg RSA -keysize 2048 -validity 10000
   ```

2. Enable Play App Signing in the Play Console and enroll the application.
3. Give two designated maintainers access to the recovery item in the password
   manager; record the custodians in the team-owned operational system, not Git.
4. Add these secrets to the protected `staging` and `prod` GitHub environments:
   `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`,
   `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`, and
   `FIREBASE_ANDROID_CONFIG_BASE64` for the matching flavor's Firebase project.
5. Verify a release AAB with `jarsigner -verify -verbose -certs` and inspect the
   release mapping file before promotion.

## iOS

1. Register the production and staging bundle IDs with the Apple Developer team.
2. Create an Apple Distribution certificate and App Store provisioning profile
   for each bundle ID. Export the certificate as a password-protected `.p12`.
3. Store recovery material in the approved password manager with two designated
   maintainers; document those custodians in the team-owned operational system.
4. Add environment secrets `IOS_DISTRIBUTION_CERT_BASE64`,
   `IOS_DISTRIBUTION_CERT_PASSWORD`, `IOS_PROVISIONING_PROFILE_BASE64`, and
   `IOS_KEYCHAIN_PASSWORD`, and `IOS_FIREBASE_CONFIG_BASE64`; add
   `APPLE_TEAM_ID` as an environment variable.
5. Dispatch `Release iOS` for staging, verify the signed IPA in TestFlight, then
   repeat for prod. Confirm the app bundle ID and profile before submission.

## Recovery and rotation

- Keep the Android upload key and its recovery material in two approved,
  access-controlled locations. If compromised, follow Play Console's upload-key
  reset process; never replace the Play App Signing key casually.
- Maintain a second authorized Apple account holder who can renew certificates
  and profiles. Revoke and replace compromised certificates, then update the
  protected GitHub environment.
- Rotate CI secrets immediately after certificate replacement and verify the
  cleanup steps still delete temporary runner files and keychains.
- Never attach keystores, `.p12`, `.p8`, `.mobileprovision`, or passwords to an
  issue, PR, build artifact, or repository.

## Completion evidence

Before marking APP-09 complete, attach evidence of successful signed AAB and IPA
CI runs, R8/resource shrinking, an installed artifact from each store pipeline,
and confirmation that two maintainers can recover the keys. Do not store key or
profile contents in that evidence.
