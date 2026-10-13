---
applyTo: "lib/**/*.dart"
description: "Flutter application code conventions: feature structure, Riverpod, navigation, networking, state, theming, accessibility."
---
# Flutter application code

## Feature structure (`lib/features/<feature>/`)

| Folder | Responsibility |
| --- | --- |
| `domain/` | Immutable models, `sealed` result types, pure business rules. No Flutter or Dio imports. |
| `data/` | Repositories: own `Dio`, map JSON ↔ models, throw `ApiException`. No widgets. |
| `presentation/` | Screens, widgets and Riverpod controllers. No `Dio`, no JSON. |

Dependencies point inwards: `presentation → data → domain`. `core/` must never import `features/`; cross-feature code goes to `lib/shared/`.

## State (Riverpod, no codegen)

- Repositories: `Provider`. Remote reads: `FutureProvider`. Screen logic with actions: `Notifier` + `NotifierProvider`.
- Model screen state as a `sealed class` (see `AuthState`) instead of booleans like `isLoading`/`hasError`.
- Controllers own orchestration, never widget-tree concerns; widgets read with `ref.watch` and act with `ref.read(provider.notifier)`.
- Side effects (snack bars, navigation) go in `ref.listen`, never in `build`.
- Anything a test must replace needs a provider to override — no global singletons or static mutable state.

## Networking

- Paths live in `ApiEndpoints`; no inline URL strings.
- Repositories wrap every call in `try/on DioException` → `throw ApiException.fromDioException(e)`.
- Endpoints that must not send a token pass `Options(extra: {skipAuth: true})`. Firebase bootstrap sends its verified ID token to link the Firebase UID with the backend user.
- Token attachment and one forced Firebase ID-token refresh/retry belong to `AuthInterceptor` only. FirebaseAuth owns token persistence; never read or write Firebase tokens in app storage, repositories or widgets.
- Parse JSON in explicit `fromJson` factories with typed casts and defaults for optional fields. Backend field names are `snake_case`.

## UI

- `StatelessWidget`/`ConsumerWidget` by default; `ConsumerStatefulWidget` only for controllers, focus nodes and animations — and always `dispose()` them.
- Every async surface renders loading, error (with retry via `AppErrorView`) and empty states. Errors shown to users come from `ApiException.message`.
- Use `AppSpacing`, `AppRadius`, `AppColors` and `Theme.of(context)`; no magic numbers or hard-coded colours in widgets.
- Lists are lazy (`ListView.builder`); long screens scroll and survive the keyboard (`SingleChildScrollView` + `SafeArea`).
- Accessibility: `labelText`/`tooltip`/`semanticsLabel` on interactive and progress widgets, tap targets ≥ 48dp, no colour-only meaning, works at 200% text scale.
- User-facing strings stay in the widget layer. When `flutter_localizations` lands (APP-07), move them to ARB files — do not scatter them in `data/` or `domain/`.

## Configuration & security

- Read build-time values only through `AppConfig`; never call `String.fromEnvironment` in feature code.
- Firebase credentials and tokens remain inside the FirebaseAuth SDK. Never copy tokens into `SharedPreferences`, files, logs, analytics or URLs.
- `AppLogger` takes messages and non-sensitive context only — never bodies, headers or tokens.
- No platform channels or plugins added without checking Android and iOS permission impact; new permissions need an issue and a privacy note.
