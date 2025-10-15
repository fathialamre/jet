import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires collection length to be within a range.
///
/// Example:
/// ```dart
/// JetCheckboxGroupField(
///   name: 'selections',
///   validator: RangeValidator(minLength: 1, maxLength: 5).validate,
/// )
/// ```
class RangeValidator<T> extends BaseValidator<T> {
  /// The minimum length (inclusive).
  final int? minLength;

  /// The maximum length (inclusive).
  final int? maxLength;

  /// Creates a range validator.
  const RangeValidator({
    this.minLength,
    this.maxLength,
    super.errorText,
    super.checkNullOrEmpty,
  }) : assert(
         minLength != null || maxLength != null,
         'At least one of minLength or maxLength must be provided',
       );

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

    if (minLength != null && length < minLength!) {
      return errorText ??
          'Value must have a length greater than or equal to $minLength';
    }

    if (maxLength != null && length > maxLength!) {
      return errorText ??
          'Value must have a length less than or equal to $maxLength';
    }

    return null;
  }
}
