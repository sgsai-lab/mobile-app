import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/app/theme/design_tokens.dart';
import 'package:mobile_app/core/network/api_exception.dart';
import 'package:mobile_app/features/services/data/service_catalog_repository.dart';
import 'package:mobile_app/features/services/domain/pwa_service.dart';
import 'package:mobile_app/shared/widgets/app_empty_view.dart';
import 'package:mobile_app/shared/widgets/app_error_view.dart';
import 'package:mobile_app/shared/widgets/app_loading_view.dart';

class ServiceCatalogView extends ConsumerWidget {
  const ServiceCatalogView({required this.onOpen, super.key});

  final ValueChanged<PwaService> onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(serviceCatalogProvider);
    return services.when(
      loading: () => const AppLoadingView(message: 'Loading services'),
      error: (error, _) => AppErrorView(
        message: error is ApiException
            ? error.message
            : 'Services could not be loaded.',
        onRetry: () => ref.invalidate(serviceCatalogProvider),
      ),
      data: (items) => items.isEmpty
          ? const AppEmptyView(
              title: 'No services available',
              message: 'Available services will appear here.',
            )
          : RefreshIndicator(
              onRefresh: () async => ref.refresh(serviceCatalogProvider.future),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.xs,
                  AppSpacing.md,
                  AppSpacing.lg,
                ),
                children: [
                  Text(
                    'Your services',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...items.map(
                    (service) => _ServiceTile(service: service, onOpen: onOpen),
                  ),
                ],
              ),
            ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({required this.service, required this.onOpen});

  final PwaService service;
  final ValueChanged<PwaService> onOpen;

  @override
  Widget build(BuildContext context) {
    final color = switch (service.iconKey) {
      'work' => AppColors.purple,
      'learn' => AppColors.blue,
      'support' => AppColors.green,
      _ => AppColors.ink,
    };
    final icon = switch (service.iconKey) {
      'work' => Icons.work_outline,
      'learn' => Icons.school_outlined,
      'support' => Icons.support_agent_outlined,
      _ => Icons.grid_view_outlined,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.12),
              foregroundColor: color,
              child: Icon(icon, semanticLabel: service.name),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(service.description),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            IconButton.filledTonal(
              tooltip: 'Open ${service.name}',
              icon: const Icon(Icons.open_in_new),
              onPressed: () => onOpen(service),
            ),
          ],
        ),
      ),
    );
  }
}
