import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires a floating point number.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'price',
///   validator: FloatValidator().validate,
/// )
/// ```
class FloatValidator extends BaseValidator<String> {
  /// Creates a float validator.
  const FloatValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    if (double.tryParse(valueCandidate) == null) {
      return errorText ?? 'Value must be a valid floating point number';
    }
    return null;
  }
}
