---
applyTo: "test/**/*.dart,integration_test/**/*.dart"
description: "Testing conventions: unit, widget, golden and integration tests, fakes, and what must be covered."
---
# Tests

## Layout & naming

- `test/` mirrors `lib/` (`lib/features/auth/data/auth_repository.dart` → `test/features/auth/auth_repository_test.dart`).
- Shared helpers live in `test/helpers/`; use `tester.pumpApp(widget, overrides: [...])` so tests get the real theme and a `ProviderScope`.
- Test names state behaviour, not implementation: `'shows the server message when sign-in fails'`.

## What to cover

| Layer | Must test |
| --- | --- |
| `domain/` | JSON mapping, defaults for missing fields, derived values |
| `data/` | Success path, error mapping to `ApiException`, auth-skipping options |
| `presentation/` | Validation before the call, loading/disabled state, error surface, success transition |
| Flow | One integration test per critical journey (sign-in, main task) |

Always include at least one failure case: invalid credentials (401), validation (422), and offline/timeout.

## Rules

- No real network, no real secure storage, no `sleep`. Replace providers with fakes through `overrides`; fakes are plain classes that `implements` the repository.
- Pump deterministically: `await tester.pumpAndSettle()` after interactions; never `Future.delayed` to "wait" for the UI.
- Assert what the user perceives (text, enabled state, semantics), not private widget internals.
- Tests must not print tokens or realistic personal data — use `dev@example.com` style fixtures.
- A test that is flaky gets fixed or deleted, never `skip`ped silently. Do not weaken an assertion to go green.
- Golden tests (when added): keep them small, one widget per golden, regenerate deliberately with `flutter test --update-goldens` and review the image diff in the PR.
- Integration tests run against `dev` config and must leave no server-side state behind; they assume a signed-out cold start.
