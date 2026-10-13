import 'package:flutter/material.dart';
import 'package:mobile_app/app/theme/design_tokens.dart';

class AppLoadingView extends StatelessWidget {
  const AppLoadingView({this.message = 'Loading', super.key});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator.adaptive(semanticsLabel: message),
          const SizedBox(height: AppSpacing.md),
          Text(message),
        ],
      ),
    ),
  );
}
