import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires the value to be a single line (no newlines).
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'title',
///   validator: SingleLineValidator().validate,
/// )
/// ```
class SingleLineValidator extends BaseValidator<String> {
  /// Creates a single-line validator.
  const SingleLineValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    if (valueCandidate.contains('\n') || valueCandidate.contains('\r')) {
      return errorText ?? JetFormLocalizations.current.singleLineErrorText;
    }
    return null;
  }
}
