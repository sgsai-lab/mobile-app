import 'package:flutter/material.dart';
import 'package:mobile_app/app/theme/design_tokens.dart';

abstract final class AppTheme {
  static ThemeData light() => _base(Brightness.light);

  static ThemeData dark() => _base(Brightness.dark);

  static ThemeData _base(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.purple,
          brightness: brightness,
        ).copyWith(
          primary: isDark ? AppColors.lightPurple : AppColors.purple,
          onPrimary: isDark ? AppColors.ink : AppColors.white,
          secondary: isDark ? AppColors.lightBlue : AppColors.blue,
          onSecondary: isDark ? AppColors.ink : AppColors.ink,
          tertiary: isDark ? AppColors.lightGreen : AppColors.green,
          onTertiary: isDark ? AppColors.ink : AppColors.ink,
          error: AppColors.danger,
          surface: isDark ? AppColors.darkSurface : AppColors.paper,
          onSurface: isDark ? AppColors.darkInk : AppColors.ink,
          outline: isDark ? AppColors.darkLine : AppColors.line,
        );
    final baseTextTheme = ThemeData(brightness: brightness).textTheme.apply(
      fontFamily: 'DM Sans',
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );
    final textTheme = baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge?.copyWith(fontFamily: 'Manrope'),
      displayMedium: baseTextTheme.displayMedium?.copyWith(
        fontFamily: 'Manrope',
      ),
      displaySmall: baseTextTheme.displaySmall?.copyWith(fontFamily: 'Manrope'),
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(
        fontFamily: 'Manrope',
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        fontFamily: 'Manrope',
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        fontFamily: 'Manrope',
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(fontFamily: 'Manrope'),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: AppRadius.card),
        filled: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          // 48dp keeps the tap target above the accessibility minimum.
          minimumSize: const Size.fromHeight(48),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.card),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      cardTheme: const CardThemeData(
        elevation: AppElevation.flat,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
      ),
    );
  }
}
