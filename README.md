# mobile-app

SGS AI Technology — Flutter app for Android and iOS, backed by
[backend-api](https://github.com/sgsai-lab/backend-api).

| | |
| --- | --- |
| Stack | Flutter 3.47 · Dart 3.13 · Riverpod · go_router · Dio · flutter_secure_storage |
| Flavors | `dev`, `staging`, `prod` — distinct bundle ids and Firebase projects |
| Auth | Backend-owned (ADR-001): email/password → access + refresh tokens in secure storage |
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

`make platforms` runs `flutter create` so the native projects match your SDK;
afterwards apply the flavor configuration in [docs/flavors.md](docs/flavors.md).

Point the app at a backend by editing `config/dev.json`. A locally running
backend is `http://localhost:8080` on iOS simulators and `http://10.0.2.2:8080`
on Android emulators.

## Daily commands

```bash
make check                  # format + analyze --fatal-infos + tests (run before every push)
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
├── core/                config, network (Dio + interceptors), storage, session, logging
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
