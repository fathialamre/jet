import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires a past date.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'birthdate',
///   validator: DatePastValidator().validate,
/// )
/// ```
class DatePastValidator<T> extends BaseValidator<T> {
  /// Creates a past date validator.
  const DatePastValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(T valueCandidate) {
    DateTime? date;

    if (valueCandidate is DateTime) {
      date = valueCandidate;
    } else if (valueCandidate is String) {
      try {
        date = DateTime.parse(valueCandidate);
      } catch (e) {
        return errorText ?? JetFormLocalizations.current.dateStringErrorText;
      }
    }

    if (date == null) {
      return errorText ?? JetFormLocalizations.current.dateStringErrorText;
    }

    if (!date.isBefore(DateTime.now())) {
      return errorText ?? JetFormLocalizations.current.dateMustBeInThePastErrorText;
    }

    return null;
  }
}
