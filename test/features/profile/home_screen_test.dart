import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/profile/data/profile_repository.dart';
import 'package:mobile_app/features/profile/domain/user_profile.dart';
import 'package:mobile_app/features/profile/presentation/home_screen.dart';
import 'package:mobile_app/features/services/data/service_catalog_repository.dart';
import 'package:mobile_app/features/services/domain/pwa_service.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the signed-in profile and service directory', (
    tester,
  ) async {
    await tester.pumpApp(
      const HomeScreen(),
      overrides: [
        currentUserProvider.overrideWith(
          (ref) async => const UserProfile(
            id: 'user-1',
            email: 'dev@example.com',
            fullName: 'Ada Lovelace',
            role: 'user',
            emailVerified: true,
          ),
        ),
        serviceCatalogProvider.overrideWith(
          (ref) async => PwaService.sampleCatalog,
        ),
      ],
    );
    await tester.pumpAndSettle();

    expect(find.text('Ada Lovelace'), findsOneWidget);
    expect(find.text('Your services'), findsOneWidget);
    expect(find.text('WorkDesk'), findsOneWidget);
  });
}
