import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/network/api_exception.dart';
import 'package:mobile_app/features/services/data/service_catalog_repository.dart';
import 'package:mobile_app/features/services/domain/pwa_service.dart';
import 'package:mobile_app/features/services/presentation/service_catalog_view.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('PwaService', () {
    test('parses an HTTPS remote catalog item', () {
      final service = PwaService.fromJson(const <String, dynamic>{
        'id': 'workdesk',
        'name': 'WorkDesk',
        'description': 'A team workspace.',
        'url': 'https://work.google.com',
        'icon': 'work',
      });

      expect(service.name, 'WorkDesk');
      expect(service.url, 'https://work.google.com');
      expect(service.iconKey, 'work');
    });

    test('rejects non-HTTPS destinations from Remote Config', () {
      expect(
        () => PwaService.fromJson(const <String, dynamic>{
          'id': 'unsafe',
          'name': 'Unsafe',
          'description': 'Unsafe link.',
          'url': 'javascript:alert(1)',
        }),
        throwsFormatException,
      );
    });
  });

  test(
    'uses clearly marked sample services when Firebase is not configured',
    () async {
      final services = await const ServiceCatalogRepository(null)
          .fetchServices();

      expect(services, PwaService.sampleCatalog);
      expect(services, hasLength(6));
      expect(
        services.every((service) => service.url.contains('.google.com')),
        isTrue,
      );
    },
  );

  testWidgets('renders service links with accessible launch labels', (
    tester,
  ) async {
    await tester.pumpApp(
      ServiceCatalogView(onOpen: (_) {}),
      overrides: [
        serviceCatalogProvider.overrideWith(
          (ref) async => PwaService.sampleCatalog,
        ),
      ],
    );
    await tester.pumpAndSettle();

    expect(find.text('Your services'), findsOneWidget);
    expect(find.text('WorkDesk'), findsOneWidget);
    expect(find.text('LearnHub'), findsOneWidget);
    expect(find.text('HelpDesk'), findsOneWidget);
    expect(find.byTooltip('Open WorkDesk'), findsOneWidget);
  });

  testWidgets('shows an empty state when Remote Config has no services', (
    tester,
  ) async {
    await tester.pumpApp(
      ServiceCatalogView(onOpen: (_) {}),
      overrides: [serviceCatalogProvider.overrideWith((ref) async => [])],
    );
    await tester.pumpAndSettle();

    expect(find.text('No services available'), findsOneWidget);
  });

  testWidgets('shows a retryable state on invalid Remote Config', (
    tester,
  ) async {
    await tester.pumpApp(
      ServiceCatalogView(onOpen: (_) {}),
      overrides: [
        serviceCatalogProvider.overrideWith(
          (ref) async => throw const ApiException(
            code: 'INVALID_SERVICE_CATALOG',
            message: 'Services could not be loaded. Please try again.',
          ),
        ),
      ],
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Services could not be loaded. Please try again.'),
      findsOneWidget,
    );
    expect(find.text('Retry'), findsOneWidget);
  });
}
