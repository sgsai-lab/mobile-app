import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/app/connectivity_banner.dart';
import 'package:mobile_app/app/router.dart';
import 'package:mobile_app/app/theme/app_theme.dart';
import 'package:mobile_app/core/config/app_config.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    return MaterialApp.router(
      title: config.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) => ConnectivityBanner(
        child: config.isProd
            ? child ?? const SizedBox.shrink()
            : Banner(
                message: config.flavor.key.toUpperCase(),
                location: BannerLocation.topEnd,
                child: child ?? const SizedBox.shrink(),
              ),
      ),
    );
  }
}
