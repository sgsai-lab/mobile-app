import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app/app_routes.dart';
import 'package:mobile_app/app/design_system_gallery_screen.dart';
import 'package:mobile_app/app/startup_screen.dart';
import 'package:mobile_app/core/config/app_config.dart';
import 'package:mobile_app/features/auth/presentation/auth_controller.dart';
import 'package:mobile_app/features/auth/presentation/auth_state.dart';
import 'package:mobile_app/features/auth/presentation/sign_in_screen.dart';
import 'package:mobile_app/features/profile/presentation/home_screen.dart';
import 'package:mobile_app/features/services/presentation/service_launch_screen.dart';
import 'package:mobile_app/shared/widgets/app_error_view.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // go_router needs a Listenable; this bridges the Riverpod auth state to it.
  final authListenable = ValueNotifier<AuthState>(
    ref.read(authControllerProvider),
  );
  ref
    ..listen<AuthState>(
      authControllerProvider,
      (_, next) => authListenable.value = next,
    )
    ..onDispose(authListenable.dispose);

  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: authListenable,
    errorBuilder: (context, state) => Scaffold(
      body: AppErrorView(
        message: 'This screen could not be opened.',
        onRetry: () => context.go(AppRoutes.startup),
      ),
    ),
    redirect: (context, state) {
      if (state.matchedLocation == AppRoutes.designSystem) {
        return ref.read(appConfigProvider).flavor == Flavor.dev
            ? null
            : AppRoutes.home;
      }
      final auth = authListenable.value;
      final location = state.matchedLocation;

      if (auth is AuthUnknown) {
        return null;
      }
      if (auth is AuthSignedIn) {
        if (location == AppRoutes.signIn || location == AppRoutes.startup) {
          final serviceId = state.uri.queryParameters['serviceId'];
          return serviceId == null
              ? AppRoutes.home
              : AppRoutes.openService(serviceId);
        }
        return null;
      }
      if (state.pathParameters.containsKey('serviceId')) {
        final serviceId = state.pathParameters['serviceId'];
        return serviceId == null
            ? AppRoutes.home
            : AppRoutes.signInForService(serviceId);
      }
      if (location == AppRoutes.startup) return AppRoutes.home;
      if (location == AppRoutes.signIn || location == AppRoutes.home) {
        return null;
      }
      return AppRoutes.home;
    },
    routes: [
      GoRoute(
        path: AppRoutes.startup,
        builder: (context, state) => const StartupScreen(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.openServicePath,
        builder: (context, state) => ServiceLaunchScreen(
          serviceId: state.pathParameters['serviceId'] ?? '',
        ),
      ),
      GoRoute(
        path: AppRoutes.designSystem,
        builder: (context, state) => const DesignSystemGalleryScreen(),
      ),
    ],
  );
});
