import '../base_validator.dart';

/// Validator that requires a valid file/directory path.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'path',
///   validator: PathValidator().validate,
/// )
/// ```
class PathValidator extends BaseValidator<String> {
  /// Whether to allow absolute paths only
  final bool absoluteOnly;

  /// Whether to allow relative paths only
  final bool relativeOnly;

  /// Creates a path validator.
  const PathValidator({
    this.absoluteOnly = false,
    this.relativeOnly = false,
    super.errorText,
    super.checkNullOrEmpty,
  }) : assert(
         !(absoluteOnly && relativeOnly),
         'Cannot require both absolute and relative paths',
       );

  @override
  String? validateValue(String valueCandidate) {
    // Check for invalid path characters
    final invalidChars = RegExp(r'[<>"|?*\x00-\x1F]');
    if (invalidChars.hasMatch(valueCandidate)) {
      return errorText ?? 'Path contains invalid characters';
    }

    final isAbsolute =
        valueCandidate.startsWith('/') ||
        RegExp(r'^[A-Za-z]:\\').hasMatch(valueCandidate);

    if (absoluteOnly && !isAbsolute) {
      return errorText ?? 'Path must be absolute';
    }

    if (relativeOnly && isAbsolute) {
      return errorText ?? 'Path must be relative';
    }

    return null;
  }
}
