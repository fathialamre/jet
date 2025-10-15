import '../base_validator.dart';

/// Validator that requires a valid base64 encoded string.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'encoded_data',
///   validator: Base64Validator().validate,
/// )
/// ```
class Base64Validator extends BaseValidator<String> {
  /// Creates a base64 validator.
  const Base64Validator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    // Base64 pattern
    final pattern = RegExp(
      r'^(?:[A-Za-z0-9+\/]{4})*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=)?$',
    );

    if (!pattern.hasMatch(valueCandidate)) {
      return errorText ?? 'Value must be valid base64';
    }

    return null;
  }
}
