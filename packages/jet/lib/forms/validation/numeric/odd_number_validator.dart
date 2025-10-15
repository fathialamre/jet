import '../base_validator.dart';

/// Validator that requires an odd number.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'odd_count',
///   validator: OddNumberValidator().validate,
/// )
/// ```
class OddNumberValidator<T> extends BaseValidator<T> {
  /// Creates an odd number validator.
  const OddNumberValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(T valueCandidate) {
    int? value;

    if (valueCandidate is int) {
      value = valueCandidate;
    } else if (valueCandidate is num) {
      value = (valueCandidate as num).toInt();
    } else if (valueCandidate is String) {
      value = int.tryParse(valueCandidate);
    }

    if (value == null) {
      return errorText ?? 'Value must be an integer';
    }

    if (value % 2 == 0) {
      return errorText ?? 'Value must be an odd number';
    }
    return null;
  }
}
