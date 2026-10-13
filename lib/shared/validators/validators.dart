/// Client-side checks mirror the backend contract but never replace it — the
/// server is the only authority on validity.
abstract final class Validators {
  static final RegExp _email = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  static String? email(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return 'Enter your email address.';
    if (!_email.hasMatch(input)) return 'Enter a valid email address.';
    return null;
  }

  static String? password(String? value) {
    final input = value ?? '';
    if (input.isEmpty) return 'Enter your password.';
    if (input.length < 8) return 'Passwords are at least 8 characters.';
    return null;
  }
}
