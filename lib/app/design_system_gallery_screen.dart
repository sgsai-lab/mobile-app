import 'package:flutter/material.dart';
import 'package:mobile_app/app/theme/app_theme.dart';
import 'package:mobile_app/app/theme/design_tokens.dart';
import 'package:mobile_app/shared/widgets/app_empty_view.dart';
import 'package:mobile_app/shared/widgets/app_error_view.dart';
import 'package:mobile_app/shared/widgets/app_loading_view.dart';

class DesignSystemGalleryScreen extends StatelessWidget {
  const DesignSystemGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Design system')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'SGS AI components',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.md),
          _ThemePreview(theme: AppTheme.light(), label: 'Light theme'),
          const SizedBox(height: AppSpacing.md),
          _ThemePreview(theme: AppTheme.dark(), label: 'Dark theme'),
        ],
      ),
    ),
  );
}

class _ThemePreview extends StatelessWidget {
  const _ThemePreview({required this.theme, required this.label});

  final ThemeData theme;
  final String label;

  @override
  Widget build(BuildContext context) => Theme(
    data: theme,
    child: Builder(
      builder: (context) => DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: AppRadius.card,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(label, style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              Text('Typography', style: theme.textTheme.titleMedium),
              Text('Manrope display', style: theme.textTheme.headlineSmall),
              const Text('DM Sans body text and supporting copy.'),
              const SizedBox(height: AppSpacing.md),
              Text('Color tokens', style: theme.textTheme.titleMedium),
              const Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _ColorSwatch(label: 'Purple', color: AppColors.purple),
                  _ColorSwatch(label: 'Cyan', color: AppColors.blue),
                  _ColorSwatch(label: 'Green', color: AppColors.green),
                  _ColorSwatch(label: 'Orange', color: AppColors.orange),
                  _ColorSwatch(label: 'Line', color: AppColors.line),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Actions', style: theme.textTheme.titleMedium),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.check),
                    label: const Text('Primary'),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('Secondary'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Text action'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Input', style: theme.textTheme.titleMedium),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Email address',
                  hintText: 'name@example.com',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('States', style: theme.textTheme.titleMedium),
              const AppEmptyView(
                title: 'Empty state',
                message: 'Your items will appear here.',
              ),
              const AppLoadingView(message: 'Loading example'),
              const SizedBox(height: AppSpacing.md),
              const AppErrorView(
                message: 'Could not load this section.',
                onRetry: _noop,
              ),
            ],
          ),
        ),
      ),
    ),
  );

  static void _noop() {}
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '$label color',
    child: Container(
      width: 68,
      height: 48,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color.computeLuminance() > 0.18
              ? AppColors.ink
              : AppColors.white,
        ),
      ),
    ),
  );
}
