import 'package:dio/dio.dart';
import 'package:mobile_app/core/network/api_endpoints.dart';
import 'package:mobile_app/core/storage/token_store.dart';

/// Set `Options(extra: {skipAuth: true})` on endpoints that must not carry a
/// bearer token (sign-in, refresh, registration).
const String skipAuth = 'skipAuth';

const String _retried = 'retriedAfterRefresh';

/// Attaches the access token and transparently rotates it once on a 401.
/// [QueuedInterceptor] serialises requests so parallel 401s cause one refresh.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this._tokenStore,
    required this._refreshClient,
    required this._onSessionExpired,
  });

  final TokenStore _tokenStore;
  final Dio _refreshClient;
  final Future<void> Function() _onSessionExpired;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[skipAuth] != true) {
      final token = await _tokenStore.readAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
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

    if (!await _refreshTokens()) {
      await _tokenStore.clear();
      await _onSessionExpired();
      handler.next(err);
      return;
    }

    try {
      final token = await _tokenStore.readAccessToken();
      options
        ..extra[_retried] = true
        ..headers['Authorization'] = 'Bearer $token';
      handler.resolve(await _refreshClient.fetch<dynamic>(options));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<bool> _refreshTokens() async {
    final refreshToken = await _tokenStore.readRefreshToken();
    if (refreshToken == null) return false;
    try {
      final response = await _refreshClient.post<Map<String, dynamic>>(
        ApiEndpoints.refresh,
        data: <String, String>{'refresh_token': refreshToken},
        options: Options(extra: <String, bool>{skipAuth: true}),
      );
      final data = response.data;
      final accessToken = data?['access_token'] as String?;
      if (accessToken == null) return false;
      await _tokenStore.save(
        accessToken: accessToken,
        refreshToken: data?['refresh_token'] as String?,
      );
      return true;
    } on DioException {
      return false;
    }
  }
}
