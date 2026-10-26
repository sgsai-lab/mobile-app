import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/auth/token_store.dart';
import 'package:mobile_app/core/network/auth_interceptor.dart';

import '../../helpers/fake_api.dart';

AuthTokens tokens(String suffix) => AuthTokens(
  accessToken: 'access-$suffix',
  refreshToken: 'refresh-$suffix',
  accessExpiresAt: DateTime(2030),
);

void main() {
  late FakeApi api;
  late MemoryTokenStore store;
  late int expired;
  late Dio dio;
  var meStatus = 200;

  setUp(() {
    expired = 0;
    meStatus = 200;
    store = MemoryTokenStore(tokens('1'));
    api = FakeApi({
      'GET /api/v1/users/me': (request) =>
          request.headers['Authorization'] == 'Bearer access-2'
          ? const FakeReply(200, {'id': 'u1'})
          : FakeReply(meStatus, error('UNAUTHORIZED', 'Sign in.')),
      'POST /api/v1/auth/token/refresh': (request) =>
          (request.data as Map)['refresh_token'] == 'refresh-1'
          ? const FakeReply(200, {
              'access_token': 'access-2',
              'refresh_token': 'refresh-2',
              'expires_in': 3600,
            })
          : FakeReply(401, error('UNAUTHORIZED', 'Expired.')),
    });
    final refreshClient = fakeDio(api);
    dio = fakeDio(api)
      ..interceptors.add(
        AuthInterceptor(
          tokenStore: store,
          refreshClient: refreshClient,
          onSessionExpired: () async => expired++,
        ),
      );
  });

  test('attaches the stored access token', () async {
    meStatus = 200;
    await store.write(tokens('2'));
    await dio.get<dynamic>('/api/v1/users/me');
    expect(api.requests.single.headers['Authorization'], 'Bearer access-2');
  });

  test(
    'on 401 rotates the refresh token once, stores it and retries',
    () async {
      meStatus = 401;
      final response = await dio.get<Map<String, dynamic>>('/api/v1/users/me');

      expect(response.data, {'id': 'u1'});
      expect(api.called('POST', '/api/v1/auth/token/refresh'), hasLength(1));
      final refreshRequest = api
          .called('POST', '/api/v1/auth/token/refresh')
          .single;
      expect(refreshRequest.headers.containsKey('Authorization'), isFalse);
      expect((await store.read())!.refreshToken, 'refresh-2');
      expect(expired, 0);
    },
  );

  test('a failed refresh clears the session and reports expiry', () async {
    meStatus = 401;
    await store.write(tokens('stale'));

    await expectLater(
      dio.get<dynamic>('/api/v1/users/me'),
      throwsA(isA<DioException>()),
    );
    expect(await store.read(), isNull);
    expect(expired, 1);
  });

  test('requests marked skipAuth never carry or refresh tokens', () async {
    meStatus = 401;
    await expectLater(
      dio.get<dynamic>(
        '/api/v1/users/me',
        options: Options(extra: {skipAuth: true}),
      ),
      throwsA(isA<DioException>()),
    );
    expect(api.requests.single.headers.containsKey('Authorization'), isFalse);
    expect(api.called('POST', '/api/v1/auth/token/refresh'), isEmpty);
  });
}
