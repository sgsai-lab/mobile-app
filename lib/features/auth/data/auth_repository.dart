import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/auth/firebase_auth_provider.dart';
import 'package:mobile_app/core/network/api_client.dart';
import 'package:mobile_app/core/network/api_endpoints.dart';
import 'package:mobile_app/core/network/api_exception.dart';

class AuthRepository {
  const AuthRepository(this._dio, this._firebaseAuth);

  final Dio _dio;
  final FirebaseAuth? _firebaseAuth;

  Future<void> signIn({required String email, required String password}) async {
    final firebaseAuth = _firebaseAuth;
    if (firebaseAuth == null) {
      throw const ApiException(
        code: 'FIREBASE_SIGNIN_UNAVAILABLE',
        message: 'Sign-in is not configured for this build yet.',
      );
    }

    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final idToken = await credential.user?.getIdToken();
      if (idToken == null) {
        await firebaseAuth.signOut();
        throw const ApiException(
          code: 'FIREBASE_TOKEN_UNAVAILABLE',
          message: 'Could not verify your sign-in. Please try again.',
        );
      }
      await _dio.post<void>(
        ApiEndpoints.firebaseSignIn,
        data: <String, String>{'id_token': idToken},
      );
    } on FirebaseAuthException catch (error) {
      throw _mapFirebaseError(error);
    } on DioException catch (error) {
      await firebaseAuth.signOut();
      throw ApiException.fromDioException(error);
    }
  }

  /// Revokes Firebase refresh tokens, then clears local auth state.
  Future<void> signOut() async {
    try {
      await _dio.post<void>(ApiEndpoints.logout);
    } on DioException {
      // Local sign-out still succeeds when the device is offline.
    } finally {
      await _firebaseAuth?.signOut();
    }
  }

  Future<bool> hasStoredSession() async => _firebaseAuth?.currentUser != null;

  ApiException _mapFirebaseError(FirebaseAuthException error) =>
      switch (error.code) {
        'invalid-credential' ||
        'wrong-password' ||
        'user-not-found' => const ApiException(
          code: 'INVALID_CREDENTIALS',
          message: 'Invalid email or password.',
          statusCode: 401,
        ),
        'too-many-requests' => const ApiException(
          code: 'RATE_LIMITED',
          message: 'Too many attempts. Please try again shortly.',
          statusCode: 429,
        ),
        'network-request-failed' => const ApiException(
          code: 'NETWORK_ERROR',
          message: 'No connection. Check your network and try again.',
        ),
        'multi-factor-auth-required' => const ApiException(
          code: 'MFA_REQUIRED',
          message: 'This account needs another verification step.',
          statusCode: 401,
        ),
        _ => const ApiException(
          code: 'SIGNIN_FAILED',
          message: 'Could not sign in. Please try again.',
        ),
      };
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) =>
      AuthRepository(ref.watch(dioProvider), ref.watch(firebaseAuthProvider)),
);
