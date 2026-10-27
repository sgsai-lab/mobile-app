import 'package:dio/dio.dart';
import 'package:mobile_app/core/auth/token_store.dart';
import 'package:mobile_app/core/network/api_endpoints.dart';

/// Set `Options(extra: {skipAuth: true})` on endpoints that must not carry a
/// bearer token (sign-in, MFA, refresh).
const String skipAuth = 'skipAuth';

const String _retried = 'retriedAfterRefresh';

/// Attaches the SGS access token and, on a 401, rotates the single-use refresh
/// token once and retries. [QueuedInterceptor] serialises requests, so
/// parallel 401s trigger one refresh: presenting a spent refresh token twice
/// would make the server revoke the whole session.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this._tokenStore,
    required this._refreshClient,
    required this._onSessionExpired,
    this._now = DateTime.now,
  });

  final TokenStore _tokenStore;
  final Dio _refreshClient;
  final Future<void> Function() _onSessionExpired;
  final DateTime Function() _now;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[skipAuth] != true) {
      final tokens = await _tokenStore.read();
      if (tokens != null) {
        options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final isRetryable =
        err.response?.statusCode == 401 &&
        options.extra[skipAuth] != true &&
        options.extra[_retried] != true;
    if (!isRetryable) {
      handler.next(err);
      return;
    }

    final rotated = await _rotate(options.headers['Authorization']);
    if (rotated == null) {
      await _expireSession();
      handler.next(err);
      return;
    }

    try {
      options
        ..extra[_retried] = true
        ..headers['Authorization'] = 'Bearer ${rotated.accessToken}';
      handler.resolve(await _refreshClient.fetch<dynamic>(options));
    } on DioException catch (retryError) {
      if (retryError.response?.statusCode == 401) await _expireSession();
      handler.next(retryError);
    }
  }

  /// Returns fresh tokens, or null when the session cannot be renewed.
  Future<AuthTokens?> _rotate(Object? failedAuthorization) async {
    final current = await _tokenStore.read();
    if (current == null) return null;
    // Another queued request may already have refreshed while this one waited.
    if (failedAuthorization != 'Bearer ${current.accessToken}') return current;
    try {
      final response = await _refreshClient.post<Map<String, dynamic>>(
        ApiEndpoints.refresh,
        data: <String, String>{'refresh_token': current.refreshToken},
        options: Options(extra: <String, Object>{skipAuth: true}),
      );
      final data = response.data;
      if (data == null) return null;
      final tokens = AuthTokens.fromResponse(data, _now());
      await _tokenStore.write(tokens);
      return tokens;
    } on DioException {
      return null;
    } on FormatException {
      return null;
    }
  }

  Future<void> _expireSession() async {
    await _tokenStore.clear();
    await _onSessionExpired();
  }
}
