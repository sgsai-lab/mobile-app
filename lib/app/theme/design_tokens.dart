import 'package:flutter/material.dart';

/// SGS AI portal tokens, extracted from `backend-api/webapp/styles.css`.
abstract final class AppColors {
  static const Color ink = Color(0xFF17223B);
  static const Color muted = Color(0xFF687188);
  static const Color paper = Color(0xFFF8F9FC);
  static const Color white = Color(0xFFFFFFFF);
  static const Color line = Color(0xFFE5E8F0);
  static const Color purple = Color(0xFF873ED0);
  static const Color blue = Color(0xFF13A8CF);
  static const Color green = Color(0xFF15B88B);
  static const Color orange = Color(0xFFF4A34D);
  static const Color danger = Color(0xFFB42318);

  static const Color darkInk = Color(0xFFF3F4F8);
  static const Color darkMuted = Color(0xFFB2B9C9);
  static const Color darkSurface = Color(0xFF171D2B);
  static const Color darkLine = Color(0xFF343B4B);
  static const Color lightPurple = Color(0xFFBF8AEE);
  static const Color lightBlue = Color(0xFF62CDE7);
  static const Color lightGreen = Color(0xFF66DAB5);
}

abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

abstract final class AppRadius {
  static const double sm = 4;
  static const double md = 12;
  static const BorderRadius card = BorderRadius.all(Radius.circular(md));
}

abstract final class AppElevation {
  static const double flat = 0;
  static const double raised = 2;
  static const double floating = 8;
}
