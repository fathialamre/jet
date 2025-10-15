import '../base_validator.dart';

/// Validator that requires the value to be all lowercase.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'username',
///   validator: LowercaseValidator().validate,
/// )
/// ```
class LowercaseValidator extends BaseValidator<String> {
  /// Creates a lowercase validator.
  const LowercaseValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    if (valueCandidate != valueCandidate.toLowerCase()) {
      return errorText ?? 'Value must be in lowercase';
    }
    return null;
  }
}

