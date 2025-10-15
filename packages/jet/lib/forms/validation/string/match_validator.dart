import '../base_validator.dart';

/// Validator that requires the value to match a regex pattern.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'code',
///   validator: MatchValidator(RegExp(r'^[A-Z]{3}\d{3}$')).validate,
/// )
/// ```
class MatchValidator extends BaseValidator<String> {
  /// The regex pattern to match.
  final RegExp pattern;

  /// Creates a match validator.
  const MatchValidator(
    this.pattern, {
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    if (!pattern.hasMatch(valueCandidate)) {
      return errorText ?? 'Value does not match the required pattern';
    }
    return null;
  }
}

