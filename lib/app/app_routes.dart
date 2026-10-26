abstract final class AppRoutes {
  static const String startup = '/startup';
  static const String signIn = '/sign-in';
  static const String home = '/';
  static const String designSystem = '/dev/design-system';
  static const String projectPath = '/project/:projectId';
  static const String launchPath = '/go/:slug';

  static String project(String id) => '/project/${Uri.encodeComponent(id)}';

  static String launch(String slug) => '/go/${Uri.encodeComponent(slug)}';

  /// Sign in, then continue to [from] (a deep link or the screen that needed
  /// a session).
  static String signInThen(String from) => from == home
      ? signIn
      : Uri(path: signIn, queryParameters: {'from': from}).toString();

  /// Accepts only in-app paths as a post-sign-in destination.
  static String safeReturn(String? from) =>
      from != null && from.startsWith('/') && !from.startsWith('//')
      ? from
      : home;

  /// Flavor-specific custom schemes (see android/app/build.gradle.kts).
  static const Set<String> customSchemes = {'sgsai', 'sgsai-dev', 'sgsai-stg'};

  /// `sgsai://go/{slug}` arrives with host `go`; map it to the in-app route.
  /// Universal/App Links (`https://.../go/{slug}`) already carry the path.
  static String? fromCustomScheme(Uri uri) {
    if (!customSchemes.contains(uri.scheme) || uri.host != 'go') return null;
    final slug = uri.pathSegments.firstOrNull;
    return slug == null ? home : launch(slug);
  }
}
