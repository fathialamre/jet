import '../base_validator.dart';

/// Validator that requires the value to end with a specific substring.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'email',
///   validator: EndsWithValidator('@company.com').validate,
/// )
/// ```
class EndsWithValidator extends BaseValidator<String> {
  /// The suffix that the value must end with.
  final String suffix;

  /// Creates an ends-with validator.
  const EndsWithValidator(
    this.suffix, {
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    if (!valueCandidate.endsWith(suffix)) {
      return errorText ?? 'Value must end with "$suffix"';
    }
    return null;
  }
}

