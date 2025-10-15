import '../base_validator.dart';

/// Validator that requires the value to be true.
///
/// Example:
/// ```dart
/// JetCheckboxField(
///   name: 'terms_accepted',
///   validator: IsTrueValidator().validate,
/// )
/// ```
class IsTrueValidator extends BaseValidator<bool> {
  /// Creates an is-true validator.
  const IsTrueValidator({
    super.errorText,
    super.checkNullOrEmpty = false,
  });

  @override
  String? validateValue(bool valueCandidate) {
    if (valueCandidate != true) {
      return errorText ?? 'This field must be accepted';
    }
    return null;
  }
}

