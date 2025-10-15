import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires a valid ISBN (10 or 13).
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'isbn',
///   validator: IsbnValidator().validate,
/// )
/// ```
class IsbnValidator extends BaseValidator<String> {
  /// Creates an ISBN validator.
  const IsbnValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  bool _isValidISBN10(String isbn) {
    if (isbn.length != 10) return false;

    int sum = 0;
    for (int i = 0; i < 9; i++) {
      final digit = int.tryParse(isbn[i]);
      if (digit == null) return false;
      sum += digit * (10 - i);
    }

    final lastChar = isbn[9];
    if (lastChar == 'X') {
      sum += 10;
    } else {
      final digit = int.tryParse(lastChar);
      if (digit == null) return false;
      sum += digit;
    }

    return sum % 11 == 0;
  }

  bool _isValidISBN13(String isbn) {
    if (isbn.length != 13) return false;

    int sum = 0;
    for (int i = 0; i < 13; i++) {
      final digit = int.tryParse(isbn[i]);
      if (digit == null) return false;
      sum += digit * (i % 2 == 0 ? 1 : 3);
    }

    return sum % 10 == 0;
  }

  @override
  String? validateValue(String valueCandidate) {
    // Remove hyphens and spaces
    final isbn = valueCandidate.replaceAll(RegExp(r'[-\s]'), '');

    if (!_isValidISBN10(isbn) && !_isValidISBN13(isbn)) {
      return errorText ?? JetFormLocalizations.current.isbnErrorText;
    }

    return null;
  }
}
