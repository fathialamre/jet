import '../base_validator.dart';

/// Validator that requires a valid passport number.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'passport',
///   validator: PassportNumberValidator().validate,
/// )
/// ```
class PassportNumberValidator extends BaseValidator<String> {
  /// Custom regex pattern (optional)
  final RegExp? regex;

  /// Creates a passport number validator.
  const PassportNumberValidator({
    this.regex,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    // Generic passport number validation (alphanumeric, 6-9 characters)
    final pattern = regex ?? RegExp(r'^[A-Z0-9]{6,9}$');

    if (!pattern.hasMatch(valueCandidate)) {
      return errorText ?? 'Please enter a valid passport number';
    }

    return null;
  }
}

