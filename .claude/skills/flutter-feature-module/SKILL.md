---
name: flutter-feature-module
description: "Scaffold a feature-first Flutter module (domain/data/presentation) with Riverpod state, a route and tests. Use when adding a new screen, flow or feature area to mobile-app."
argument-hint: "Feature name in snake_case, e.g. notifications"
---

# Add a Flutter feature module

## Files to create (`lib/features/<feature>/`)

```text
domain/<entity>.dart            immutable model + fromJson, no Flutter imports
domain/<action>_result.dart     sealed result type when a call has >1 outcome
data/<feature>_repository.dart  Dio calls, maps DioException -> ApiException, Provider
presentation/<feature>_state.dart       sealed UI state (optional for read-only screens)
presentation/<feature>_controller.dart  Notifier + NotifierProvider (only if it has actions)
presentation/<feature>_screen.dart      ConsumerWidget / ConsumerStatefulWidget
test/features/<feature>/...             mapping + widget tests
```

Templates: [assets/repository.dart.tmpl](assets/repository.dart.tmpl), [assets/controller.dart.tmpl](assets/controller.dart.tmpl), [assets/screen.dart.tmpl](assets/screen.dart.tmpl).

## Procedure

1. **Model the data first.** Write the `domain/` model against the real backend response (`/docs` on the API, or `curl`), with typed `fromJson` and defaults for optional fields. No `dynamic` beyond the JSON boundary.
2. **Add the endpoint** to `lib/core/network/api_endpoints.dart` — never inline a path string.
3. **Write the repository** using the template: own `Dio` from `dioProvider`, wrap calls in `try/on DioException` → `ApiException.fromDioException`, expose a `Provider`.
4. **Choose the state holder**:
   - read-only screen → `FutureProvider` + `AsyncValue.when`
   - screen with actions (submit, toggle, paginate) → `Notifier` with a `sealed` state
5. **Build the screen**: render loading, error (`AppErrorView` + retry), empty and data states. Use `AppSpacing`/`Theme.of(context)`, label every control, keep tap targets ≥ 48dp. Side effects in `ref.listen`, never in `build`.
6. **Register the route** in `lib/app/router.dart` (`AppRoutes` constant + `GoRoute`), and extend the `redirect` only if the screen has different auth requirements.
7. **Test** with the `widget-test-suite` skill: mapping test, repository error-mapping test, widget tests for validation/loading/error/success.
8. **Verify**: `make check`, then `make run FLAVOR=dev` and walk the flow including airplane mode and dark mode.

## Done when

- The feature imports no other feature; `core/` still imports no features.
- Every async state is visible to the user and every error path shows `ApiException.message`.
- Tests cover one success and at least one failure path, and `make check` is clean.
