import '../base_validator.dart';

/// Validator that requires a valid city name.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'city',
///   validator: CityValidator().validate,
/// )
/// ```
class CityValidator extends BaseValidator<String> {
  /// Minimum length for city name.
  final int minLength;

  /// Maximum length for city name.
  final int maxLength;

  /// Creates a city validator.
  const CityValidator({
    this.minLength = 2,
    this.maxLength = 50,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    if (valueCandidate.length < minLength ||
        valueCandidate.length > maxLength) {
      return errorText ??
          'City name must be between $minLength and $maxLength characters';
    }

    // Allow letters, spaces, hyphens, apostrophes, and periods
    final pattern = RegExp(r"^[a-zA-Z\s\-'.]+$");

    if (!pattern.hasMatch(valueCandidate)) {
      return errorText ?? 'Please enter a valid city name';
    }

    return null;
  }
}
