import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires a maximum numeric value.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'percentage',
///   validator: MaxValidator(100).validate,
/// )
/// ```
class MaxValidator<T> extends BaseValidator<T> {
  /// The maximum value allowed.
  final num max;

  /// Creates a maximum value validator.
  const MaxValidator(
    this.max, {
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
      return errorText ?? JetFormLocalizations.current.numericErrorText;
    }

    if (value > max) {
      return errorText ?? JetFormLocalizations.current.maxErrorText(max);
    }
    return null;
  }
}
