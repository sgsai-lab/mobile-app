sealed class AuthState {
  const AuthState();
}

/// Startup: the stored session has not been checked yet.
final class AuthUnknown extends AuthState {
  const AuthUnknown();
}

final class AuthSignedOut extends AuthState {
  const AuthSignedOut({this.message});

  /// User-facing reason, e.g. a failed sign-in or an expired session.
  final String? message;
}

final class AuthSigningIn extends AuthState {
  const AuthSigningIn();
}

final class AuthMfaRequired extends AuthState {
  const AuthMfaRequired({required this.mfaToken, required this.methods});

  final String mfaToken;
  final List<String> methods;
}

final class AuthSignedIn extends AuthState {
  const AuthSignedIn();
}
