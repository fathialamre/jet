import '../base_validator.dart';

/// Validator that requires a valid street name.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'street',
///   validator: StreetValidator().validate,
/// )
/// ```
class StreetValidator extends BaseValidator<String> {
  /// Minimum length for street name.
  final int minLength;

  /// Maximum length for street name.
  final int maxLength;

  /// Creates a street validator.
  const StreetValidator({
    this.minLength = 3,
    this.maxLength = 100,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    if (valueCandidate.length < minLength || valueCandidate.length > maxLength) {
      return errorText ??
          'Street must be between $minLength and $maxLength characters';
    }

    // Allow letters, numbers, spaces, hyphens, periods, commas, and #
    final pattern = RegExp(r'^[a-zA-Z0-9\s\-.,#]+$');

    if (!pattern.hasMatch(valueCandidate)) {
      return errorText ?? 'Please enter a valid street name';
    }

    return null;
  }
}

