import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/app.dart';
import 'package:mobile_app/core/config/app_config.dart';
import 'package:mobile_app/core/network/api_exception.dart';
import 'package:mobile_app/features/auth/data/auth_repository.dart';
import 'package:mobile_app/features/services/data/service_catalog_repository.dart';
import 'package:mobile_app/features/services/domain/pwa_service.dart';
import 'package:mobile_app/features/services/presentation/service_launch_screen.dart';

import '../../helpers/pump_app.dart';

class _FakeAuthRepository implements AuthRepository {
  bool isSignedIn = false;

  @override
  Future<void> signIn({required String email, required String password}) async {
    isSignedIn = true;
  }

  @override
  Future<void> signOut() async {
    isSignedIn = false;
  }

  @override
  Future<bool> hasStoredSession() async => isSignedIn;
}

void main() {
  testWidgets(
    'shows services before login and resumes the selected PWA after login',
    (tester) async {
      final authRepository = _FakeAuthRepository();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appConfigProvider.overrideWithValue(testAppConfig),
            authRepositoryProvider.overrideWithValue(authRepository),
            serviceCatalogProvider.overrideWith(
              (ref) async => PwaService.sampleCatalog,
            ),
          ],
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Your services'), findsOneWidget);
      expect(find.text('WorkDesk'), findsOneWidget);
      expect(find.text('Welcome back'), findsNothing);

      await tester.tap(find.byTooltip('Open WorkDesk'));
      await tester.pumpAndSettle();

      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Your services'), findsNothing);

      await tester.enterText(
        find.byType(TextFormField).first,
        'dev@example.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'correct-horse');
      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pumpAndSettle();

      expect(find.byType(ServiceLaunchScreen), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, 'Open WorkDesk'),
        findsOneWidget,
      );
      expect(authRepository.isSignedIn, isTrue);
    },
  );

  testWidgets('sign-in errors remain visible without losing service intent', (
    tester,
  ) async {
    await tester.pumpApp(
      const App(),
      overrides: [
        authRepositoryProvider.overrideWithValue(_FailingAuthRepository()),
        serviceCatalogProvider.overrideWith(
          (ref) async => PwaService.sampleCatalog,
        ),
      ],
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Open WorkDesk'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'dev@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'correct-horse');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Invalid email or password.'), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
  });
}

class _FailingAuthRepository implements AuthRepository {
  @override
  Future<void> signIn({required String email, required String password}) async {
    throw const ApiException(
      code: 'INVALID_CREDENTIALS',
      message: 'Invalid email or password.',
      statusCode: 401,
    );
  }

  @override
  Future<void> signOut() async {}

  @override
  Future<bool> hasStoredSession() async => false;
}
