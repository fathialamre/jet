import '../base_validator.dart';

/// Validator that requires a minimum number of uppercase characters.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'password',
///   validator: HasUppercaseCharsValidator(atLeast: 2).validate,
/// )
/// ```
class HasUppercaseCharsValidator extends BaseValidator<String> {
  /// The minimum number of uppercase characters required.
  final int atLeast;

  /// Custom regex pattern (optional)
  final RegExp? regex;

  /// Creates a has-uppercase-chars validator.
  const HasUppercaseCharsValidator({
    this.atLeast = 1,
    this.regex,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    final pattern = regex ?? RegExp(r'[A-Z]');
    final matches = pattern.allMatches(valueCandidate);

    if (matches.length < atLeast) {
      return errorText ??
          'Value must contain at least $atLeast uppercase character${atLeast > 1 ? 's' : ''}';
    }
    return null;
  }
}
