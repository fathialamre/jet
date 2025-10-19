import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires an integer value.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'count',
///   validator: IntegerValidator().validate,
/// )
/// ```
class IntegerValidator extends BaseValidator<String> {
  /// Creates an integer validator.
  const IntegerValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    if (int.tryParse(valueCandidate) == null) {
      return errorText ?? JetFormLocalizations.current.integerErrorText;
    }
    return null;
  }
}
