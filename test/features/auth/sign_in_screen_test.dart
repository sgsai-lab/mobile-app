import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/network/api_exception.dart';
import 'package:mobile_app/features/auth/data/auth_repository.dart';
import 'package:mobile_app/features/auth/presentation/auth_state.dart';
import 'package:mobile_app/features/auth/presentation/sign_in_screen.dart';

import '../../helpers/pump_app.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.failure, this.needsMfa = false, this.mfaFailure});

  final ApiException? failure;
  final bool needsMfa;
  final ApiException? mfaFailure;
  int signInCalls = 0;
  String? lastEmail;
  String? lastCode;

  @override
  Future<SignInResult> signIn({
    required String email,
    required String password,
  }) async {
    signInCalls++;
    lastEmail = email;
    final failure = this.failure;
    if (failure != null) throw failure;
    return needsMfa ? const SignInNeedsMfa('mfa-1') : const SignInComplete();
  }

  @override
  Future<SignInResult> signInWithIdToken({
    required IdentityProvider provider,
    required String idToken,
    String? nonce,
    String? fullName,
  }) async => const SignInComplete();

  @override
  Future<void> verifyMfa({
    required String mfaToken,
    required String code,
  }) async {
    lastCode = code;
    final failure = mfaFailure;
    if (failure != null) throw failure;
  }

  @override
  Future<void> signOut() async {}

  @override
  Future<bool> hasStoredSession() async => false;
}

void main() {
  Future<void> fillForm(
    WidgetTester tester, {
    String email = 'dev@example.com',
    String password = 'correct-horse',
  }) async {
    await tester.enterText(find.byType(TextFormField).first, email);
    await tester.enterText(find.byType(TextFormField).last, password);
  }

  testWidgets('rejects an invalid email before calling the API', (
    tester,
  ) async {
    final repository = _FakeAuthRepository();
    await tester.pumpApp(
      const SignInScreen(),
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );

    await fillForm(tester, email: 'not-an-email');
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid email address.'), findsOneWidget);
    expect(repository.signInCalls, 0);
  });

  testWidgets('submits trimmed credentials and signs in', (tester) async {
    final repository = _FakeAuthRepository();
    await tester.pumpApp(
      const SignInScreen(),
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );

    await fillForm(tester, email: '  dev@example.com  ');
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(repository.signInCalls, 1);
    expect(repository.lastEmail, 'dev@example.com');
  });

  testWidgets('shows the server message when sign-in fails', (tester) async {
    final repository = _FakeAuthRepository(
      failure: const ApiException(
        code: 'INVALID_CREDENTIALS',
        message: 'Invalid email or password',
        statusCode: 401,
      ),
    );
    await tester.pumpApp(
      const SignInScreen(),
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );

    await fillForm(tester);
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(find.text('Invalid email or password'), findsOneWidget);
  });

  testWidgets('password is obscured until the user asks to see it', (
    tester,
  ) async {
    await tester.pumpApp(
      const SignInScreen(),
      overrides: [
        authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
      ],
    );

    expect(find.byTooltip('Show password'), findsOneWidget);
    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();
    expect(find.byTooltip('Hide password'), findsOneWidget);
  });

  testWidgets('accounts with two-factor authentication ask for a code', (
    tester,
  ) async {
    final repository = _FakeAuthRepository(
      needsMfa: true,
      mfaFailure: const ApiException(
        code: 'INVALID_CODE',
        message: 'That code is not correct.',
        statusCode: 401,
      ),
    );
    await tester.pumpApp(
      const SignInScreen(),
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );

    await fillForm(tester);
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(find.text('Two-factor authentication'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '123456');
    await tester.tap(find.widgetWithText(FilledButton, 'Verify'));
    await tester.pumpAndSettle();

    expect(repository.lastCode, '123456');
    expect(find.text('That code is not correct.'), findsOneWidget);
    expect(find.text('Two-factor authentication'), findsOneWidget);

    await tester.tap(find.text('Use a different account'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome back'), findsOneWidget);
  });

  test('auth state starts unknown so the router shows the startup screen', () {
    expect(const AuthUnknown(), isA<AuthState>());
  });
}
