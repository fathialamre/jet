import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires a valid IBAN (International Bank Account Number).
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'iban',
///   validator: IbanValidator().validate,
/// )
/// ```
class IbanValidator extends BaseValidator<String> {
  /// Creates an IBAN validator.
  const IbanValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    // Remove all spaces and convert to uppercase
    final iban = valueCandidate.replaceAll(' ', '').toUpperCase();

    // IBAN should be 15-34 characters
    if (iban.length < 15 || iban.length > 34) {
      return errorText ?? 'IBAN must be 15-34 characters';
    }

    // Check if it starts with 2 letters followed by 2 digits
    if (!RegExp(r'^[A-Z]{2}\d{2}[A-Z0-9]+$').hasMatch(iban)) {
      return errorText ?? JetFormLocalizations.current.ibanErrorText;
    }

    // TODO: Implement MOD-97 checksum validation for full accuracy
    // For now, basic format validation

    return null;
  }
}
