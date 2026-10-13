import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Set `Options(extra: {skipAuth: true})` on endpoints that must not carry a
/// bearer token (sign-in, refresh, registration).
const String skipAuth = 'skipAuth';

const String _retried = 'retriedAfterRefresh';

/// Attaches the access token and transparently rotates it once on a 401.
/// [QueuedInterceptor] serialises requests so parallel 401s cause one refresh.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this._firebaseAuth,
    required this._refreshClient,
    required this._onSessionExpired,
  });

  final FirebaseAuth? _firebaseAuth;
  final Dio _refreshClient;
  final Future<void> Function() _onSessionExpired;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[skipAuth] != true) {
      final token = await _firebaseAuth?.currentUser?.getIdToken();
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

    if (!await _refreshFirebaseToken()) {
      await _expireSession();
      handler.next(err);
      return;
    }

    try {
      final token = await _firebaseAuth?.currentUser?.getIdToken();
      options
        ..extra[_retried] = true
        ..headers['Authorization'] = 'Bearer $token';
      handler.resolve(await _refreshClient.fetch<dynamic>(options));
    } on DioException catch (retryError) {
      if (retryError.response?.statusCode == 401) {
        await _expireSession();
      }
      handler.next(retryError);
    }
  }

  Future<void> _expireSession() async {
    try {
      await _firebaseAuth?.signOut();
    } on FirebaseAuthException {
      // The SDK can already have removed a revoked or expired user locally.
    }
    await _onSessionExpired();
  }

  Future<bool> _refreshFirebaseToken() async {
    final user = _firebaseAuth?.currentUser;
    if (user == null) return false;
    try {
      return await user.getIdToken(true) != null;
    } on FirebaseAuthException {
      return false;
    }
  }
}
