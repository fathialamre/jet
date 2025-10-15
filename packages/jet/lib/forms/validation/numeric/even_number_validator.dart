import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires an even number.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'pair_count',
///   validator: EvenNumberValidator().validate,
/// )
/// ```
class EvenNumberValidator<T> extends BaseValidator<T> {
  /// Creates an even number validator.
  const EvenNumberValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(T valueCandidate) {
    int? value;

    if (valueCandidate is int) {
      value = valueCandidate;
    } else if (valueCandidate is num) {
      value = (valueCandidate as num).toInt();
    } else if (valueCandidate is String) {
      value = int.tryParse(valueCandidate);
    }

    if (value == null) {
      return errorText ?? 'Value must be an integer';
    }

    if (value % 2 != 0) {
      return errorText ?? JetFormLocalizations.current.evenNumberErrorText;
    }
    return null;
  }
}
