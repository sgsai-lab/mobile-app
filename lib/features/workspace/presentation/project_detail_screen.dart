import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/app/theme/design_tokens.dart';
import 'package:mobile_app/core/network/api_exception.dart';
import 'package:mobile_app/features/workspace/domain/workspace_models.dart';
import 'package:mobile_app/features/workspace/presentation/app_launcher.dart';
import 'package:mobile_app/features/workspace/presentation/workspace_providers.dart';
import 'package:mobile_app/features/workspace/presentation/workspace_widgets.dart';
import 'package:mobile_app/shared/widgets/app_empty_view.dart';
import 'package:mobile_app/shared/widgets/app_error_view.dart';
import 'package:mobile_app/shared/widgets/app_loading_view.dart';

class ProjectDetailScreen extends ConsumerWidget {
  const ProjectDetailScreen({required this.projectId, this.today, super.key});

  final String projectId;

  /// Injectable for tests; defaults to the current date.
  final DateTime? today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(projectDetailProvider(projectId));
    return Scaffold(
      appBar: AppBar(
        title: Text(detail.valueOrNull?.project.name ?? 'Project'),
      ),
      body: SafeArea(
        child: detail.when(
          loading: () => const AppLoadingView(message: 'Loading project'),
          error: (error, _) =>
              error is ApiException &&
                  (error.statusCode == 403 || error.statusCode == 404)
              ? const AppEmptyView(
                  icon: Icons.lock_outline,
                  title: 'Project unavailable',
                  message:
                      'This project was not found, '
                      'or you no longer have access.',
                )
              : AppErrorView(
                  message: error is ApiException
                      ? error.message
                      : 'This project could not be loaded.',
                  onRetry: () =>
                      ref.invalidate(projectDetailProvider(projectId)),
                ),
          data: (data) => _Detail(detail: data, today: today ?? DateTime.now()),
        ),
      ),
    );
  }
}

class _Detail extends ConsumerWidget {
  const _Detail({required this.detail, required this.today});

  final ProjectDetail detail;
  final DateTime today;

  Future<void> _download(
    BuildContext context,
    WidgetRef ref,
    Deliverable file,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(appLauncherProvider).openAsset(file.id);
    } on ApiException catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = detail.project;
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final dates = [
      if (project.startDate != null) 'Started ${formatDay(project.startDate!)}',
      if (project.endDate != null) 'Target ${formatDay(project.endDate!)}',
    ].join(' · ');
    return RefreshIndicator(
      onRefresh: () => ref.refresh(projectDetailProvider(project.id).future),
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          if (project.coverAssetId != null)
            ClipRRect(
              borderRadius: AppRadius.card,
              child: AspectRatio(
                aspectRatio: 16 / 7,
                child:
                    ref
                        .watch(assetUrlProvider(project.coverAssetId!))
                        .whenOrNull(
                          data: (url) => Image.network(
                            url.toString(),
                            fit: BoxFit.cover,
                            excludeFromSemantics: true,
                            errorBuilder: (_, _, _) => const SizedBox.shrink(),
                          ),
                        ) ??
                    const SizedBox.shrink(),
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          Text(project.subtitle, style: textTheme.labelLarge),
          Text(project.name, style: textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.sm,
            children: [StatusChip(project.status.label)],
          ),
          if (dates.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(dates, style: textTheme.bodySmall),
          ],
          if (project.summary != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(project.summary!),
          ],
          const SectionTitle('Milestones'),
          if (project.milestones.isEmpty) const Text('No milestones yet.'),
          for (final milestone in project.milestones)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                milestone.done
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: milestone.done ? scheme.primary : null,
                semanticLabel: milestone.done ? 'Done' : 'Not done',
              ),
              title: Text(
                milestone.title,
                style: milestone.done
                    ? const TextStyle(decoration: TextDecoration.lineThrough)
                    : null,
              ),
              trailing: milestone.due == null
                  ? null
                  : Text(
                      milestone.isOverdue(today)
                          ? 'Overdue · ${formatDay(milestone.due!)}'
                          : formatDay(milestone.due!),
                      style: milestone.isOverdue(today)
                          ? TextStyle(
                              color: scheme.error,
                              fontWeight: FontWeight.w600,
                            )
                          : textTheme.bodySmall,
                    ),
            ),
          const SectionTitle('Apps from this project'),
          if (detail.products.where((p) => p.isListed).isEmpty)
            const Text('No apps are linked to this project yet.'),
          for (final product in detail.products.where((p) => p.isListed))
            AppTile(product: product),
          const SectionTitle('Deliverables'),
          if (detail.deliverables.isEmpty)
            const Text(
              'Deliverables shared by SGS AI Technology will appear here.',
            ),
          for (final file in detail.deliverables)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(switch (file.kind) {
                'image' => Icons.image_outlined,
                'video' => Icons.movie_outlined,
                _ => Icons.description_outlined,
              }),
              title: Text(file.filename),
              subtitle: Text(
                '${(file.sizeBytes / 1024 / 1024).toStringAsFixed(1)} MB',
              ),
              trailing: IconButton(
                tooltip: 'Open ${file.filename}',
                icon: const Icon(Icons.download_outlined),
                onPressed: () => _download(context, ref, file),
              ),
            ),
        ],
      ),
    );
  }
}
