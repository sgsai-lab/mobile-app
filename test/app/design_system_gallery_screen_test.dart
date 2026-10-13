import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/design_system_gallery_screen.dart';
import 'package:mobile_app/app/theme/app_theme.dart';
import 'package:mobile_app/shared/widgets/app_empty_view.dart';
import 'package:mobile_app/shared/widgets/app_error_view.dart';
import 'package:mobile_app/shared/widgets/app_loading_view.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('previews app components in both themes', (tester) async {
    await tester.pumpApp(const DesignSystemGalleryScreen());

    expect(find.text('Light theme'), findsOneWidget);
    expect(find.text('Dark theme'), findsOneWidget);
    expect(find.text('SGS AI components'), findsOneWidget);
    expect(find.text('Manrope display'), findsNWidgets(2));
    expect(
      find.text('DM Sans body text and supporting copy.'),
      findsNWidgets(2),
    );
    expect(find.text('Primary'), findsNWidgets(2));
    expect(find.text('Secondary'), findsNWidgets(2));
    expect(find.byType(AppEmptyView), findsNWidgets(2));
    expect(find.byType(AppLoadingView), findsNWidgets(2));
    expect(find.byType(AppErrorView), findsNWidgets(2));
  });

  testWidgets('remains scrollable and overflow-free with large text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpApp(const DesignSystemGalleryScreen());
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -1200),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Dark theme'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('uses the SGS AI portal palette and requested typefaces', () {
    expect(AppTheme.light().colorScheme.primary, const Color(0xFF873ED0));
    expect(AppTheme.light().colorScheme.surface, const Color(0xFFF8F9FC));
    expect(AppTheme.light().textTheme.bodyMedium?.fontFamily, 'DM Sans');
    expect(AppTheme.light().textTheme.headlineSmall?.fontFamily, 'Manrope');
    expect(AppTheme.dark().brightness, Brightness.dark);
  });

  test('brand action colors meet WCAG AA contrast in both themes', () {
    for (final theme in [AppTheme.light(), AppTheme.dark()]) {
      final scheme = theme.colorScheme;
      for (final pair in [
        (scheme.primary, scheme.onPrimary),
        (scheme.secondary, scheme.onSecondary),
        (scheme.tertiary, scheme.onTertiary),
      ]) {
        final lighter = pair.$1.computeLuminance() > pair.$2.computeLuminance()
            ? pair.$1.computeLuminance()
            : pair.$2.computeLuminance();
        final darker = pair.$1.computeLuminance() > pair.$2.computeLuminance()
            ? pair.$2.computeLuminance()
            : pair.$1.computeLuminance();
        expect((lighter + 0.05) / (darker + 0.05), greaterThanOrEqualTo(4.5));
      }
    }
  });
}
