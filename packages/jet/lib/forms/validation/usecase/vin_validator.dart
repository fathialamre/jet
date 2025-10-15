import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires a valid VIN (Vehicle Identification Number).
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'vin',
///   validator: VinValidator().validate,
/// )
/// ```
class VinValidator extends BaseValidator<String> {
  /// Creates a VIN validator.
  const VinValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    // VIN must be exactly 17 characters
    if (valueCandidate.length != 17) {
      return errorText ?? 'VIN must be exactly 17 characters';
    }

    // VIN uses letters and digits, but excludes I, O, Q
    final pattern = RegExp(r'^[A-HJ-NPR-Z0-9]{17}$', caseSensitive: false);

    if (!pattern.hasMatch(valueCandidate)) {
      return errorText ?? JetFormLocalizations.current.vinErrorText;
    }

    // TODO: Implement checksum validation for full accuracy

    return null;
  }
}
