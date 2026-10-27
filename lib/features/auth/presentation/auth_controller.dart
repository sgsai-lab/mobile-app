import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/network/api_exception.dart';
import 'package:mobile_app/core/session/session_events.dart';
import 'package:mobile_app/features/auth/data/auth_repository.dart';
import 'package:mobile_app/features/auth/presentation/auth_state.dart';

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    final subscription = ref
        .watch(sessionEventsProvider)
        .onExpired
        .listen(
          (_) => state = const AuthSignedOut(
            message: 'Your session expired. Please sign in again.',
          ),
        );
    ref.onDispose(subscription.cancel);
    unawaited(_restoreSession());
    return const AuthUnknown();
  }

  Future<void> _restoreSession() async {
    final hasSession = await ref
        .read(authRepositoryProvider)
        .hasStoredSession();
    state = hasSession ? const AuthSignedIn() : const AuthSignedOut();
  }

  Future<void> signIn({required String email, required String password}) =>
      _run(
        () => ref
            .read(authRepositoryProvider)
            .signIn(email: email, password: password),
      );

  Future<void> signInWithIdToken({
    required IdentityProvider provider,
    required String idToken,
    String? nonce,
    String? fullName,
  }) => _run(
    () => ref
        .read(authRepositoryProvider)
        .signInWithIdToken(
          provider: provider,
          idToken: idToken,
          nonce: nonce,
          fullName: fullName,
        ),
  );

  Future<void> _run(Future<SignInResult> Function() attempt) async {
    state = const AuthSigningIn();
    try {
      state = switch (await attempt()) {
        SignInComplete() => const AuthSignedIn(),
        SignInNeedsMfa(:final mfaToken) => AuthNeedsMfa(mfaToken: mfaToken),
      };
    } on ApiException catch (error) {
      state = AuthSignedOut(message: error.message);
    }
  }

  Future<void> verifyMfa(String code) async {
    final current = state;
    if (current is! AuthNeedsMfa) return;
    state = AuthNeedsMfa(mfaToken: current.mfaToken, busy: true);
    try {
      await ref
          .read(authRepositoryProvider)
          .verifyMfa(mfaToken: current.mfaToken, code: code);
      state = const AuthSignedIn();
    } on ApiException catch (error) {
      // An expired or locked challenge needs a fresh sign-in.
      state = error.statusCode == 429 || error.code == 'MFA_EXPIRED'
          ? AuthSignedOut(message: error.message)
          : AuthNeedsMfa(mfaToken: current.mfaToken, message: error.message);
    }
  }

  void cancelMfa() => state = const AuthSignedOut();

  Future<void> signOut() async {
    try {
      await ref.read(authRepositoryProvider).signOut();
    } finally {
      state = const AuthSignedOut();
    }
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
