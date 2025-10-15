import '../base_validator.dart';

/// Validator that requires a future date.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'expiry_date',
///   validator: DateFutureValidator().validate,
/// )
/// ```
class DateFutureValidator<T> extends BaseValidator<T> {
  /// Creates a future date validator.
  const DateFutureValidator({
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

    if (!date.isAfter(DateTime.now())) {
      return errorText ?? 'Date must be in the future';
    }

    return null;
  }
}
