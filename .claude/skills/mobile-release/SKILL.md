---
name: mobile-release
description: "Cut and ship a mobile release: version bump, flavor builds, signing, store upload and rollback. Use when asked to prepare a release, build a store artifact, publish to internal testing, or bump the app version."
argument-hint: "Version, e.g. 0.2.0"
---

# Release the app

## 1. Pre-flight

```bash
git switch develop && git pull --ff-only
make check                      # format + analyze + tests
make integration FLAVOR=staging # on a real device
```

- [ ] All issues in the milestone are merged and verified.
- [ ] No `TODO(security)` or debug flags left; logging is silent in release.
- [ ] `config/prod.json` points at the production API over https.
- [ ] Crashlytics (or the configured reporter) receives a test crash from the staging build.

## 2. Version

`pubspec.yaml` → `version: <major>.<minor>.<patch>+<build>`. The build number **must** increase for every store upload and never repeats. Commit as `chore(release): v<version>`.

## 3. Build

```bash
make build-aab FLAVOR=staging   # internal testing
make build-aab FLAVOR=prod      # production track
make build-ipa FLAVOR=prod
```

CI does this on a `v*` tag through `release-android.yml` / `release-ios.yml` using secrets from a protected environment. Prefer CI builds — local builds are for debugging only.

```bash
git tag -a v<version> -m "v<version>" && git push origin v<version>
```

## 4. Ship

- Android: upload the `.aab` to the **internal** track first, then promote the *same artifact* to closed/open/production. Play App Signing holds the app key.
- iOS: upload to TestFlight, verify on a device, then submit for review.
- Staged rollout for production (start small), with the release notes written for users, not for commits.

## 5. After release

- [ ] Tag the GitHub release with notes generated from conventional commits.
- [ ] Watch crash-free rate and error rate for the first hours.
- [ ] Rollback plan: halt the staged rollout (Android) or remove from sale / expedited fix (iOS). You cannot un-publish a version — always ship a higher build number with the fix.
- [ ] Merge `develop` → `main` if that is the release branch policy, and open follow-up issues for anything deferred.

## Never

- Never rebuild a different binary for a different track — promote the artifact that was tested.
- Never commit keystores, provisioning profiles or `key.properties`.
- Never change the bundle id or lose the upload key: both block all future releases.
