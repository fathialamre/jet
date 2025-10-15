import '../base_validator.dart';

/// Validator that requires a valid time string.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'meeting_time',
///   validator: TimeValidator().validate,
/// )
/// ```
class TimeValidator extends BaseValidator<String> {
  /// Creates a time validator.
  const TimeValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    // Validates HH:MM or HH:MM:SS format
    final pattern = RegExp(r'^([01]?\d|2[0-3]):([0-5]\d)(?::([0-5]\d))?$');

    if (!pattern.hasMatch(valueCandidate)) {
      return errorText ?? 'Please enter a valid time (HH:MM or HH:MM:SS)';
    }
    return null;
  }
}
