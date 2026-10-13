import 'dart:async';
import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Thin logging facade. Never pass tokens, passwords, OTPs, recovery codes or
/// `Authorization` headers to it — release builds ship to a crash reporter.
class AppLogger {
  const AppLogger._();

  static const AppLogger instance = AppLogger._();

  void debug(String message, {Map<String, Object?>? context}) {
    if (kReleaseMode) return;
    developer.log(_format(message, context), name: 'app');
  }

  void info(String message, {Map<String, Object?>? context}) {
    if (kReleaseMode) return;
    developer.log(_format(message, context), name: 'app');
  }

  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
  }) {
    developer.log(
      _format(message, context),
      name: 'app',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
    if (Firebase.apps.isNotEmpty) {
      unawaited(
        FirebaseCrashlytics.instance.recordError(
          StateError('Application error (${error.runtimeType})'),
          stackTrace ?? StackTrace.current,
          reason: message,
        ),
      );
    }
  }

  String _format(String message, Map<String, Object?>? context) {
    if (context == null || context.isEmpty) return message;
    final pairs = context.entries.map((e) => '${e.key}=${e.value}').join(' ');
    return '$message $pairs';
  }
}
