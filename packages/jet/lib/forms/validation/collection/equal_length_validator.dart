import '../base_validator.dart';

/// Validator that requires an exact length for collections/strings.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'pin',
///   validator: EqualLengthValidator(4).validate,
/// )
/// ```
class EqualLengthValidator<T> extends BaseValidator<T> {
  /// The exact length required.
  final int length;

  /// Creates an equal length validator.
  const EqualLengthValidator(
    this.length, {
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(T valueCandidate) {
    int? actualLength;

    if (valueCandidate is String) {
      actualLength = valueCandidate.length;
    } else if (valueCandidate is Iterable) {
      actualLength = valueCandidate.length;
    } else if (valueCandidate is Map) {
      actualLength = valueCandidate.length;
    }

    if (actualLength == null) {
      return errorText ?? 'Value must be a string or collection';
    }

    if (actualLength != length) {
      return errorText ?? 'Value must have a length equal to $length';
    }
    return null;
  }
}
