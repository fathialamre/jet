import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires the value to NOT equal a specific value.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'new_password',
///   validator: NotEqualValidator(oldPassword).validate,
/// )
/// ```
class NotEqualValidator<T> extends BaseValidator<T> {
  /// The value that the field must not equal.
  final Object comparisonValue;

  /// Creates a not-equal validator.
  ///
  /// [comparisonValue]: The value to compare against
  /// [errorText]: Custom error message (optional)
  /// [checkNullOrEmpty]: Whether to check for null/empty (default: true)
  const NotEqualValidator(
    this.comparisonValue, {
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(T valueCandidate) {
    if (valueCandidate == comparisonValue) {
      return errorText ??
          JetFormLocalizations.current.notEqualErrorText(
            comparisonValue.toString(),
          );
    }
    return null;
  }
}
