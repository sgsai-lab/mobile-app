import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app/app_routes.dart';
import 'package:mobile_app/app/theme/design_tokens.dart';
import 'package:mobile_app/core/network/api_exception.dart';
import 'package:mobile_app/features/auth/presentation/auth_controller.dart';
import 'package:mobile_app/features/auth/presentation/auth_state.dart';
import 'package:mobile_app/features/services/data/service_catalog_repository.dart';
import 'package:mobile_app/features/services/domain/pwa_service.dart';
import 'package:mobile_app/shared/widgets/app_empty_view.dart';
import 'package:mobile_app/shared/widgets/app_error_view.dart';
import 'package:mobile_app/shared/widgets/app_loading_view.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceLaunchScreen extends ConsumerWidget {
  const ServiceLaunchScreen({required this.serviceId, super.key});

  final String serviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    if (auth is AuthUnknown || auth is AuthSigningIn) {
      return const Scaffold(
        body: AppLoadingView(message: 'Checking your sign-in'),
      );
    }
    if (auth is! AuthSignedIn) {
      return const Scaffold(
        body: AppErrorView(message: 'Sign in to open this service.'),
      );
    }

    final catalog = ref.watch(serviceCatalogProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back to services',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.home),
        ),
        title: const Text('Open service'),
      ),
      body: catalog.when(
        loading: () => const AppLoadingView(message: 'Loading service'),
        error: (error, _) => AppErrorView(
          message: error is ApiException
              ? error.message
              : 'This service could not be loaded.',
          onRetry: () => ref.invalidate(serviceCatalogProvider),
        ),
        data: (services) {
          PwaService? selected;
          for (final service in services) {
            if (service.id == serviceId) {
              selected = service;
              break;
            }
          }
          if (selected == null) {
            return const AppEmptyView(
              title: 'Service unavailable',
              message: 'This service is no longer in your directory.',
            );
          }
          return _ServiceConfirmation(service: selected);
        },
      ),
    );
  }
}

class _ServiceConfirmation extends StatelessWidget {
  const _ServiceConfirmation({required this.service});

  final PwaService service;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.open_in_new,
              size: 36,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              service.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(service.description, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: () => _open(context),
              icon: const Icon(Icons.open_in_new),
              label: Text('Open ${service.name}'),
            ),
          ],
        ),
      ),
    ),
  );

  Future<void> _open(BuildContext context) async {
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
