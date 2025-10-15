import '../base_validator.dart';

/// Validator that requires a valid timezone string.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'timezone',
///   validator: TimezoneValidator().validate,
/// )
/// ```
class TimezoneValidator extends BaseValidator<String> {
  /// List of valid timezones (optional, defaults to common timezones)
  final List<String>? validTimezones;

  /// Creates a timezone validator.
  const TimezoneValidator({
    this.validTimezones,
    super.errorText,
    super.checkNullOrEmpty,
  });

  static const List<String> _commonTimezones = [
    'UTC',
    'America/New_York',
    'America/Chicago',
    'America/Denver',
    'America/Los_Angeles',
    'Europe/London',
    'Europe/Paris',
    'Asia/Tokyo',
    'Asia/Dubai',
    'Australia/Sydney',
  ];

  @override
  String? validateValue(String valueCandidate) {
    final timezones = validTimezones ?? _commonTimezones;

    // Check if timezone is in the list or matches pattern
    final pattern = RegExp(r'^[A-Z][a-zA-Z]*\/[A-Z][a-zA-Z_]*$');

    if (!timezones.contains(valueCandidate) &&
        !pattern.hasMatch(valueCandidate)) {
      return errorText ?? 'Please enter a valid timezone';
    }

    return null;
  }
}
