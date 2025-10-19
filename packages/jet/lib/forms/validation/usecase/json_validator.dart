import 'dart:convert';
import 'package:jet/forms/localization/jet_form_localizations.dart';
import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires valid JSON.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'json_data',
///   validator: JsonValidator().validate,
/// )
/// ```
class JsonValidator extends BaseValidator<String> {
  /// Creates a JSON validator.
  const JsonValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    try {
      jsonDecode(valueCandidate);
      return null;
    } catch (e) {
      return errorText ?? 'Value must be valid JSON';
    }
  }
}
