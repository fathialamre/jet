import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires a valid latitude (-90 to 90).
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'latitude',
///   validator: LatitudeValidator().validate,
/// )
/// ```
class LatitudeValidator<T> extends BaseValidator<T> {
  /// Creates a latitude validator.
  const LatitudeValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(T valueCandidate) {
    double? value;

    if (valueCandidate is double) {
      value = valueCandidate;
    } else if (valueCandidate is num) {
      value = (valueCandidate as num).toDouble();
    } else if (valueCandidate is String) {
      value = double.tryParse(valueCandidate);
    }

    if (value == null) {
      return errorText ?? 'Latitude must be a number';
    }

    if (value < -90 || value > 90) {
      return errorText ?? 'Latitude must be between -90 and 90';
    }

    return null;
  }
}
