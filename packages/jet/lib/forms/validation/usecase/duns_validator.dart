import '../base_validator.dart';

/// Validator that requires a valid DUNS number (Data Universal Numbering System).
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'duns',
///   validator: DunsValidator().validate,
/// )
/// ```
class DunsValidator extends BaseValidator<String> {
  /// Creates a DUNS validator.
  const DunsValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    // Remove all non-digit characters
    final digitsOnly = valueCandidate.replaceAll(RegExp(r'[^\d]'), '');

    // DUNS must be exactly 9 digits
    if (digitsOnly.length != 9) {
      return errorText ?? 'DUNS number must be 9 digits';
    }

    return null;
  }
}

