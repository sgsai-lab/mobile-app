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
    final repository = ref.read(authRepositoryProvider);
    final hasSession = await repository.hasStoredSession();
    state = hasSession ? const AuthSignedIn() : const AuthSignedOut();
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AuthSigningIn();
    try {
      await ref
          .read(authRepositoryProvider)
          .signIn(email: email, password: password);
      state = const AuthSignedIn();
    } on ApiException catch (error) {
      state = AuthSignedOut(message: error.message);
    }
  }

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
