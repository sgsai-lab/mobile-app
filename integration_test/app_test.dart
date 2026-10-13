import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile_app/app/app.dart';
import 'package:mobile_app/core/config/app_config.dart';
import 'package:mobile_app/features/auth/presentation/sign_in_screen.dart';

/// Runs on a real device/emulator:
/// `make integration FLAVOR=dev`
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('cold start lands a signed-out user on sign-in', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(AppConfig.fromEnvironment()),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SignInScreen), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Sign in'), findsOneWidget);
  });
}
