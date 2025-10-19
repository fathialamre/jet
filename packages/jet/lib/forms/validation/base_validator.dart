/// Base class for all validators in the Jet Framework.
///
/// Validators check if a field value is valid and return an error message
/// if validation fails, or null if the value is valid.
///
/// Example:
/// ```dart
/// class MyValidator extends BaseValidator<String> {
///   const MyValidator({super.errorText, super.checkNullOrEmpty});
///
///   @override
///   String? validateValue(String valueCandidate) {
///     if (valueCandidate.length < 3) {
///       return errorText ?? 'Value must be at least 3 characters';
///     }
///     return null;
///   }
/// }
/// ```
abstract class BaseValidator<T> {
  /// Creates a new instance of the validator.
  ///
  /// [errorText]: Custom error message to return when validation fails.
  /// [checkNullOrEmpty]: Whether to check if the value is null or empty before validating.
  const BaseValidator({String? errorText, this.checkNullOrEmpty = true})
    : _errorText = errorText;

  /// Backing field for [errorText].
  final String? _errorText;

  /// The error message returned if the value is invalid.
  String? get errorText => _errorText;

  /// Whether to check if the value is null or empty.
  ///
  /// When true, the validator returns an error if the value is null or empty.
  /// When false, null or empty values pass validation automatically.
  final bool checkNullOrEmpty;

  /// Validates the value and checks if it is null or empty.
  ///
  /// Returns null if the value is valid, otherwise returns an error message.
  String? validate(T? valueCandidate) {
    final bool isNullOrEmpty = this.isNullOrEmpty(valueCandidate);

    if (checkNullOrEmpty && isNullOrEmpty) {
      return errorText;
    } else if (!checkNullOrEmpty && isNullOrEmpty) {
      return null;
    } else {
      return validateValue(valueCandidate as T);
    }
  }

  /// Checks if the value is null or empty.
  ///
  /// Returns `true` if the value is null or empty, otherwise `false`.
  ///
  /// The value is considered empty if it is:
  /// - A [String] that is empty or contains only whitespace
  /// - An [Iterable] that is empty
  /// - A [Map] that is empty
  /// - null
  bool isNullOrEmpty(T? valueCandidate) {
    return valueCandidate == null ||
        (valueCandidate is String && valueCandidate.trim().isEmpty) ||
        (valueCandidate is Iterable && valueCandidate.isEmpty) ||
        (valueCandidate is Map && valueCandidate.isEmpty);
  }

  /// Validates the value.
  ///
  /// Returns `null` if the value is valid, otherwise an error message.
  ///
  /// Call [validate] instead of this method when using the validator.
  /// This method is called by [validate] after null/empty checking.
  String? validateValue(T valueCandidate);
}
