import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires the value to equal a specific value.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'confirm_password',
///   validator: EqualValidator('password123').validate,
/// )
/// ```
class EqualValidator<T> extends BaseValidator<T> {
  /// The value that the field must equal.
  final Object comparisonValue;

  /// Creates an equal validator.
  ///
  /// [comparisonValue]: The value to compare against
  /// [errorText]: Custom error message (optional)
  /// [checkNullOrEmpty]: Whether to check for null/empty (default: true)
  const EqualValidator(
    this.comparisonValue, {
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(T valueCandidate) {
    if (valueCandidate != comparisonValue) {
      return errorText ?? 'Value must be equal to $comparisonValue';
    }
    return null;
  }
}
