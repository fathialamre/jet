import '../base_validator.dart';

/// Validator that requires a non-zero number.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'divisor',
///   validator: NotZeroNumberValidator().validate,
/// )
/// ```
class NotZeroNumberValidator<T> extends BaseValidator<T> {
  /// Creates a not-zero number validator.
  const NotZeroNumberValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(T valueCandidate) {
    num? value;

    if (valueCandidate is num) {
      value = valueCandidate;
    } else if (valueCandidate is String) {
      value = num.tryParse(valueCandidate);
    }

    if (value == null) {
      return errorText ?? 'Value must be numeric';
    }

    if (value == 0) {
      return errorText ?? 'Value must not be zero';
    }
    return null;
  }
}
