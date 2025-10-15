import '../base_validator.dart';

/// Validator that requires the value to contain a specific substring.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'description',
///   validator: ContainsValidator('important').validate,
/// )
/// ```
class ContainsValidator extends BaseValidator<String> {
  /// The substring that must be present in the value.
  final String substring;

  /// Whether the search is case-sensitive.
  final bool caseSensitive;

  /// Creates a contains validator.
  const ContainsValidator(
    this.substring, {
    this.caseSensitive = true,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    final value = caseSensitive ? valueCandidate : valueCandidate.toLowerCase();
    final search = caseSensitive ? substring : substring.toLowerCase();

    if (!value.contains(search)) {
      return errorText ?? 'Value must contain "$substring"';
    }
    return null;
  }
}
