import '../base_validator.dart';

/// Validator that requires a valid last name.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'last_name',
///   validator: LastNameValidator().validate,
/// )
/// ```
class LastNameValidator extends BaseValidator<String> {
  /// Minimum length for last name.
  final int minLength;

  /// Maximum length for last name.
  final int maxLength;

  /// Custom regex pattern (optional)
  final RegExp? regex;

  /// Creates a last name validator.
  const LastNameValidator({
    this.minLength = 2,
    this.maxLength = 50,
    this.regex,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    if (valueCandidate.length < minLength || valueCandidate.length > maxLength) {
      return errorText ??
          'Last name must be between $minLength and $maxLength characters';
    }

    final pattern = regex ?? RegExp(r"^[a-zA-Z\s\-']+$");
    
    if (!pattern.hasMatch(valueCandidate)) {
      return errorText ?? 'Please enter a valid last name';
    }

    return null;
  }
}

