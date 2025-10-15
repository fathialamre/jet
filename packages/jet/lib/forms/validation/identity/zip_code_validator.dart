import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires a valid ZIP/postal code.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'zip',
///   validator: ZipCodeValidator().validate,
/// )
/// ```
class ZipCodeValidator extends BaseValidator<String> {
  /// Country code for specific validation (US, CA, UK, etc.)
  final String? countryCode;

  /// Custom regex pattern (optional)
  final RegExp? regex;

  /// Creates a ZIP code validator.
  const ZipCodeValidator({
    this.countryCode,
    this.regex,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    RegExp pattern;

    if (regex != null) {
      pattern = regex!;
    } else {
      switch (countryCode?.toUpperCase()) {
        case 'US':
          pattern = RegExp(r'^\d{5}(-\d{4})?$'); // 12345 or 12345-6789
          break;
        case 'CA':
          pattern = RegExp(
            r'^[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d$',
          ); // A1A 1A1
          break;
        case 'UK':
        case 'GB':
          pattern = RegExp(
            r'^[A-Z]{1,2}\d{1,2}[A-Z]?\s?\d[A-Z]{2}$',
          ); // SW1A 1AA
          break;
        default:
          pattern = RegExp(r'^[A-Za-z0-9\s\-]{3,10}$'); // Generic
      }
    }

    if (!pattern.hasMatch(valueCandidate)) {
      return errorText ?? JetFormLocalizations.current.zipCodeErrorText;
    }

    return null;
  }
}
