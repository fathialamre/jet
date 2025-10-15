import '../base_validator.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';

/// Validator that requires a valid MAC address.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'mac_address',
///   validator: MacAddressValidator().validate,
/// )
/// ```
class MacAddressValidator extends BaseValidator<String> {
  /// Creates a MAC address validator.
  const MacAddressValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    // Supports both : and - separators, and no separator
    final patterns = [
      RegExp(r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$'), // With separators
      RegExp(r'^[0-9A-Fa-f]{12}$'), // Without separators
    ];

    for (final pattern in patterns) {
      if (pattern.hasMatch(valueCandidate)) return null;
    }

    return errorText ?? 'Please enter a valid MAC address';
  }
}
