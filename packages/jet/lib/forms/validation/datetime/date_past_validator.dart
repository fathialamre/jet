import '../base_validator.dart';

/// Validator that requires a past date.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'birthdate',
///   validator: DatePastValidator().validate,
/// )
/// ```
class DatePastValidator<T> extends BaseValidator<T> {
  /// Creates a past date validator.
  const DatePastValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(T valueCandidate) {
    DateTime? date;

    if (valueCandidate is DateTime) {
      date = valueCandidate;
    } else if (valueCandidate is String) {
      try {
        date = DateTime.parse(valueCandidate);
      } catch (e) {
        return errorText ?? 'Please enter a valid date';
      }
    }

    if (date == null) {
      return errorText ?? 'Please enter a valid date';
    }

    if (!date.isBefore(DateTime.now())) {
      return errorText ?? 'Date must be in the past';
    }

    return null;
  }
}

