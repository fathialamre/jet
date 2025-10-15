import '../base_validator.dart';

/// Validator that requires a valid country name.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'country',
///   validator: CountryValidator().validate,
/// )
/// ```
class CountryValidator extends BaseValidator<String> {
  /// Minimum length for country name.
  final int minLength;

  /// Maximum length for country name.
  final int maxLength;

  /// Creates a country validator.
  const CountryValidator({
    this.minLength = 2,
    this.maxLength = 60,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    if (valueCandidate.length < minLength || valueCandidate.length > maxLength) {
      return errorText ??
          'Country name must be between $minLength and $maxLength characters';
    }

    // Allow letters, spaces, hyphens, apostrophes, and periods
    final pattern = RegExp(r"^[a-zA-Z\s\-'.]+$");

    if (!pattern.hasMatch(valueCandidate)) {
      return errorText ?? 'Please enter a valid country name';
    }

    return null;
  }
}

