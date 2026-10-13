import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/app/theme/design_tokens.dart';
import 'package:mobile_app/core/network/api_exception.dart';
import 'package:mobile_app/features/auth/presentation/auth_controller.dart';
import 'package:mobile_app/features/profile/data/profile_repository.dart';
import 'package:mobile_app/features/profile/domain/user_profile.dart';
import 'package:mobile_app/shared/widgets/app_error_view.dart';

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
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(currentUserProvider.future),
        child: user.when(
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(
              semanticsLabel: 'Loading your profile',
            ),
          ),
          error: (error, _) => AppErrorView(
            message: error is ApiException
                ? error.message
                : 'Could not load your profile.',
            onRetry: () => ref.invalidate(currentUserProvider),
          ),
          data: (profile) => _ProfileCard(profile: profile),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(AppSpacing.lg),
    children: [
      Row(
        children: [
          CircleAvatar(radius: 28, child: Text(profile.initials)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.fullName.isEmpty ? 'Your profile' : profile.fullName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  profile.email,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.lg),
      if (!profile.emailVerified)
        const Card(
          child: ListTile(
            leading: Icon(Icons.mark_email_unread_outlined),
            title: Text('Verify your email'),
            subtitle: Text('Check your inbox to finish setting up.'),
          ),
        ),
    ],
  );
}
