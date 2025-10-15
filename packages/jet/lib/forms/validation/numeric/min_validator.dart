import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires a minimum numeric value.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'age',
///   validator: MinValidator(18).validate,
/// )
/// ```
class MinValidator<T> extends BaseValidator<T> {
  /// The minimum value allowed.
  final num min;

  /// Creates a minimum value validator.
  const MinValidator(
    this.min, {
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

    if (value < min) {
      return errorText ?? JetFormLocalizations.current.minErrorText(min);
    }
    return null;
  }
}
