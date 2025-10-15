import '../base_validator.dart';

/// Validator that requires a valid BIC/SWIFT code.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'bic',
///   validator: BicValidator().validate,
/// )
/// ```
class BicValidator extends BaseValidator<String> {
  /// Creates a BIC validator.
  const BicValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    // BIC format: 8 or 11 alphanumeric characters
    // Structure: AAAABBCCXXX
    // AAAA = Bank code (4 letters)
    // BB = Country code (2 letters)
    // CC = Location code (2 alphanumeric)
    // XXX = Branch code (3 alphanumeric, optional)

    final bic = valueCandidate.replaceAll(' ', '').toUpperCase();

    if (bic.length != 8 && bic.length != 11) {
      return errorText ?? 'BIC must be 8 or 11 characters';
    }

    final pattern = RegExp(r'^[A-Z]{4}[A-Z]{2}[A-Z0-9]{2}([A-Z0-9]{3})?$');

    if (!pattern.hasMatch(bic)) {
      return errorText ?? 'Please enter a valid BIC/SWIFT code';
    }

    return null;
  }
}
