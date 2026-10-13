import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/app/theme/design_tokens.dart';
import 'package:mobile_app/core/network/connectivity_provider.dart';

class ConnectivityBanner extends ConsumerWidget {
  const ConnectivityBanner({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOffline =
        ref.watch(connectivityStatusProvider).asData?.value == false;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        if (isOffline)
          Material(
            color: scheme.errorContainer,
            child: SafeArea(
              bottom: false,
              child: Semantics(
                container: true,
                liveRegion: true,
                label: "You're offline. Check your network connection.",
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.wifi_off, color: scheme.onErrorContainer),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          "You're offline. Check your connection.",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: scheme.onErrorContainer),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        Expanded(child: child),
      ],
    );
  }
}
