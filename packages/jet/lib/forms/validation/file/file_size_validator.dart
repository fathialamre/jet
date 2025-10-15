import '../base_validator.dart';

/// Validator that requires a file size within limits.
///
/// Example:
/// ```dart
/// // Assuming you have file size in bytes
/// validator: FileSizeValidator(maxSizeInBytes: 5 * 1024 * 1024).validate, // 5MB
/// ```
class FileSizeValidator<T> extends BaseValidator<T> {
  /// Maximum file size in bytes
  final int? maxSizeInBytes;

  /// Minimum file size in bytes
  final int? minSizeInBytes;

  /// Creates a file size validator.
  const FileSizeValidator({
    this.maxSizeInBytes,
    this.minSizeInBytes,
    super.errorText,
    super.checkNullOrEmpty,
  }) : assert(maxSizeInBytes != null || minSizeInBytes != null,
            'At least one of maxSizeInBytes or minSizeInBytes must be provided');

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  @override
  String? validateValue(T valueCandidate) {
    int? sizeInBytes;

    if (valueCandidate is int) {
      sizeInBytes = valueCandidate;
    } else if (valueCandidate is String) {
      sizeInBytes = int.tryParse(valueCandidate);
    }

    if (sizeInBytes == null) {
      return errorText ?? 'File size must be a number';
    }

    if (minSizeInBytes != null && sizeInBytes < minSizeInBytes!) {
      return errorText ??
          'File size must be at least ${_formatBytes(minSizeInBytes!)}';
    }

    if (maxSizeInBytes != null && sizeInBytes > maxSizeInBytes!) {
      return errorText ??
          'File size must not exceed ${_formatBytes(maxSizeInBytes!)}';
    }

    return null;
  }
}

