import '../base_validator.dart';

/// Validator that requires a numeric value.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'age',
///   validator: NumericValidator().validate,
/// )
/// ```
class NumericValidator extends BaseValidator<String> {
  /// Creates a numeric validator.
  const NumericValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    if (num.tryParse(valueCandidate) == null) {
      return errorText ?? 'Value must be numeric';
    }
    return null;
  }
}

