/// SGS API routes served by sgsai-lab/home (ADR-002). Keep every path here so
/// a contract change is one diff. Reference: home docs/api.md.
abstract final class ApiEndpoints {
  static const String login = '/api/v1/auth/login';
  static const String google = '/api/v1/auth/google';
  static const String apple = '/api/v1/auth/apple';
  static const String mfaVerify = '/api/v1/auth/mfa/verify';
  static const String refresh = '/api/v1/auth/token/refresh';
  static const String logout = '/api/v1/auth/logout';
  static const String me = '/api/v1/users/me';
  static const String clients = '/api/v1/clients';
  static const String projects = '/api/v1/projects';
  static const String products = '/api/v1/products';
  static const String assets = '/api/v1/assets';

  static String client(String id) => '$clients/${Uri.encodeComponent(id)}';
  static String members(String clientId) => '${client(clientId)}/members';
  static String project(String id) => '$projects/${Uri.encodeComponent(id)}';
  static String productBySlug(String slug) =>
      '$products/by-slug/${Uri.encodeComponent(slug)}';
  static String launchToken(String productId) =>
      '$products/${Uri.encodeComponent(productId)}/launch-token';
  static String assetUrl(String id) => '$assets/${Uri.encodeComponent(id)}/url';
}
