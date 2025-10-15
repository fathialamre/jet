import '../base_validator.dart';

/// Validator that requires a valid username.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'username',
///   validator: UsernameValidator().validate,
/// )
/// ```
class UsernameValidator extends BaseValidator<String> {
  /// Minimum length for username.
  final int minLength;

  /// Maximum length for username.
  final int maxLength;

  /// Whether to allow special characters.
  final bool allowSpecialChars;

  /// Custom regex pattern (optional)
  final RegExp? regex;

  /// Creates a username validator.
  const UsernameValidator({
    this.minLength = 3,
    this.maxLength = 20,
    this.allowSpecialChars = false,
    this.regex,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    if (valueCandidate.length < minLength || valueCandidate.length > maxLength) {
      return errorText ??
          'Username must be between $minLength and $maxLength characters';
    }

    final pattern = regex ??
        (allowSpecialChars
            ? RegExp(r'^[a-zA-Z0-9_\-\.]+$')
            : RegExp(r'^[a-zA-Z0-9]+$'));

    if (!pattern.hasMatch(valueCandidate)) {
      return errorText ?? 'Please enter a valid username';
    }

    return null;
  }
}

