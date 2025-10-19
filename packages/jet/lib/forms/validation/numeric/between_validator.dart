import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires a value to be between min and max (inclusive).
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'rating',
///   validator: BetweenValidator(1, 5).validate,
/// )
/// ```
class BetweenValidator<T> extends BaseValidator<T> {
  /// The minimum value (inclusive).
  final num min;

  /// The maximum value (inclusive).
  final num max;

  /// Creates a between validator.
  const BetweenValidator(
    this.min,
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
      return errorText ?? 'Value must be numeric';
    }

    if (value < min || value > max) {
      return errorText ??
          JetFormLocalizations.current.betweenErrorText(min, max);
    }
    return null;
  }
}
