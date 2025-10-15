import '../base_validator.dart';

/// Validator that requires the value to NOT match a regex pattern.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'username',
///   validator: MatchNotValidator(RegExp(r'[^a-zA-Z0-9]')).validate,
/// )
/// ```
class MatchNotValidator extends BaseValidator<String> {
  /// The regex pattern that must NOT match.
  final RegExp pattern;

  /// Creates a match-not validator.
  const MatchNotValidator(
    this.pattern, {
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    if (pattern.hasMatch(valueCandidate)) {
      return errorText ?? 'Value must not match the forbidden pattern';
    }
    return null;
  }
}
