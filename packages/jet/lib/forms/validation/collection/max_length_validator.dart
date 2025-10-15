import '../base_validator.dart';

/// Validator that requires a maximum length for collections/strings.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'username',
///   validator: MaxLengthValidator(20).validate,
/// )
/// ```
class MaxLengthValidator<T> extends BaseValidator<T> {
  /// The maximum length allowed.
  final int maxLength;

  /// Creates a maximum length validator.
  const MaxLengthValidator(
    this.maxLength, {
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(T valueCandidate) {
    int? length;

    if (valueCandidate is String) {
      length = valueCandidate.length;
    } else if (valueCandidate is Iterable) {
      length = valueCandidate.length;
    } else if (valueCandidate is Map) {
      length = valueCandidate.length;
    }

    if (length == null) {
      return errorText ?? 'Value must be a string or collection';
    }

    if (length > maxLength) {
      return errorText ??
          'Value must have a length less than or equal to $maxLength';
    }
    return null;
  }
}

