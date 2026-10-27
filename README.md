# mobile-app

SGS AI Technology — Flutter app for Android and iOS: the hub through which a
client's staff open the business and education services SGS built for them.
Backed by the SGS website API (`/api/v1` in [home](https://github.com/sgsai-lab/home)) per
[ADR-002](https://github.com/sgsai-lab/home/blob/main/docs/adr/0002-firestore-first-data-platform.md).

| | |
| --- | --- |
| Stack | Flutter 3.47 · Dart 3.13 · Riverpod · go_router · Dio · flutter_secure_storage · Firebase Crashlytics |
| Flavors | `dev`, `staging`, `prod` — distinct bundle ids and Firebase projects |
| Auth | SGS API sessions issued by `home` (`/api/v1/auth/*`): email/password with two-factor codes (Google/Apple token exchange ready in `AuthRepository`); tokens in Keychain/Keystore; `X-Client: mobile`; no Firebase Auth |
| Agents | [AGENTS.md](AGENTS.md) is the single source of truth for AI coding agents |

## Prerequisites

```bash
brew install --cask flutter
flutter doctor            # resolve every ❌ before continuing
flutter config --enable-android --enable-ios
```

Android Studio (SDK + emulator) and Xcode with command line tools are required
for device builds.

## Quick start

```bash
make setup        # dependencies + git hooks
make platforms    # one time: generates android/ and ios/ host projects
make run FLAVOR=dev
```

`make platforms` runs `flutter create` with organization
`com.sgsaitechnology`; flavor IDs, minimum platform versions and signing are
configured in [docs/flavors.md](docs/flavors.md).

Point the app at a backend by editing `config/dev.json` (`API_BASE_URL` is the
site origin; the client appends `/api/v1`). The API lives in the `home` repo: its
container serves it at `http://localhost:8080` on iOS simulators and
`http://10.0.2.2:8080` on Android emulators; production is
`https://www.sgsaitechnology.com`.

## Daily commands

```bash
make check                  # format + analyze --fatal-infos + tests (run before every push)
make api-generate           # regenerate typed transport models from OpenAPI
make update-api-spec        # refresh openapi/backend.swagger from local backend
make format                 # dart format .
make test / make cov        # tests, tests with coverage at coverage/lcov.info
make integration FLAVOR=dev # on-device flows
make run FLAVOR=staging     # another flavor
make build-aab FLAVOR=prod  # release bundle
make help                   # all targets
```

## Project layout

```text
lib/
├── main.dart            entry point
├── app/                 bootstrap, App, router, theme tokens
├── core/                config, auth, network (Dio + interceptors), session, logging
├── features/<feature>/  data/ · domain/ · presentation/
└── shared/              cross-feature widgets and validators
test/                    mirrors lib/
integration_test/        on-device flows
config/                  per-flavor --dart-define files (no secrets)
docs/                    flavors, signing, Firebase
.githooks/               pre-commit, commit-msg, pre-push
```

## Conventions

- Conventional Commits, enforced by the `commit-msg` hook: `feat(auth): add sign-in screen`.
- Branch from `develop`: `feat/<issue>-<slug>`, open a draft PR early.
- Hooks are installed by `make setup`; `SKIP_HOOKS=1` bypasses them and must be
  explained in the PR.
- Never commit secrets, keystores, provisioning profiles or Firebase config files.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Agent and review rules live in
[AGENTS.md](AGENTS.md), path-specific rules in
[.github/instructions/](.github/instructions/), and reusable workflows in
[.claude/skills/](.claude/skills/).
