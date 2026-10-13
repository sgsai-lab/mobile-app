import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Flavor {
  dev('dev'),
  staging('staging'),
  prod('prod');

  const Flavor(this.key);

  final String key;

  static Flavor fromKey(String key) => Flavor.values.firstWhere(
    (flavor) => flavor.key == key,
    orElse: () => throw ArgumentError.value(
      key,
      'FLAVOR',
      'Expected one of: ${Flavor.values.map((f) => f.key).join(', ')}',
    ),
  );
}

/// Build-time configuration, supplied with
/// `--dart-define-from-file=config/<flavor>.json`. Never put secrets here:
/// anything compiled into the binary is readable by anyone with the app.
@immutable
class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.apiBaseUrl,
    this.enableHttpLogging = false,
    this.connectTimeout = const Duration(seconds: 10),
    this.receiveTimeout = const Duration(seconds: 20),
  });

  factory AppConfig.fromEnvironment() {
    const flavorKey = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    const apiBaseUrl = String.fromEnvironment('API_BASE_URL');
    const enableHttpLogging = bool.fromEnvironment('ENABLE_HTTP_LOGGING');

    final flavor = Flavor.fromKey(flavorKey);
    final uri = Uri.tryParse(apiBaseUrl);
    if (apiBaseUrl.isEmpty || uri == null || !uri.isAbsolute) {
      throw StateError(
        'API_BASE_URL is missing or invalid. Run with '
        '--dart-define-from-file=config/${flavor.key}.json',
      );
    }
    if (flavor != Flavor.dev && uri.scheme != 'https') {
      throw StateError('API_BASE_URL must use https for ${flavor.key} builds.');
    }

    return AppConfig(
      flavor: flavor,
      apiBaseUrl: apiBaseUrl,
      enableHttpLogging: enableHttpLogging && flavor != Flavor.prod,
    );
  }

  final Flavor flavor;
  final String apiBaseUrl;
  final bool enableHttpLogging;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  bool get isProd => flavor == Flavor.prod;

  String get appTitle => isProd ? 'SGS AI' : 'SGS AI (${flavor.key})';
}

/// Overridden in `bootstrap()`; tests override it with a fixture config.
final appConfigProvider = Provider<AppConfig>(
  (ref) => throw UnimplementedError('appConfigProvider must be overridden'),
);
