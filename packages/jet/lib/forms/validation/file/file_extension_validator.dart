import '../base_validator.dart';

/// Validator that requires a specific file extension.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'file_path',
///   validator: FileExtensionValidator(['.pdf', '.doc', '.docx']).validate,
/// )
/// ```
class FileExtensionValidator extends BaseValidator<String> {
  /// List of allowed file extensions (with or without dot)
  final List<String> allowedExtensions;

  /// Whether comparison is case-sensitive
  final bool caseSensitive;

  /// Creates a file extension validator.
  const FileExtensionValidator(
    this.allowedExtensions, {
    this.caseSensitive = false,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    final fileName = caseSensitive
        ? valueCandidate
        : valueCandidate.toLowerCase();

    final extensions = allowedExtensions
        .map((ext) => caseSensitive ? ext : ext.toLowerCase())
        .toList();

    // Ensure extensions start with dot
    final normalizedExtensions = extensions
        .map((ext) => ext.startsWith('.') ? ext : '.$ext')
        .toList();

    final hasValidExtension = normalizedExtensions.any(
      (ext) => fileName.endsWith(ext),
    );

    if (!hasValidExtension) {
      final extList = normalizedExtensions.join(', ');
      return errorText ?? 'File must have one of these extensions: $extList';
    }

    return null;
  }
}
