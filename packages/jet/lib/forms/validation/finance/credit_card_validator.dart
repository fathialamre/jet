import '../base_validator.dart';

/// Validator that requires a valid credit card number using Luhn algorithm.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'credit_card',
///   validator: CreditCardValidator().validate,
/// )
/// ```
class CreditCardValidator extends BaseValidator<String> {
  /// Creates a credit card validator.
  const CreditCardValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  bool _luhnCheck(String cardNumber) {
    int sum = 0;
    bool alternate = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  @override
  String? validateValue(String valueCandidate) {
    // Remove all non-digit characters
    final digitsOnly = valueCandidate.replaceAll(RegExp(r'[^\d]'), '');

    // Credit card should be 13-19 digits
    if (digitsOnly.length < 13 || digitsOnly.length > 19) {
      return errorText ?? 'Credit card number must be 13-19 digits';
    }

    if (!_luhnCheck(digitsOnly)) {
      return errorText ?? 'Please enter a valid credit card number';
    }

    return null;
  }
}
