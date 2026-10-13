import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/network/api_exception.dart';
import 'package:mobile_app/features/auth/data/auth_repository.dart';
import 'package:mobile_app/features/auth/domain/auth_tokens.dart';
import 'package:mobile_app/features/auth/presentation/auth_state.dart';
import 'package:mobile_app/features/auth/presentation/sign_in_screen.dart';

import '../../helpers/pump_app.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.failure});

  final ApiException? failure;
  int signInCalls = 0;
  String? lastEmail;

  @override
  Future<SignInResult> signIn({
    required String email,
    required String password,
  }) async {
    signInCalls++;
    lastEmail = email;
    final failure = this.failure;
    if (failure != null) throw failure;
    return const SignInSucceeded(
      AuthTokens(accessToken: 'token', expiresIn: 900),
    );
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

  test('auth state starts unknown so the router shows the startup screen', () {
    expect(const AuthUnknown(), isA<AuthState>());
  });
}
