import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/config/app_config.dart';

/// Firebase Auth persists and refreshes its own ID tokens on the native SDK.
final firebaseAuthProvider = Provider<FirebaseAuth?>((ref) {
  if (!ref.watch(appConfigProvider).firebaseEnabled) return null;
  return FirebaseAuth.instance;
});
