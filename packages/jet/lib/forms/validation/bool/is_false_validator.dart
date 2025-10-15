import '../base_validator.dart';

/// Validator that requires the value to be false.
///
/// Example:
/// ```dart
/// JetCheckboxField(
///   name: 'opt_out',
///   validator: IsFalseValidator().validate,
/// )
/// ```
class IsFalseValidator extends BaseValidator<bool> {
  /// Creates an is-false validator.
  const IsFalseValidator({
    super.errorText,
    super.checkNullOrEmpty = false,
  });

  @override
  String? validateValue(bool valueCandidate) {
    if (valueCandidate != false) {
      return errorText ?? 'This field must not be checked';
    }
    return null;
  }
}
