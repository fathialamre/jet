import '../base_validator.dart';

/// Validator that requires a valid credit card CVC/CVV code.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'cvc',
///   validator: CreditCardCvcValidator().validate,
/// )
/// ```
class CreditCardCvcValidator extends BaseValidator<String> {
  /// Length of CVC (3 or 4 digits)
  final int? length;

  /// Creates a CVC validator.
  const CreditCardCvcValidator({
    this.length,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    // Remove all non-digit characters
    final digitsOnly = valueCandidate.replaceAll(RegExp(r'[^\d]'), '');

    if (length != null) {
      if (digitsOnly.length != length) {
        return errorText ?? 'CVC must be $length digits';
      }
    } else {
      // Most cards use 3 digits, Amex uses 4
      if (digitsOnly.length != 3 && digitsOnly.length != 4) {
        return errorText ?? 'CVC must be 3 or 4 digits';
      }
    }

    return null;
  }
}

