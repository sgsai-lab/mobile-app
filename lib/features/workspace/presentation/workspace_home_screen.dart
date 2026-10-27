import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app/app_routes.dart';
import 'package:mobile_app/app/theme/design_tokens.dart';
import 'package:mobile_app/core/network/api_exception.dart';
import 'package:mobile_app/features/auth/presentation/auth_controller.dart';
import 'package:mobile_app/features/workspace/domain/workspace_models.dart';
import 'package:mobile_app/features/workspace/presentation/app_launcher.dart';
import 'package:mobile_app/features/workspace/presentation/workspace_providers.dart';
import 'package:mobile_app/features/workspace/presentation/workspace_widgets.dart';
import 'package:mobile_app/shared/widgets/app_empty_view.dart';
import 'package:mobile_app/shared/widgets/app_error_view.dart';
import 'package:mobile_app/shared/widgets/app_loading_view.dart';

/// The launcher: pick an organisation, see its projects, open its apps.
class WorkspaceHomeScreen extends ConsumerWidget {
  const WorkspaceHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeControllerProvider);
    final title = home.valueOrNull?.snapshot?.client.name ?? 'SGS AI';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () =>
                ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
      body: SafeArea(
        child: home.when(
          skipLoadingOnReload: true,
          loading: () =>
              const AppLoadingView(message: 'Loading your workspace'),
          error: (error, _) => _Failure(error: error),
          data: (view) =>
              view.hasWorkspace ? _Workspace(view: view) : const _NoWorkspace(),
        ),
      ),
    );
  }
}

class _Failure extends ConsumerWidget {
  const _Failure({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (error is ApiException &&
        ((error as ApiException).statusCode == 403 ||
            (error as ApiException).statusCode == 404)) {
      return AppEmptyView(
        icon: Icons.lock_outline,
        title: 'No access',
        message:
            'You no longer have access to this workspace. '
            'Ask your administrator if this is unexpected.',
        actionLabel: 'Reload',
        onAction: () => ref.invalidate(homeControllerProvider),
      );
    }
    return AppErrorView(
      message: error is ApiException
          ? (error as ApiException).message
          : 'Your workspace could not be loaded.',
      onRetry: () => ref.invalidate(homeControllerProvider),
    );
  }
}

class _NoWorkspace extends ConsumerWidget {
  const _NoWorkspace();

  @override
  Widget build(BuildContext context, WidgetRef ref) => AppEmptyView(
    icon: Icons.mail_outline,
    title: 'No workspace yet',
    message:
        'When SGS AI Technology starts a project with your organisation, '
        'your administrator will invite you.',
    actionLabel: 'Contact SGS AI',
    onAction: () => ref.read(openUrlProvider)(
      Uri.parse('mailto:hello@sgsaitechnology.com'),
    ),
  );
}

class _Workspace extends ConsumerWidget {
  const _Workspace({required this.view});

  final HomeView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = view.snapshot!;
    final textTheme = Theme.of(context).textTheme;
    final apps = snapshot.products
        .where((product) => product.isListed)
        .toList();
    final client = snapshot.client;
    return RefreshIndicator(
      onRefresh: () => ref.read(homeControllerProvider.notifier).refresh(),
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          if (snapshot.offline) OfflineNotice(savedAt: snapshot.savedAt),
          Row(
            children: [
              AssetAvatar(
                label: client.name,
                assetId: client.logoAssetId,
                size: 56,
                enabled: !snapshot.offline,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(client.name, style: textTheme.headlineSmall),
                    Text(
                      [
                        client.sector?.label,
                        'You are ${client.role.label.toLowerCase()}',
                      ].whereType<String>().join(' · '),
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (view.workspaces.length > 1) ...[
            const SizedBox(height: AppSpacing.md),
            _Switcher(workspaces: view.workspaces, selected: client.id),
          ],
          const SectionTitle('Apps and services'),
          if (apps.isEmpty)
            const _Hint(
              'Your apps will appear here as soon as SGS AI Technology '
              'makes them available.',
            )
          else
            for (final product in apps)
              AppTile(product: product, offline: snapshot.offline),
          const SectionTitle('Projects'),
          if (snapshot.projects.isEmpty)
            const _Hint(
              'Your SGS AI Technology team will add your first project here.',
            )
          else
            for (final project in snapshot.projects)
              ProjectCard(
                project: project,
                onOpen: () => context.push(AppRoutes.project(project.id)),
              ),
          const SectionTitle('Team'),
          for (final member in snapshot.team)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(child: Text(initialsOf(member.fullName))),
              title: Text(member.fullName),
              subtitle: Text(member.role.label),
            ),
        ],
      ),
    );
  }
}

class _Switcher extends ConsumerWidget {
  const _Switcher({required this.workspaces, required this.selected});

  final List<Membership> workspaces;
  final String selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      DropdownButtonFormField<String>(
        initialValue: selected,
        isExpanded: true,
        decoration: const InputDecoration(labelText: 'Workspace'),
        items: [
          for (final workspace in workspaces)
            DropdownMenuItem(
              value: workspace.clientId,
              child: Text(
                workspace.clientName,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
        onChanged: (id) {
          if (id != null && id != selected) {
            ref.read(homeControllerProvider.notifier).switchTo(id);
          }
        },
      );
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
    child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
  );
}
