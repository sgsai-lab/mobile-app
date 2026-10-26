abstract final class AppRoutes {
  static const String startup = '/startup';
  static const String signIn = '/sign-in';
  static const String home = '/';
  static const String designSystem = '/dev/design-system';
  static const String openServicePath = '/open-service/:serviceId';

  static String openService(String serviceId) =>
      '/open-service/${Uri.encodeComponent(serviceId)}';

  static String signInForService(String serviceId) =>
      Uri(path: signIn, queryParameters: {'serviceId': serviceId}).toString();
}
