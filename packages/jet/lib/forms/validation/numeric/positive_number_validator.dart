import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires a positive number (> 0).
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'amount',
///   validator: PositiveNumberValidator().validate,
/// )
/// ```
class PositiveNumberValidator<T> extends BaseValidator<T> {
  /// Creates a positive number validator.
  const PositiveNumberValidator({
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

    if (value <= 0) {
      return errorText ?? JetFormLocalizations.current.positiveNumberErrorText;
    }
    return null;
  }
}
