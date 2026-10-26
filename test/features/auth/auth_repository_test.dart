import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/auth/token_store.dart';
import 'package:mobile_app/core/network/api_exception.dart';
import 'package:mobile_app/core/storage/snapshot_cache.dart';
import 'package:mobile_app/features/auth/data/auth_repository.dart';

import '../../helpers/fake_api.dart';

void main() {
  final now = DateTime.utc(2026, 10, 27, 10);
  late FakeApi api;
  late MemoryTokenStore store;
  late MemorySnapshotCache cache;
  late AuthRepository repository;

  const signedIn = FakeReply(200, {
    'access_token': 'a1',
    'refresh_token': 'r1',
    'expires_in': 3600,
  });

  setUp(() {
    store = MemoryTokenStore();
    cache = MemorySnapshotCache()..entries['workspace.x'] = {'a': 1};
    api = FakeApi({
      'POST /api/v1/auth/login': (request) =>
          (request.data as Map)['email'] == 'mfa@example.com'
          ? const FakeReply(200, {'mfa_required': true, 'mfa_token': 'm1'})
          : (request.data as Map)['password'] == 'right password'
          ? signedIn
          : FakeReply(
              401,
              error('INVALID_CREDENTIALS', 'That email and password is wrong.'),
            ),
      'POST /api/v1/auth/mfa/verify': (request) =>
          (request.data as Map)['code'] == '123456' ||
              (request.data as Map)['recovery_code'] == 'abcde12345'
          ? signedIn
          : FakeReply(401, error('INVALID_CODE', 'That code is not correct.')),
      'POST /api/v1/auth/google': (_) => signedIn,
      'POST /api/v1/auth/logout': (_) => const FakeReply(200, {'ok': true}),
    });
    repository = AuthRepository(fakeDio(api), store, cache, now: () => now);
  });

  test('password sign-in stores the SGS session', () async {
    final result = await repository.signIn(
      email: 'grace@example.com',
      password: 'right password',
    );
    expect(result, isA<SignInComplete>());
    final saved = (await store.read())!;
    expect(saved.accessToken, 'a1');
    expect(saved.refreshToken, 'r1');
    expect(saved.accessExpiresAt, now.add(const Duration(hours: 1)));
  });

  test('wrong credentials surface the API message and store nothing', () async {
    await expectLater(
      repository.signIn(email: 'grace@example.com', password: 'nope'),
      throwsA(
        isA<ApiException>().having(
          (e) => e.code,
          'code',
          'INVALID_CREDENTIALS',
        ),
      ),
    );
    expect(await store.read(), isNull);
  });

  test(
    'MFA accounts return a challenge, then accept TOTP or recovery codes',
    () async {
      final result = await repository.signIn(
        email: 'mfa@example.com',
        password: 'right password',
      );
      expect(result, isA<SignInNeedsMfa>());
      expect(await store.read(), isNull);

      await expectLater(
        repository.verifyMfa(mfaToken: 'm1', code: '000000'),
        throwsA(isA<ApiException>()),
      );
      await repository.verifyMfa(
        mfaToken: 'm1',
        code: 'ABCDE 12345'.toLowerCase(),
      );
      expect(api.called('POST', '/api/v1/auth/mfa/verify').last.data, {
        'mfa_token': 'm1',
        'recovery_code': 'abcde12345',
      });
      expect((await store.read())!.accessToken, 'a1');
    },
  );

  test('provider tokens are exchanged at the matching endpoint', () async {
    await repository.signInWithIdToken(
      provider: IdentityProvider.google,
      idToken: 'header.payload.sig',
      nonce: 'n1',
    );
    expect(api.called('POST', '/api/v1/auth/google').single.data, {
      'id_token': 'header.payload.sig',
      'nonce': 'n1',
    });
  });

  test('sign-out revokes on the server and wipes tokens and cache', () async {
    await store.write(
      AuthTokens(accessToken: 'a1', refreshToken: 'r1', accessExpiresAt: now),
    );
    await repository.signOut();
    expect(api.called('POST', '/api/v1/auth/logout').single.data, {
      'refresh_token': 'r1',
    });
    expect(await store.read(), isNull);
    expect(cache.entries, isEmpty);
  });
}
