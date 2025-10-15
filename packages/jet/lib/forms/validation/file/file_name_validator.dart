import '../base_validator.dart';

/// Validator that requires a valid file name.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'file_name',
///   validator: FileNameValidator().validate,
/// )
/// ```
class FileNameValidator extends BaseValidator<String> {
  /// Creates a file name validator.
  const FileNameValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    // Check for invalid characters in file names
    // Common invalid characters: \ / : * ? " < > |
    final invalidChars = RegExp(r'[\\/:*?"<>|]');

    if (invalidChars.hasMatch(valueCandidate)) {
      return errorText ?? 'File name contains invalid characters';
    }

    // Check for reserved names on Windows
    const reservedNames = [
      'CON', 'PRN', 'AUX', 'NUL',
      'COM1', 'COM2', 'COM3', 'COM4', 'COM5', 'COM6', 'COM7', 'COM8', 'COM9',
      'LPT1', 'LPT2', 'LPT3', 'LPT4', 'LPT5', 'LPT6', 'LPT7', 'LPT8', 'LPT9',
    ];

    final nameWithoutExt = valueCandidate.split('.').first.toUpperCase();
    if (reservedNames.contains(nameWithoutExt)) {
      return errorText ?? 'File name uses a reserved system name';
    }

    return null;
  }
}

