import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires a collection to contain a specific element.
///
/// Example:
/// ```dart
/// JetCheckboxGroupField(
///   name: 'required_items',
///   validator: ContainsElementValidator('essential').validate,
/// )
/// ```
class ContainsElementValidator<T> extends BaseValidator<Iterable<T>> {
  /// The element that must be in the collection.
  final T element;

  /// Creates a contains-element validator.
  const ContainsElementValidator(
    this.element, {
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(Iterable<T> valueCandidate) {
    if (!valueCandidate.contains(element)) {
      return errorText ?? JetFormLocalizations.current.containsElementErrorText;
    }
    return null;
  }
}
