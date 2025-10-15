import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires a valid longitude (-180 to 180).
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'longitude',
///   validator: LongitudeValidator().validate,
/// )
/// ```
class LongitudeValidator<T> extends BaseValidator<T> {
  /// Creates a longitude validator.
  const LongitudeValidator({
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
      return errorText ?? 'Longitude must be a number';
    }

    if (value < -180 || value > 180) {
      return errorText ?? 'Longitude must be between -180 and 180';
    }

    return null;
  }
}
