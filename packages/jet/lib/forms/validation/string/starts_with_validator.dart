import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires the value to start with a specific substring.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'phone',
///   validator: StartsWithValidator('+1').validate,
/// )
/// ```
class StartsWithValidator extends BaseValidator<String> {
  /// The prefix that the value must start with.
  final String prefix;

  /// Creates a starts-with validator.
  const StartsWithValidator(
    this.prefix, {
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    if (!valueCandidate.startsWith(prefix)) {
      return errorText ?? 'Value must start with "$prefix"';
    }
    return null;
  }
}
