import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires a valid UUID.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'id',
///   validator: UuidValidator().validate,
/// )
/// ```
class UuidValidator extends BaseValidator<String> {
  /// UUID version to validate (1-5, or null for any)
  final int? version;

  /// Creates a UUID validator.
  const UuidValidator({
    this.version,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    // UUID format: 8-4-4-4-12 hexadecimal digits
    final pattern = version != null
        ? RegExp(
            r'^[0-9a-f]{8}-[0-9a-f]{4}-' +
                version.toString() +
                r'[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
            caseSensitive: false,
          )
        : RegExp(
            r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
            caseSensitive: false,
          );

    if (!pattern.hasMatch(valueCandidate)) {
      final versionText = version != null ? ' v$version' : '';
      return errorText ?? 'Please enter a valid UUID$versionText';
    }

    return null;
  }
}
