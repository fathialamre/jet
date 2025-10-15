import '../base_validator.dart';

/// Validator that requires a valid date string.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'birthdate',
///   validator: DateValidator().validate,
/// )
/// ```
class DateValidator extends BaseValidator<String> {
  /// Custom date format pattern (optional)
  final RegExp? regex;

  /// Creates a date validator.
  const DateValidator({
    this.regex,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    try {
      DateTime.parse(valueCandidate);
      return null;
    } catch (e) {
      return errorText ?? 'Please enter a valid date';
    }
  }
}

