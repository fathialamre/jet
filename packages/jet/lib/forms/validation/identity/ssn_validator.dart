import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires a valid US Social Security Number.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'ssn',
///   validator: SsnValidator().validate,
/// )
/// ```
class SsnValidator extends BaseValidator<String> {
  /// Creates an SSN validator.
  const SsnValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    // Remove all non-digit characters
    final digitsOnly = valueCandidate.replaceAll(RegExp(r'[^\d]'), '');

    // SSN must be exactly 9 digits
    if (digitsOnly.length != 9) {
      return errorText ?? 'SSN must be 9 digits';
    }

    // Basic format validation: XXX-XX-XXXX or XXXXXXXXX
    final pattern = RegExp(r'^\d{3}-?\d{2}-?\d{4}$');
    if (!pattern.hasMatch(valueCandidate)) {
      return errorText ?? JetFormLocalizations.current.ssnErrorText;
    }

    return null;
  }
}
