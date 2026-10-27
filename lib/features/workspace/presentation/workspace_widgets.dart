import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/app/theme/design_tokens.dart';
import 'package:mobile_app/core/network/api_exception.dart';
import 'package:mobile_app/features/workspace/domain/workspace_models.dart';
import 'package:mobile_app/features/workspace/presentation/app_launcher.dart';
import 'package:mobile_app/features/workspace/presentation/workspace_providers.dart';

String initialsOf(String name) => name
    .split(RegExp(r'\s+'))
    .where((part) => part.isNotEmpty)
    .take(2)
    .map((part) => part[0].toUpperCase())
    .join();

String formatDay(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.sm),
    child: Semantics(
      header: true,
      child: Text(text, style: Theme.of(context).textTheme.titleLarge),
    ),
  );
}

class StatusChip extends StatelessWidget {
  const StatusChip(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.sm,
      vertical: AppSpacing.xs / 2,
    ),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.secondaryContainer,
      borderRadius: AppRadius.card,
    ),
    child: Text(label, style: Theme.of(context).textTheme.labelSmall),
  );
}

/// Signed image with a text fallback; the URL is short-lived and refetched.
class AssetAvatar extends ConsumerWidget {
  const AssetAvatar({
    required this.label,
    this.assetId,
    this.size = 48,
    this.enabled = true,
    super.key,
  });

  final String label;
  final String? assetId;
  final double size;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final fallback = Text(
      initialsOf(label),
      style: TextStyle(color: scheme.onPrimary, fontWeight: FontWeight.w700),
    );
    final id = assetId;
    final url = id == null || !enabled ? null : ref.watch(assetUrlProvider(id));
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: scheme.primary,
          borderRadius: AppRadius.card,
        ),
        child:
            url?.whenOrNull(
              data: (uri) => Image.network(
                uri.toString(),
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => fallback,
              ),
            ) ??
            fallback,
      ),
    );
  }
}

class AppTile extends ConsumerWidget {
  const AppTile({required this.product, this.offline = false, super.key});

  final Product product;
  final bool offline;

  Future<void> _open(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    if (offline) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('You are offline. Try again once connected.'),
        ),
      );
      return;
    }
    try {
      await ref.read(appLauncherProvider).open(product);
    } on ApiException catch (error) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            error.statusCode == null && error.code == 'NETWORK_ERROR'
                ? 'You are offline. Try again once connected.'
                : error.message,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final retired = product.isRetired;
    return Semantics(
      button: !retired,
      enabled: !retired,
      label: retired
          ? '${product.name}, retired'
          : 'Open ${product.name}, ${product.kind.label}',
      excludeSemantics: true,
      child: Card(
        child: InkWell(
          borderRadius: AppRadius.card,
          onTap: retired ? null : () => _open(context, ref),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 72),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Opacity(
                opacity: retired ? 0.5 : 1,
                child: Row(
                  children: [
                    AssetAvatar(
                      label: product.name,
                      assetId: product.iconAssetId,
                      enabled: !offline,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name, style: textTheme.titleMedium),
                          if (product.summary != null)
                            Text(
                              product.summary!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodySmall,
                            ),
                          const SizedBox(height: AppSpacing.xs),
                          Wrap(
                            spacing: AppSpacing.xs,
                            children: [
                              StatusChip(product.status.label),
                              StatusChip(product.kind.label),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(retired ? Icons.block : Icons.open_in_new),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  const ProjectCard({required this.project, required this.onOpen, super.key});

  final Project project;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final next = project.nextMilestone;
    return Card(
      child: InkWell(
        borderRadius: AppRadius.card,
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  StatusChip(project.status.label),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      project.subtitle,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(project.name, style: textTheme.titleMedium),
              if (project.summary != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(project.summary!, style: textTheme.bodyMedium),
              ],
              if (next != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Next: ${next.title}'
                  '${next.due == null ? '' : ' · ${formatDay(next.due!)}'}',
                  style: textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class OfflineNotice extends StatelessWidget {
  const OfflineNotice({required this.savedAt, super.key});

  final DateTime savedAt;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            const Icon(Icons.cloud_off_outlined),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'You are offline. Showing your workspace as of '
                '${formatDay(savedAt.toLocal())}.',
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
