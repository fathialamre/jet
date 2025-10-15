import '../base_validator.dart';

/// Validator that requires an integer value.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'count',
///   validator: IntegerValidator().validate,
/// )
/// ```
class IntegerValidator extends BaseValidator<String> {
  /// Creates an integer validator.
  const IntegerValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    if (int.tryParse(valueCandidate) == null) {
      return errorText ?? 'Value must be a valid integer';
    }
    return null;
  }
}

