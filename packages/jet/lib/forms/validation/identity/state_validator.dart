import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires a valid state name or code.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'state',
///   validator: StateValidator().validate,
/// )
/// ```
class StateValidator extends BaseValidator<String> {
  /// Minimum length for state name/code.
  final int minLength;

  /// Maximum length for state name/code.
  final int maxLength;

  /// Creates a state validator.
  const StateValidator({
    this.minLength = 2,
    this.maxLength = 50,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    if (valueCandidate.length < minLength ||
        valueCandidate.length > maxLength) {
      return errorText ??
          'State must be between $minLength and $maxLength characters';
    }

    // Allow letters, spaces, hyphens
    final pattern = RegExp(r'^[a-zA-Z\s\-]+$');

    if (!pattern.hasMatch(valueCandidate)) {
      return errorText ?? 'Please enter a valid state';
    }

    return null;
  }
}
