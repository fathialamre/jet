import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires the value to contain only alphabetical characters.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'name',
///   validator: AlphabeticalValidator().validate,
/// )
/// ```
class AlphabeticalValidator extends BaseValidator<String> {
  /// Custom regex pattern (optional)
  final RegExp? regex;

  /// Creates an alphabetical validator.
  const AlphabeticalValidator({
    this.regex,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    final pattern = regex ?? RegExp(r'^[a-zA-Z]+$');

    if (!pattern.hasMatch(valueCandidate)) {
      return errorText ?? 'Value must contain only alphabetical characters';
    }
    return null;
  }
}
