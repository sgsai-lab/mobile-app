import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/theme/app_theme.dart';
import 'package:mobile_app/core/config/app_config.dart';

const AppConfig testAppConfig = AppConfig(
  flavor: Flavor.dev,
  apiBaseUrl: 'http://localhost:8080',
);

extension PumpApp on WidgetTester {
  /// Mounts [child] with the app theme inside a `ProviderScope` so widget
  /// tests look like the real app. Pass [overrides] to inject fakes.
  Future<void> pumpApp(
    Widget child, {
    List<Override> overrides = const [],
  }) async {
    await pumpWidget(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(testAppConfig),
          ...overrides,
        ],
        child: MaterialApp(theme: AppTheme.light(), home: child),
      ),
    );
    await pump();
  }
}
