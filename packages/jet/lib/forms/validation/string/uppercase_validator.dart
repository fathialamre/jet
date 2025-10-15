import '../base_validator.dart';

/// Validator that requires the value to be all uppercase.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'code',
///   validator: UppercaseValidator().validate,
/// )
/// ```
class UppercaseValidator extends BaseValidator<String> {
  /// Creates an uppercase validator.
  const UppercaseValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    if (valueCandidate != valueCandidate.toUpperCase()) {
      return errorText ?? 'Value must be in uppercase';
    }
    return null;
  }
}

