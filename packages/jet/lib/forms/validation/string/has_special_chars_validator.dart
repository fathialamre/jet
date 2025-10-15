import '../base_validator.dart';

/// Validator that requires a minimum number of special characters.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'password',
///   validator: HasSpecialCharsValidator(atLeast: 1).validate,
/// )
/// ```
class HasSpecialCharsValidator extends BaseValidator<String> {
  /// The minimum number of special characters required.
  final int atLeast;

  /// Custom regex pattern (optional)
  final RegExp? regex;

  /// Creates a has-special-chars validator.
  const HasSpecialCharsValidator({
    this.atLeast = 1,
    this.regex,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    final pattern = regex ?? RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    final matches = pattern.allMatches(valueCandidate);

    if (matches.length < atLeast) {
      return errorText ??
          'Value must contain at least $atLeast special character${atLeast > 1 ? 's' : ''}';
    }
    return null;
  }
}

