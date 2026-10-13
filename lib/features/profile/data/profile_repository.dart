import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/network/api_client.dart';
import 'package:mobile_app/core/network/api_endpoints.dart';
import 'package:mobile_app/core/network/api_exception.dart';
import 'package:mobile_app/core/network/generated/backend.models.swagger.dart'
    as api_models;
import 'package:mobile_app/features/profile/domain/user_profile.dart';

class ProfileRepository {
  const ProfileRepository(this._dio);

  final Dio _dio;

  /// The profile always comes from the token-derived identity on the server;
  /// the client never sends a user id.
  Future<UserProfile> fetchCurrentUser() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.me);
      final profile = api_models.UserRead.fromJson(
        response.data ?? const <String, dynamic>{},
      );
      return UserProfile.fromJson(profile.toJson());
    } on DioException catch (error) {
      throw ApiException.fromDioException(error);
    }
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.watch(dioProvider)),
);

final currentUserProvider = FutureProvider<UserProfile>(
  (ref) => ref.watch(profileRepositoryProvider).fetchCurrentUser(),
);
