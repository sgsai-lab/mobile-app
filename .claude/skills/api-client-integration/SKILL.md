---
name: api-client-integration
description: "Wire a backend-api endpoint into the app: contract check, endpoint constant, repository call, error mapping and tests. Use when adding or changing any network call in mobile-app."
argument-hint: "Endpoint, e.g. GET /api/v1/projects"
---

# Integrate a backend endpoint

The backend is FastAPI with an OpenAPI schema. Read the contract first — never guess field names.

## 1. Confirm the contract

```bash
curl -s http://localhost:8080/openapi.json | jq '.paths["/api/v1/<path>"]'
# or open http://localhost:8080/docs
```

Record: method, path, auth requirement, request body, success schema, status code, and the error codes it can return (`401`, `403`, `404`, `409`, `422`, `429`).

## 2. Add the path

`lib/core/network/api_endpoints.dart` — one constant, no inline strings, no string interpolation of base URLs.

When the backend contract changes, refresh `openapi/backend.swagger` with
`make update-api-spec`, then run `make api-generate`. Use generated DTOs from
`lib/core/network/generated/` in repositories so breaking schema changes surface
at compile time; never edit generated files directly.

## 3. Call it from the repository

```dart
Future<Thing> fetchThing(String id) async {
  try {
    final response = await _dio.get<Map<String, dynamic>>('${ApiEndpoints.things}/$id');
    return Thing.fromJson(response.data ?? const <String, dynamic>{});
  } on DioException catch (error) {
    throw ApiException.fromDioException(error);
  }
}
```

- Public/unauthenticated endpoints: `options: Options(extra: {skipAuth: true})`.
- Never send the caller's user id — identity comes from the token. Resources are owner-scoped server-side and return `404` for someone else's data.
- Lists: always pass `page`/`page_size`; never fetch unbounded collections.
- Mutations that must not be duplicated on retry need an idempotency strategy agreed with the backend — do not add blind retries.

## 4. Map errors to the UI

| Backend code | App behaviour |
| --- | --- |
| `UNAUTHENTICATED` (401) | `AuthInterceptor` refreshes once, then signs the user out — no feature-level handling |
| `FORBIDDEN` (403) | explain the restriction, do not retry |
| `RESOURCE_NOT_FOUND` (404) | empty state, not an error toast |
| `VALIDATION_ERROR` (422) | attach `messageForField(...)` to the matching form field |
| `RATE_LIMITED` (429) | disable the action and show "try again shortly" |
| `TIMEOUT` / `NETWORK_ERROR` | retryable error state with a Retry button |

## 5. Test

- Repository test per outcome: success mapping, envelope parsing, `isUnauthenticated`, offline/timeout.
- Widget test that the failure renders a user-visible message, not a crash.

## Done when

- No HTTP outside `data/`, no `dynamic` leaking past `fromJson`, no secrets or ids in query strings.
- Every documented error status has a defined, tested app behaviour.
- `make check` passes and the call was exercised against a running backend in the `dev` flavor.
