import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires a negative number (< 0).
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'deficit',
///   validator: NegativeNumberValidator().validate,
/// )
/// ```
class NegativeNumberValidator<T> extends BaseValidator<T> {
  /// Creates a negative number validator.
  const NegativeNumberValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(T valueCandidate) {
    num? value;

    if (valueCandidate is num) {
      value = valueCandidate;
    } else if (valueCandidate is String) {
      value = num.tryParse(valueCandidate);
    }

    if (value == null) {
      return errorText ?? 'Value must be numeric';
    }

    if (value >= 0) {
      return errorText ?? JetFormLocalizations.current.negativeNumberErrorText;
    }
    return null;
  }
}
