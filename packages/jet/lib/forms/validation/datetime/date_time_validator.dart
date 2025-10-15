import '../base_validator.dart';

/// Validator that requires a valid datetime string.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'appointment',
///   validator: DateTimeValidator().validate,
/// )
/// ```
class DateTimeValidator extends BaseValidator<String> {
  /// Creates a datetime validator.
  const DateTimeValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    try {
      DateTime.parse(valueCandidate);
      return null;
    } catch (e) {
      return errorText ?? 'Please enter a valid date and time';
    }
  }
}
