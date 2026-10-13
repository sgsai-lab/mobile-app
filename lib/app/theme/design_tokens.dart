import 'package:flutter/material.dart';

/// Brand tokens. Update these from the portal design system (APP-05) rather
/// than hard-coding colours or spacing in widgets.
abstract final class AppColors {
  static const Color brand = Color(0xFF0B5FFF);
  static const Color danger = Color(0xFFD92D20);
  static const Color success = Color(0xFF12B76A);
}

abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

abstract final class AppRadius {
  static const double md = 12;
  static const BorderRadius card = BorderRadius.all(Radius.circular(md));
}
