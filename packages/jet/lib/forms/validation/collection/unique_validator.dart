import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires all elements in a collection to be unique.
///
/// Example:
/// ```dart
/// JetCheckboxGroupField(
///   name: 'selections',
///   validator: UniqueValidator().validate,
/// )
/// ```
class UniqueValidator<T> extends BaseValidator<Iterable<T>> {
  /// Creates a unique validator.
  const UniqueValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(Iterable<T> valueCandidate) {
    final set = valueCandidate.toSet();

    if (set.length != valueCandidate.length) {
      return errorText ?? 'All values must be unique';
    }
    return null;
  }
}
