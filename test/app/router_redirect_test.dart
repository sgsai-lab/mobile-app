import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/app_routes.dart';
import 'package:mobile_app/app/router.dart';
import 'package:mobile_app/features/auth/presentation/auth_state.dart';

String? redirect(AuthState auth, String location) {
  final uri = Uri.parse(location);
  return appRedirect(
    auth: auth,
    uri: uri,
    matchedLocation: uri.path,
    devTools: false,
  );
}

void main() {
  test('a signed-out deep link goes through sign-in and comes back', () {
    final toSignIn = redirect(const AuthSignedOut(), '/go/learning-portal');
    expect(toSignIn, '/sign-in?from=%2Fgo%2Flearning-portal');
    expect(redirect(const AuthSignedIn(), toSignIn!), '/go/learning-portal');
  });

  test('cold start keeps the deep link while the session is checked', () {
    final waiting = redirect(const AuthUnknown(), '/project/p1');
    expect(waiting, '/startup?from=%2Fproject%2Fp1');
    expect(redirect(const AuthSignedIn(), waiting!), '/project/p1');
    expect(
      redirect(const AuthSignedOut(), waiting),
      '/sign-in?from=%2Fproject%2Fp1',
    );
  });

  test('only in-app paths are accepted as a return destination', () {
    expect(
      redirect(const AuthSignedIn(), '/sign-in?from=https://evil.example'),
      AppRoutes.home,
    );
    expect(
      redirect(const AuthSignedIn(), '/sign-in?from=//evil'),
      AppRoutes.home,
    );
  });

  test('the custom scheme maps to the launch route', () {
    expect(
      AppRoutes.fromCustomScheme(Uri.parse('sgsai://go/learning-portal')),
      '/go/learning-portal',
    );
    expect(
      AppRoutes.fromCustomScheme(Uri.parse('sgsai-dev://go/demo')),
      '/go/demo',
    );
    expect(AppRoutes.fromCustomScheme(Uri.parse('https://x/go/a')), isNull);
    expect(AppRoutes.fromCustomScheme(Uri.parse('other://go/a')), isNull);
  });

  test('signed-in users stay where they are; MFA is still signed out', () {
    expect(redirect(const AuthSignedIn(), '/'), isNull);
    expect(redirect(const AuthNeedsMfa(mfaToken: 'm'), '/'), AppRoutes.signIn);
    expect(redirect(const AuthSignedOut(), '/dev/design-system'), '/');
  });
}
