import '../base_validator.dart';

/// Validator that requires a minimum number of lowercase characters.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'password',
///   validator: HasLowercaseCharsValidator(atLeast: 2).validate,
/// )
/// ```
class HasLowercaseCharsValidator extends BaseValidator<String> {
  /// The minimum number of lowercase characters required.
  final int atLeast;

  /// Custom regex pattern (optional)
  final RegExp? regex;

  /// Creates a has-lowercase-chars validator.
  const HasLowercaseCharsValidator({
    this.atLeast = 1,
    this.regex,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    final pattern = regex ?? RegExp(r'[a-z]');
    final matches = pattern.allMatches(valueCandidate);

    if (matches.length < atLeast) {
      return errorText ??
          'Value must contain at least $atLeast lowercase character${atLeast > 1 ? 's' : ''}';
    }
    return null;
  }
}
