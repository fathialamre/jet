import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires a valid license plate number.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'license_plate',
///   validator: LicensePlateValidator().validate,
/// )
/// ```
class LicensePlateValidator extends BaseValidator<String> {
  /// Country code for specific validation
  final String? countryCode;

  /// Custom regex pattern (optional)
  final RegExp? regex;

  /// Creates a license plate validator.
  const LicensePlateValidator({
    this.countryCode,
    this.regex,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    if (regex != null) {
      if (!regex!.hasMatch(valueCandidate)) {
        return errorText ?? JetFormLocalizations.current.licensePlateErrorText;
      }
      return null;
    }

    // Generic validation: 2-8 alphanumeric characters with optional spaces/hyphens
    final pattern = RegExp(r'^[A-Z0-9\s\-]{2,8}$', caseSensitive: false);

    if (!pattern.hasMatch(valueCandidate)) {
      return errorText ?? JetFormLocalizations.current.licensePlateErrorText;
    }

    return null;
  }
}
