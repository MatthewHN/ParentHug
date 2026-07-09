/// Simple, reusable form validators.
class Validators {
  Validators._();

  static final _emailRe =
      RegExp(r'^[\w.+-]+@([\w-]+\.)+[\w-]{2,}$', caseSensitive: false);

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Enter your email';
    if (!_emailRe.hasMatch(v)) return 'Enter a valid email';
    return null;
  }

  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Enter a password';
    if (v.length < 8) return 'Use at least 8 characters';
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if ((value ?? '') != original) return 'Passwords don’t match';
    return null;
  }

  static String? required(String? value, [String field = 'This field']) {
    if ((value?.trim() ?? '').isEmpty) return '$field is required';
    return null;
  }

  static String? inviteCode(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Enter an invite code';
    if (v.length < 6) return 'That code looks too short';
    return null;
  }
}
