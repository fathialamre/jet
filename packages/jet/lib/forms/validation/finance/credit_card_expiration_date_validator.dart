import '../base_validator.dart';

/// Validator that requires a valid credit card expiration date.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'expiry',
///   validator: CreditCardExpirationDateValidator().validate,
/// )
/// ```
class CreditCardExpirationDateValidator extends BaseValidator<String> {
  /// Creates an expiration date validator.
  const CreditCardExpirationDateValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    // Expected formats: MM/YY, MM/YYYY, MMYY, MMYYYY
    final cleanValue = valueCandidate.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanValue.length != 4 && cleanValue.length != 6) {
      return errorText ?? 'Please enter a valid expiration date (MM/YY)';
    }

    final month = int.tryParse(cleanValue.substring(0, 2));
    final yearStr = cleanValue.length == 4
        ? cleanValue.substring(2, 4)
        : cleanValue.substring(2, 6);
    final year = int.tryParse(yearStr);

    if (month == null || year == null) {
      return errorText ?? 'Please enter a valid expiration date';
    }

    if (month < 1 || month > 12) {
      return errorText ?? 'Month must be between 01 and 12';
    }

    // Convert 2-digit year to 4-digit year
    final fullYear = year < 100 ? 2000 + year : year;
    final now = DateTime.now();
    final expiryDate = DateTime(fullYear, month + 1, 0); // Last day of month

    if (expiryDate.isBefore(now)) {
      return errorText ?? 'Credit card has expired';
    }

    return null;
  }
}

