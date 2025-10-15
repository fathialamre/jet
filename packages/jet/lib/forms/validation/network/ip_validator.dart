import '../base_validator.dart';

/// Validator that requires a valid IP address (v4 or v6).
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'ip_address',
///   validator: IpValidator().validate,
/// )
/// ```
class IpValidator extends BaseValidator<String> {
  /// IP version to validate (4, 6, or null for both).
  final int? version;

  /// Creates an IP validator.
  const IpValidator({
    this.version,
    super.errorText,
    super.checkNullOrEmpty,
  });

  bool _isValidIPv4(String value) {
    final parts = value.split('.');
    if (parts.length != 4) return false;

    for (final part in parts) {
      final num = int.tryParse(part);
      if (num == null || num < 0 || num > 255) return false;
    }

    return true;
  }

  bool _isValidIPv6(String value) {
    // Simplified IPv6 validation
    final pattern = RegExp(
      r'^(([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$',
    );
    return pattern.hasMatch(value);
  }

  @override
  String? validateValue(String valueCandidate) {
    if (version == 4 || version == null) {
      if (_isValidIPv4(valueCandidate)) return null;
    }

    if (version == 6 || version == null) {
      if (_isValidIPv6(valueCandidate)) return null;
    }

    final versionText = version != null ? 'IPv$version' : 'IP';
    return errorText ?? 'Please enter a valid $versionText address';
  }
}
