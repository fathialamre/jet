import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires a valid language code (ISO 639-1 or ISO 639-2).
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'language',
///   validator: LanguageCodeValidator().validate,
/// )
/// ```
class LanguageCodeValidator extends BaseValidator<String> {
  /// Format: 'iso639-1' (2 letters) or 'iso639-2' (3 letters)
  final String? format;

  /// Creates a language code validator.
  const LanguageCodeValidator({
    this.format,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    if (format == 'iso639-1' || format == null) {
      // ISO 639-1: 2-letter code (e.g., 'en', 'fr')
      if (RegExp(r'^[a-z]{2}$').hasMatch(valueCandidate.toLowerCase())) {
        return null;
      }
    }

    if (format == 'iso639-2' || format == null) {
      // ISO 639-2: 3-letter code (e.g., 'eng', 'fra')
      if (RegExp(r'^[a-z]{3}$').hasMatch(valueCandidate.toLowerCase())) {
        return null;
      }
    }

    return errorText ?? JetFormLocalizations.current.languageCodeErrorText;
  }
}
