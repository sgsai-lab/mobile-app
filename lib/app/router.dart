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
import 'package:mobile_app/features/workspace/presentation/launch_redirect_screen.dart';
import 'package:mobile_app/features/workspace/presentation/project_detail_screen.dart';
import 'package:mobile_app/features/workspace/presentation/workspace_home_screen.dart';
import 'package:mobile_app/shared/widgets/app_error_view.dart';

/// Pure redirect rules, unit-tested in test/app/router_redirect_test.dart.
String? appRedirect({
  required AuthState auth,
  required Uri uri,
  required String matchedLocation,
  required bool devTools,
}) {
  final custom = AppRoutes.fromCustomScheme(uri);
  if (custom != null) return custom;
  if (matchedLocation == AppRoutes.designSystem) {
    return devTools ? null : AppRoutes.home;
  }
  // While the stored session is checked, show the startup screen and keep the
  // requested location so deep links are not lost.
  if (auth is AuthUnknown) {
    return matchedLocation == AppRoutes.startup
        ? null
        : Uri(
            path: AppRoutes.startup,
            queryParameters: {'from': uri.toString()},
          ).toString();
  }
  final from = AppRoutes.safeReturn(uri.queryParameters['from']);
  if (auth is AuthSignedIn) {
    return matchedLocation == AppRoutes.signIn ||
            matchedLocation == AppRoutes.startup
        ? from
        : null;
  }
  if (matchedLocation == AppRoutes.signIn) return null;
  // Signed out (or mid sign-in / MFA): every other screen needs a session.
  final destination = matchedLocation == AppRoutes.startup
      ? from
      : uri.toString();
  return AppRoutes.signInThen(destination);
}

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
        onRetry: () => context.go(AppRoutes.home),
      ),
    ),
    redirect: (context, state) => appRedirect(
      auth: authListenable.value,
      uri: state.uri,
      matchedLocation: state.matchedLocation,
      devTools: ref.read(appConfigProvider).flavor == Flavor.dev,
    ),
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
        builder: (context, state) => const WorkspaceHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.projectPath,
        builder: (context, state) => ProjectDetailScreen(
          projectId: state.pathParameters['projectId'] ?? '',
        ),
      ),
      GoRoute(
        path: AppRoutes.launchPath,
        builder: (context, state) =>
            LaunchRedirectScreen(slug: state.pathParameters['slug'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.designSystem,
        builder: (context, state) => const DesignSystemGalleryScreen(),
      ),
    ],
  );
});
