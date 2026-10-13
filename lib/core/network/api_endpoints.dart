/// Backend routes. Keep every path here so a contract change is one diff.
abstract final class ApiEndpoints {
  static const String firebaseSignIn = '/api/v1/auth/firebase';
  static const String login = '/api/v1/auth/login';
  static const String refresh = '/api/v1/auth/token/refresh';
  static const String logout = '/api/v1/auth/logout';
  static const String register = '/api/v1/auth/register';
  static const String me = '/api/v1/users/me';
}
