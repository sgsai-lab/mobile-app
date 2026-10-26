import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app/app_routes.dart';
import 'package:mobile_app/core/network/api_exception.dart';
import 'package:mobile_app/features/workspace/data/workspace_repository.dart';
import 'package:mobile_app/features/workspace/presentation/app_launcher.dart';
import 'package:mobile_app/shared/widgets/app_empty_view.dart';
import 'package:mobile_app/shared/widgets/app_error_view.dart';
import 'package:mobile_app/shared/widgets/app_loading_view.dart';

/// Opens `https://www.sgsaitechnology.com/go/{slug}` links (App Links,
/// Universal Links and `sgsai://go/{slug}`): checks membership, then hands the
/// app a fresh launch token so the visit is counted and authorised.
final _launchBySlugProvider = FutureProvider.autoDispose.family<String, String>(
  (ref, slug) async {
    final product = await ref
        .watch(workspaceRepositoryProvider)
        .productBySlug(slug);
    await ref.read(appLauncherProvider).open(product);
    return product.name;
  },
);

class LaunchRedirectScreen extends ConsumerWidget {
  const LaunchRedirectScreen({required this.slug, super.key});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final valid = RegExp(r'^[a-z0-9-]{1,60}$').hasMatch(slug);
    final launch = valid ? ref.watch(_launchBySlugProvider(slug)) : null;
    ref.listen(_launchBySlugProvider(slug), (_, next) {
      if (next.hasValue && context.mounted) {
        unawaited(
          Future<void>.delayed(const Duration(milliseconds: 300), () {
            if (context.mounted) context.go(AppRoutes.home);
          }),
        );
      }
    });
    return Scaffold(
      appBar: AppBar(title: const Text('Opening app')),
      body: SafeArea(
        child: launch == null
            ? const AppEmptyView(
                icon: Icons.link_off,
                title: 'Link not valid',
                message: 'This app link is not valid.',
              )
            : launch.when(
                loading: () =>
                    const AppLoadingView(message: 'Opening your app'),
                data: (name) => AppLoadingView(message: 'Opened $name'),
                error: (error, _) =>
                    error is ApiException &&
                        (error.statusCode == 403 || error.statusCode == 404)
                    ? AppEmptyView(
                        icon: Icons.lock_outline,
                        title: 'No access',
                        message:
                            'You do not have access to this app. Ask your '
                            'workspace administrator to invite you.',
                        actionLabel: 'Go to my workspace',
                        onAction: () => context.go(AppRoutes.home),
                      )
                    : AppErrorView(
                        message: error is ApiException
                            ? error.message
                            : 'This app could not be opened.',
                        onRetry: () =>
                            ref.invalidate(_launchBySlugProvider(slug)),
                      ),
              ),
      ),
    );
  }
}
