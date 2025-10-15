import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires a hexadecimal number.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'hex_value',
///   validator: HexadecimalValidator().validate,
/// )
/// ```
class HexadecimalValidator extends BaseValidator<String> {
  /// Whether to allow 0x prefix.
  final bool allowPrefix;

  /// Creates a hexadecimal validator.
  const HexadecimalValidator({
    this.allowPrefix = true,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    String value = valueCandidate;

    if (allowPrefix && value.startsWith('0x')) {
      value = value.substring(2);
    }

    final pattern = RegExp(r'^[0-9A-Fa-f]+$');

    if (!pattern.hasMatch(value)) {
      return errorText ?? 'Value must be a valid hexadecimal number';
    }
    return null;
  }
}
