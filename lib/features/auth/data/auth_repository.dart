import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/network/api_client.dart';
import 'package:mobile_app/core/network/api_endpoints.dart';
import 'package:mobile_app/core/network/api_exception.dart';
import 'package:mobile_app/core/network/auth_interceptor.dart';
import 'package:mobile_app/core/storage/token_store.dart';
import 'package:mobile_app/features/auth/domain/auth_tokens.dart';

class AuthRepository {
  const AuthRepository({required this._dio, required this._tokenStore});

  static final Options _unauthenticated = Options(
    extra: <String, bool>{skipAuth: true},
  );

  final Dio _dio;
  final TokenStore _tokenStore;

  Future<SignInResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: <String, String>{'email': email, 'password': password},
        options: _unauthenticated,
      );
      final data = response.data ?? const <String, dynamic>{};

      if (data['mfa_required'] == true) {
        return SignInNeedsMfa(
          mfaToken: data['mfa_token'] as String? ?? '',
          methods: (data['methods'] as List<dynamic>? ?? const <dynamic>[])
              .whereType<String>()
              .toList(growable: false),
        );
      }

      final tokens = AuthTokens.fromJson(data);
      await _tokenStore.save(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );
      return SignInSucceeded(tokens);
    } on DioException catch (error) {
      throw ApiException.fromDioException(error);
    }
  }

  /// Best effort server-side revocation; local tokens are always cleared.
  Future<void> signOut() async {
    try {
      await _dio.post<void>(ApiEndpoints.logout);
    } on DioException {
      // The session may already be revoked or the device offline.
    } finally {
      await _tokenStore.clear();
    }
  }

  Future<bool> hasStoredSession() async =>
      await _tokenStore.readRefreshToken() != null ||
      await _tokenStore.readAccessToken() != null;
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    dio: ref.watch(dioProvider),
    tokenStore: ref.watch(tokenStoreProvider),
  ),
);
