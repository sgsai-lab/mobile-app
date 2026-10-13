import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/config/app_config.dart';

void main() {
  group('Flavor', () {
    test('resolves every known key', () {
      expect(Flavor.fromKey('dev'), Flavor.dev);
      expect(Flavor.fromKey('staging'), Flavor.staging);
      expect(Flavor.fromKey('prod'), Flavor.prod);
    });

    test('rejects an unknown key instead of silently defaulting', () {
      expect(() => Flavor.fromKey('qa'), throwsArgumentError);
    });
  });

  group('AppConfig', () {
    test('non-prod builds are labelled so testers know what they got', () {
      const config = AppConfig(
        flavor: Flavor.staging,
        apiBaseUrl: 'https://api-staging.example.com',
      );
      expect(config.appTitle, 'SGS AI (staging)');
      expect(config.isProd, isFalse);
    });

    test('prod keeps the clean store title', () {
      const config = AppConfig(
        flavor: Flavor.prod,
        apiBaseUrl: 'https://api.example.com',
      );
      expect(config.appTitle, 'SGS AI');
      expect(config.isProd, isTrue);
    });

    test('enables request logging only when explicitly enabled in dev', () {
      expect(
        AppConfig.fromValues(
          flavorKey: 'dev',
          apiBaseUrl: 'http://localhost:8080',
          enableHttpLogging: true,
          firebaseEnabled: true,
        ).enableHttpLogging,
        isTrue,
      );
      for (final flavor in [Flavor.staging, Flavor.prod]) {
        expect(
          AppConfig.fromValues(
            flavorKey: flavor.key,
            apiBaseUrl: 'https://api.example.com',
            enableHttpLogging: true,
            firebaseEnabled: true,
          ).enableHttpLogging,
          isFalse,
        );
      }
    });
  });
}
