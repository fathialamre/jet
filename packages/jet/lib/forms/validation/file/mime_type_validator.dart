import '../base_validator.dart';

/// Validator that requires a specific MIME type.
///
/// Example:
/// ```dart
/// validator: MimeTypeValidator(['image/jpeg', 'image/png']).validate,
/// ```
class MimeTypeValidator extends BaseValidator<String> {
  /// List of allowed MIME types
  final List<String> allowedMimeTypes;

  /// Creates a MIME type validator.
  const MimeTypeValidator(
    this.allowedMimeTypes, {
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    if (!allowedMimeTypes.contains(valueCandidate)) {
      return errorText ??
          'File type must be one of: ${allowedMimeTypes.join(', ')}';
    }

    return null;
  }
}

