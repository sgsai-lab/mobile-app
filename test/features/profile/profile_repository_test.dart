import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/network/api_endpoints.dart';
import 'package:mobile_app/features/profile/data/profile_repository.dart';

void main() {
  test('fetches and maps the generated current-user response', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.test'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.resolve(
            Response<Map<String, dynamic>>(
              requestOptions: options,
              statusCode: 200,
              data: <String, dynamic>{
                'id': 'user-1',
                'email': 'dev@example.com',
                'full_name': 'Ada Lovelace',
                'avatar_url': null,
                'role': 'user',
                'status': 'active',
                'email_verified': true,
                'mfa_enabled': false,
                'created_at': '2026-01-01T00:00:00Z',
                'last_login_at': null,
              },
            ),
          );
        },
      ),
    );

    final profile = await ProfileRepository(dio).fetchCurrentUser();

    expect(profile.id, 'user-1');
    expect(profile.fullName, 'Ada Lovelace');
    expect(profile.emailVerified, isTrue);
    expect(profile.initials, 'AL');
  });

  test('requests the token-derived current-user endpoint', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.test'));
    String? requestedPath;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          requestedPath = options.path;
          handler.resolve(
            Response<Map<String, dynamic>>(
              requestOptions: options,
              statusCode: 200,
              data: <String, dynamic>{
                'id': 'user-1',
                'email': 'dev@example.com',
                'full_name': 'Ada Lovelace',
                'avatar_url': null,
                'role': 'user',
                'status': 'active',
                'email_verified': true,
                'mfa_enabled': false,
                'created_at': '2026-01-01T00:00:00Z',
                'last_login_at': null,
              },
            ),
          );
        },
      ),
    );

    await ProfileRepository(dio).fetchCurrentUser();

    expect(requestedPath, ApiEndpoints.me);
  });
}
