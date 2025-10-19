import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires a valid phone number.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'phone',
///   validator: PhoneNumberValidator().validate,
/// )
/// ```
class PhoneNumberValidator extends BaseValidator<String> {
  /// Custom phone regex pattern (optional)
  final RegExp? regex;

  /// Creates a phone number validator.
  const PhoneNumberValidator({
    this.regex,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    // Basic international phone number pattern
    // Supports: +1234567890, (123) 456-7890, 123-456-7890, etc.
    final pattern =
        regex ??
        RegExp(
          r'^\+?[\d\s\-\(\)]+$',
        );

    // Remove all non-digit characters to count actual digits
    final digitsOnly = valueCandidate.replaceAll(RegExp(r'[^\d]'), '');

    if (!pattern.hasMatch(valueCandidate) || digitsOnly.length < 7) {
      return errorText ?? JetFormLocalizations.current.phoneErrorText;
    }

    return null;
  }
}
