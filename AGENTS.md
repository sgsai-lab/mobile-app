# AGENTS.md — mobile-app

Instructions for AI coding agents (GitHub Copilot, Claude Code, Cursor, Codex). Humans: see [README.md](README.md).

## Project

SGS AI mobile app for Android and iOS. Flutter 3.47 · Dart 3.13 · Riverpod (no codegen) · go_router · Dio · flutter_secure_storage · very_good_analysis. Three flavors (`dev`, `staging`, `prod`) with distinct bundle IDs and Firebase projects. Backend is [backend-api](https://github.com/sgsai-lab/backend-api) (FastAPI on Cloud Run); auth is **backend-owned** (ADR-001), not Firebase Auth. Work is tracked in GitHub issues `APP-xx`.

## Commands

```bash
make setup                      # flutter pub get + install git hooks
make platforms                  # one-time: generate android/ and ios/ host projects
make run FLAVOR=dev             # flutter run with config/dev.json
make check                      # format + analyze (--fatal-infos) + tests — run before finishing any task
make format                     # dart format .
make test / make cov            # tests, tests with coverage
make integration FLAVOR=dev     # integration_test on a device
make build-aab FLAVOR=prod      # release bundle
```

Config is build-time only: `--dart-define-from-file=config/<flavor>.json`. Never read config from a `.env` bundled in the app.

## Layout

```text
lib/main.dart                 entry point -> bootstrap(App.new)
lib/app/                      bootstrap, App widget, router, theme tokens
lib/core/config/              AppConfig + Flavor (compile-time environment)
lib/core/network/             Dio client, endpoints, interceptors, ApiException
lib/core/storage/             TokenStore over flutter_secure_storage
lib/core/session/             SessionEvents (expiry signal, no feature imports)
lib/core/logging/             AppLogger facade
lib/features/<feature>/data/         repositories + DTO mapping (Dio lives here)
lib/features/<feature>/domain/       immutable models, sealed result types
lib/features/<feature>/presentation/ screens, widgets, Riverpod controllers
lib/shared/                   cross-feature widgets and validators
test/                         unit + widget tests, mirrors lib/
integration_test/             on-device flows
config/                       per-flavor dart-define files (no secrets)
```

## Non-negotiable rules

- **Feature-first**: a feature never imports another feature's `data/` or `presentation/`. Shared code goes to `lib/shared/` or `lib/core/`. `core/` never imports `features/`.
- **No HTTP outside `data/`.** Widgets and controllers talk to repositories; repositories own `Dio` and convert `DioException` to `ApiException` via `ApiException.fromDioException`.
- **Secrets never ship.** Anything in the binary is public: no API keys, service accounts, keystores, `.p12`, `.mobileprovision`, or Firebase service files in git. Build-time values come from `config/*.json`; CI secrets come from GitHub environments.
- **Tokens only in `TokenStore`** (Keychain / EncryptedSharedPreferences). Never `SharedPreferences`, files, query strings or logs.
- **Never log** tokens, passwords, OTPs, recovery codes, `Authorization` headers, request/response bodies or personal data. Use `AppLogger`; it is silent in release except errors.
- **HTTPS only** outside `dev`; `AppConfig` enforces it. No cleartext traffic, no ATS exceptions.
- **The server owns identity.** Never send a user id to identify the caller; use the token-derived `/users/me`. Treat 401 as "refresh once, then sign out" — that logic lives in `AuthInterceptor` only.
- **Every async UI state is handled**: loading, empty, error (with retry), offline. No raw exception text in the UI — show `ApiException.message`.
- **Accessibility**: label every control, tap targets ≥ 48dp, support text scaling and dark mode, no colour-only meaning.
- **Typed and formatted**: `dart format`, `flutter analyze --fatal-infos` clean. No `dynamic` outside JSON boundaries, no `late` without a documented reason, no `print`.
- **New behaviour needs tests**: widget tests for screens, unit tests for repositories/mapping, integration test for an end-to-end flow change.
- Conventional commits (`feat(auth): …`, `fix(network): …`) referencing the issue (`Refs #12`). The `commit-msg` hook enforces this.

## Detailed guidance

- Path-specific rules: [.github/instructions/](.github/instructions/) (app code, tests, platform/native, CI & release). Read the matching file before editing those paths.
- Reusable workflows (skills): [.claude/skills/](.claude/skills/) — `implement-github-issue`, `flutter-feature-module`, `api-client-integration`, `widget-test-suite`, `mobile-security-review`, `mobile-release`.
- Flavors, signing and Firebase wiring: [docs/flavors.md](docs/flavors.md).
