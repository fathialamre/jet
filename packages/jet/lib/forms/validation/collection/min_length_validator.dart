import '../base_validator.dart';

/// Validator that requires a minimum length for collections/strings.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'password',
///   validator: MinLengthValidator(8).validate,
/// )
/// ```
class MinLengthValidator<T> extends BaseValidator<T> {
  /// The minimum length required.
  final int minLength;

  /// Creates a minimum length validator.
  const MinLengthValidator(
    this.minLength, {
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

    if (length < minLength) {
      return errorText ??
          'Value must have a length greater than or equal to $minLength';
    }
    return null;
  }
}

