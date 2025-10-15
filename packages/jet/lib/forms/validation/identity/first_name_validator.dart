import '../base_validator.dart';

/// Validator that requires a valid first name.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'first_name',
///   validator: FirstNameValidator().validate,
/// )
/// ```
class FirstNameValidator extends BaseValidator<String> {
  /// Minimum length for first name.
  final int minLength;

  /// Maximum length for first name.
  final int maxLength;

  /// Custom regex pattern (optional)
  final RegExp? regex;

  /// Creates a first name validator.
  const FirstNameValidator({
    this.minLength = 2,
    this.maxLength = 50,
    this.regex,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    if (valueCandidate.length < minLength ||
        valueCandidate.length > maxLength) {
      return errorText ??
          'First name must be between $minLength and $maxLength characters';
    }

    final pattern = regex ?? RegExp(r"^[a-zA-Z\s\-']+$");

    if (!pattern.hasMatch(valueCandidate)) {
      return errorText ?? 'Please enter a valid first name';
    }

    return null;
  }
}
