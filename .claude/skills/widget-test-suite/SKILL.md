---
name: widget-test-suite
description: "Write unit, widget and golden tests for a Flutter screen or repository with Riverpod overrides and fakes. Use when adding tests, fixing flaky tests, or when a PR lacks coverage in mobile-app."
argument-hint: "Screen or repository under test, e.g. SignInScreen"
---

# Write a test suite

## Setup

`test/helpers/pump_app.dart` exposes `tester.pumpApp(widget, overrides: [...])`, which mounts the widget with the app theme inside a `ProviderScope`.

Fakes are plain classes:

```dart
class _FakeThingRepository implements ThingRepository {
  _FakeThingRepository({this.failure});
  final ApiException? failure;
  int calls = 0;

  @override
  Future<List<Thing>> fetchAll() async {
    calls++;
    final failure = this.failure;
    if (failure != null) throw failure;
    return const [Thing(id: '1', title: 'First')];
  }
}
```

Inject with `overrides: [thingRepositoryProvider.overrideWithValue(_FakeThingRepository())]`.

## Cases to write

1. **Mapping** — `fromJson` with a full payload and with optional fields missing.
2. **Repository errors** — `ApiException.fromDioException` produces the right `code`, `statusCode` and message for 401 / 422 / timeout.
3. **Validation** — invalid input shows the field error and the repository is never called (`expect(fake.calls, 0)`).
4. **Loading** — the action disables while in flight (`expect(tester.widget<FilledButton>(...).onPressed, isNull)`).
5. **Failure** — the server message is visible to the user.
6. **Success** — state transitions and the user sees the result.
7. **Empty** — the empty state renders instead of a blank screen.

## Rules

- `await tester.pumpAndSettle()` after every interaction; never `Future.delayed`.
- Assert on user-visible things: text, tooltips, semantics, enabled state.
- No network, no secure storage, no timers in unit/widget tests.
- Fixtures use `dev@example.com`-style data; never real users, tokens or personal data.
- Flaky tests get fixed, not `skip`ped; assertions are never weakened to go green.
- Goldens: one widget per golden, fixed size and text scale, regenerate with `flutter test --update-goldens` and review the image in the PR.

## Verify

```bash
make test
make cov   # coverage/lcov.info — check the changed files are covered
```
