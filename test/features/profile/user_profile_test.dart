import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/profile/domain/user_profile.dart';

void main() {
  group('UserProfile.fromJson', () {
    test('maps the backend snake_case contract', () {
      final profile = UserProfile.fromJson(const <String, dynamic>{
        'id': '7f9f5d1e-0000-4000-8000-000000000000',
        'email': 'dev@example.com',
        'full_name': 'Ada Lovelace',
        'role': 'user',
        'email_verified': true,
        'avatar_url': null,
      });

      expect(profile.fullName, 'Ada Lovelace');
      expect(profile.emailVerified, isTrue);
      expect(profile.avatarUrl, isNull);
      expect(profile.initials, 'AL');
    });

    test('tolerates a missing name and falls back to the email initial', () {
      final profile = UserProfile.fromJson(const <String, dynamic>{
        'id': 'id',
        'email': 'dev@example.com',
      });

      expect(profile.initials, 'D');
      expect(profile.emailVerified, isFalse);
    });
  });
}
