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

/// Password accepted; the account needs an authenticator or recovery code.
final class AuthNeedsMfa extends AuthState {
  const AuthNeedsMfa({required this.mfaToken, this.message, this.busy = false});

  final String mfaToken;
  final String? message;
  final bool busy;
}

final class AuthSignedIn extends AuthState {
  const AuthSignedIn();
}
