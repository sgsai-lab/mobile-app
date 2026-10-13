import 'package:flutter/material.dart';

/// Shown while the stored session is restored. Keep it cheap: it is the first
/// frame after the native splash.
class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(
      child: CircularProgressIndicator.adaptive(
        semanticsLabel: 'Starting the app',
      ),
    ),
  );
}
