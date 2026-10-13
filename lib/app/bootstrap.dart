import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/config/app_config.dart';
import 'package:mobile_app/core/logging/app_logger.dart';

typedef AppBuilder = Widget Function();

/// Single entry point for every flavor: installs error handlers, resolves
/// build-time config and starts the app inside a [ProviderScope].
Future<void> bootstrap(AppBuilder builder) async {
  final config = AppConfig.fromEnvironment();

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (details) {
        AppLogger.instance.error(
          'flutter_error',
          error: details.exception,
          stackTrace: details.stack,
        );
      };
      PlatformDispatcher.instance.onError = (error, stackTrace) {
        AppLogger.instance.error(
          'platform_error',
          error: error,
          stackTrace: stackTrace,
        );
        return true;
      };

      runApp(
        ProviderScope(
          overrides: [appConfigProvider.overrideWithValue(config)],
          child: builder(),
        ),
      );
    },
    (error, stackTrace) {
      AppLogger.instance.error(
        'uncaught_zone_error',
        error: error,
        stackTrace: stackTrace,
      );
    },
  );
}
