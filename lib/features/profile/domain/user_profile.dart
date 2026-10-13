class UserProfile {
  const UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.emailVerified,
    this.avatarUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] as String,
    email: json['email'] as String,
    fullName: json['full_name'] as String? ?? '',
    role: json['role'] as String? ?? 'user',
    emailVerified: json['email_verified'] as bool? ?? false,
    avatarUrl: json['avatar_url'] as String?,
  );

  final String id;
  final String email;
  final String fullName;
  final String role;
  final bool emailVerified;
  final String? avatarUrl;

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'))
      ..removeWhere((part) => part.isEmpty);
    if (parts.isEmpty) {
      return email.isEmpty ? '?' : email.substring(0, 1).toUpperCase();
    }
    return parts
        .take(2)
        .map((part) => part.substring(0, 1).toUpperCase())
        .join();
  }
}
