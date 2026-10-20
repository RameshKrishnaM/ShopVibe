/// Utility class containing form field validators
class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$',
  );

  /// Validates email address format and presence
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is mandatory';
    }
    final trimmed = value.trim();
    if (!_emailRegExp.hasMatch(trimmed)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Validates password presence and minimum length of 6 characters
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is mandatory';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Helper boolean check for email validity
  static bool isEmailValid(String? value) => validateEmail(value) == null;

  /// Helper boolean check for password validity
  static bool isPasswordValid(String? value) => validatePassword(value) == null;
}
