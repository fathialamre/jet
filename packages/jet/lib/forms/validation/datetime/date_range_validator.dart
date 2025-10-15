import '../base_validator.dart';

/// Validator that requires a date to be within a specific range.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'event_date',
///   validator: DateRangeValidator(
///     minDate: DateTime(2024, 1, 1),
///     maxDate: DateTime(2024, 12, 31),
///   ).validate,
/// )
/// ```
class DateRangeValidator<T> extends BaseValidator<T> {
  /// The minimum allowed date (inclusive).
  final DateTime? minDate;

  /// The maximum allowed date (inclusive).
  final DateTime? maxDate;

  /// Creates a date range validator.
  const DateRangeValidator({
    this.minDate,
    this.maxDate,
    super.errorText,
    super.checkNullOrEmpty,
  }) : assert(minDate != null || maxDate != null,
            'At least one of minDate or maxDate must be provided');

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

    if (minDate != null && date.isBefore(minDate!)) {
      return errorText ??
          'Date must be on or after ${minDate!.toLocal().toString().split(' ')[0]}';
    }

    if (maxDate != null && date.isAfter(maxDate!)) {
      return errorText ??
          'Date must be on or before ${maxDate!.toLocal().toString().split(' ')[0]}';
    }

    return null;
  }
}

