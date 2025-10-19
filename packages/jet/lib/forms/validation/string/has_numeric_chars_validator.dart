import '../base_validator.dart';

/// Validator that requires a minimum number of numeric characters.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'password',
///   validator: HasNumericCharsValidator(atLeast: 2).validate,
/// )
/// ```
class HasNumericCharsValidator extends BaseValidator<String> {
  /// The minimum number of numeric characters required.
  final int atLeast;

  /// Custom regex pattern (optional)
  final RegExp? regex;

  /// Creates a has-numeric-chars validator.
  const HasNumericCharsValidator({
    this.atLeast = 1,
    this.regex,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    final pattern = regex ?? RegExp(r'[0-9]');
    final matches = pattern.allMatches(valueCandidate);

    if (matches.length < atLeast) {
      return errorText ??
          'Value must contain at least $atLeast numeric character${atLeast > 1 ? 's' : ''}';
    }
    return null;
  }
}
