import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/auth/token_store.dart';
import 'package:mobile_app/core/network/api_client.dart';
import 'package:mobile_app/core/network/api_endpoints.dart';
import 'package:mobile_app/core/network/api_exception.dart';
import 'package:mobile_app/core/network/auth_interceptor.dart';
import 'package:mobile_app/core/storage/snapshot_cache.dart';

/// Outcome of a first sign-in step.
sealed class SignInResult {
  const SignInResult();
}

final class SignInComplete extends SignInResult {
  const SignInComplete();
}

/// The account has two-factor authentication.
/// Finish with [AuthRepository.verifyMfa].
final class SignInNeedsMfa extends SignInResult {
  const SignInNeedsMfa(this.mfaToken);

  final String mfaToken;
}

enum IdentityProvider { google, apple }

/// Identity is owned by the SGS API (ADR-002): `/api/v1/auth/*` issues an
/// access token and a single-use refresh token, kept in [TokenStore].
class AuthRepository {
  AuthRepository(
    this._dio,
    this._tokenStore,
    this._cache, {
    this._now = DateTime.now,
  });

  final Dio _dio;
  final TokenStore _tokenStore;
  final SnapshotCache _cache;
  final DateTime Function() _now;

  static final Options _public = Options(
    extra: <String, Object>{skipAuth: true},
  );

  Future<SignInResult> signIn({
    required String email,
    required String password,
  }) => _complete(ApiEndpoints.login, <String, String>{
    'email': email,
    'password': password,
  });

  /// Exchanges a Google or Apple ID token obtained by the platform SDK.
  Future<SignInResult> signInWithIdToken({
    required IdentityProvider provider,
    required String idToken,
    String? nonce,
    String? fullName,
  }) => _complete(
    provider == IdentityProvider.google
        ? ApiEndpoints.google
        : ApiEndpoints.apple,
    <String, String>{
      'id_token': idToken,
      'nonce': ?nonce,
      'full_name': ?fullName,
    },
  );

  /// Accepts a 6-digit authenticator code or a recovery code.
  Future<void> verifyMfa({
    required String mfaToken,
    required String code,
  }) async {
    final value = code.replaceAll(RegExp(r'\s+'), '');
    final factor = RegExp(r'^\d{6}$').hasMatch(value)
        ? <String, String>{'code': value}
        : <String, String>{'recovery_code': value};
    final result = await _complete(ApiEndpoints.mfaVerify, <String, String>{
      'mfa_token': mfaToken,
      ...factor,
    });
    if (result is SignInNeedsMfa) {
      throw const ApiException(
        code: 'MFA_FAILED',
        message: 'Could not verify your code. Please sign in again.',
      );
    }
  }

  Future<SignInResult> _complete(String path, Map<String, String> body) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        path,
        data: body,
        options: _public,
      );
      final data = response.data ?? const <String, dynamic>{};
      if (data['mfa_required'] == true) {
        return SignInNeedsMfa(data['mfa_token'] as String);
      }
      await _tokenStore.write(AuthTokens.fromResponse(data, _now()));
      return const SignInComplete();
    } on DioException catch (error) {
      throw ApiException.fromDioException(error);
    } on FormatException {
      throw const ApiException(
        code: 'SIGNIN_FAILED',
        message: 'Could not sign in. Please try again.',
      );
    }
  }

  /// Revokes the session on the server when reachable, then clears local state.
  Future<void> signOut() async {
    final tokens = await _tokenStore.read();
    try {
      if (tokens != null) {
        await _dio.post<void>(
          ApiEndpoints.logout,
          data: <String, String>{'refresh_token': tokens.refreshToken},
        );
      }
    } on DioException {
      // Local sign-out still succeeds when the device is offline.
    } finally {
      await _tokenStore.clear();
      await _cache.clear();
    }
  }

  Future<bool> hasStoredSession() async => await _tokenStore.read() != null;
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    ref.watch(dioProvider),
    ref.watch(tokenStoreProvider),
    ref.watch(snapshotCacheProvider),
  ),
);
