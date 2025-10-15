import '../base_validator.dart';

/// Validator that requires a minimum numeric value.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'age',
///   validator: MinValidator(18).validate,
/// )
/// ```
class MinValidator<T> extends BaseValidator<T> {
  /// The minimum value allowed.
  final num min;

  /// Creates a minimum value validator.
  const MinValidator(
    this.min, {
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

    if (value < min) {
      return errorText ?? 'Value must be greater than or equal to $min';
    }
    return null;
  }
}

