import '../base_validator.dart';

/// Validator that requires a strong password.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'password',
///   obscureText: true,
///   validator: PasswordValidator().validate,
/// )
/// ```
class PasswordValidator extends BaseValidator<String> {
  /// Minimum length for password.
  final int minLength;

  /// Whether to require uppercase characters.
  final bool requireUppercase;

  /// Whether to require lowercase characters.
  final bool requireLowercase;

  /// Whether to require numbers.
  final bool requireNumbers;

  /// Whether to require special characters.
  final bool requireSpecialChars;

  /// Creates a password validator.
  const PasswordValidator({
    this.minLength = 8,
    this.requireUppercase = true,
    this.requireLowercase = true,
    this.requireNumbers = true,
    this.requireSpecialChars = true,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    if (valueCandidate.length < minLength) {
      return errorText ??
          'Password must be at least $minLength characters long';
    }

    if (requireUppercase && !RegExp(r'[A-Z]').hasMatch(valueCandidate)) {
      return errorText ?? 'Password must contain at least one uppercase letter';
    }

    if (requireLowercase && !RegExp(r'[a-z]').hasMatch(valueCandidate)) {
      return errorText ?? 'Password must contain at least one lowercase letter';
    }

    if (requireNumbers && !RegExp(r'[0-9]').hasMatch(valueCandidate)) {
      return errorText ?? 'Password must contain at least one number';
    }

    if (requireSpecialChars &&
        !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(valueCandidate)) {
      return errorText ??
          'Password must contain at least one special character';
    }

    return null;
  }
}
