class AuthTokens {
  const AuthTokens({
    required this.accessToken,
    required this.expiresIn,
    this.refreshToken,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) => AuthTokens(
    accessToken: json['access_token'] as String,
    expiresIn: json['expires_in'] as int? ?? 0,
    refreshToken: json['refresh_token'] as String?,
  );

  final String accessToken;
  final int expiresIn;
  final String? refreshToken;
}

/// The backend answers `/auth/login` with either tokens or an MFA challenge.
sealed class SignInResult {
  const SignInResult();
}

final class SignInSucceeded extends SignInResult {
  const SignInSucceeded(this.tokens);

  final AuthTokens tokens;
}

final class SignInNeedsMfa extends SignInResult {
  const SignInNeedsMfa({required this.mfaToken, required this.methods});

  final String mfaToken;
  final List<String> methods;
}
