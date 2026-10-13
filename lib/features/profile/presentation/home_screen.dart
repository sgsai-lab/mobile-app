import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/app/theme/design_tokens.dart';
import 'package:mobile_app/core/network/api_exception.dart';
import 'package:mobile_app/features/auth/presentation/auth_controller.dart';
import 'package:mobile_app/features/profile/data/profile_repository.dart';
import 'package:mobile_app/features/profile/domain/user_profile.dart';
import 'package:mobile_app/features/services/presentation/service_catalog_view.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () =>
                ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
      body: Column(
        children: [
          user.when(
            loading: () => Semantics(
              label: 'Loading your profile',
              child: const LinearProgressIndicator(),
            ),
            error: (error, _) => ListTile(
              title: Text(
                error is ApiException ? error.message : 'Profile unavailable.',
              ),
              trailing: IconButton(
                tooltip: 'Retry profile',
                icon: const Icon(Icons.refresh),
                onPressed: () => ref.invalidate(currentUserProvider),
              ),
            ),
            data: _ProfileHeader.new,
          ),
          const Expanded(child: ServiceCatalogView()),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader(this.profile);

  final UserProfile profile;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.md,
      AppSpacing.md,
      AppSpacing.md,
      AppSpacing.xs,
    ),
    child: Row(
      children: [
        CircleAvatar(radius: 20, child: Text(profile.initials)),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.fullName.isEmpty ? 'Your profile' : profile.fullName,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(profile.email, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        if (!profile.emailVerified)
          const Tooltip(
            message: 'Email not verified',
            child: Icon(Icons.mark_email_unread_outlined),
          ),
      ],
    ),
  );
}
