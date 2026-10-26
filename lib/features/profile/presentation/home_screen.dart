import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app/app_routes.dart';
import 'package:mobile_app/features/auth/presentation/auth_controller.dart';
import 'package:mobile_app/features/auth/presentation/auth_state.dart';
import 'package:mobile_app/features/services/domain/pwa_service.dart';
import 'package:mobile_app/features/services/presentation/service_catalog_view.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SGS AI'),
        actions: [
          if (auth is AuthSignedIn)
            IconButton(
              tooltip: 'Sign out',
              icon: const Icon(Icons.logout),
              onPressed: () =>
                  ref.read(authControllerProvider.notifier).signOut(),
            )
          else
            TextButton(
              onPressed: () => context.go(AppRoutes.signIn),
              child: const Text('Sign in'),
            ),
        ],
      ),
      body: ServiceCatalogView(
        onOpen: (service) {
          if (auth is AuthSignedIn) {
            unawaited(_openService(context, service));
          } else {
            context.go(AppRoutes.signInForService(service.id));
          }
        },
      ),
    );
  }

  Future<void> _openService(BuildContext context, PwaService service) async {
    final opened = await launchUrl(
      Uri.parse(service.url),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open this service.')),
      );
    }
  }
}
