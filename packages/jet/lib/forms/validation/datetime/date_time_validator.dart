import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires a valid datetime string.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'appointment',
///   validator: DateTimeValidator().validate,
/// )
/// ```
class DateTimeValidator extends BaseValidator<String> {
  /// Creates a datetime validator.
  const DateTimeValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    try {
      DateTime.parse(valueCandidate);
      return null;
    } catch (e) {
      return errorText ?? JetFormLocalizations.current.dateStringErrorText;
    }
  }
}
