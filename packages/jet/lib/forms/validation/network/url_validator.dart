import '../base_validator.dart';

/// Validator that requires a valid URL.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'website',
///   validator: UrlValidator().validate,
/// )
/// ```
class UrlValidator extends BaseValidator<String> {
  /// Whether to require http/https protocol.
  final bool requireProtocol;

  /// Allowed protocols (default: http, https)
  final List<String> protocols;

  /// Whether to allow localhost.
  final bool allowLocalhost;

  /// Creates a URL validator.
  const UrlValidator({
    this.requireProtocol = true,
    this.protocols = const ['http', 'https'],
    this.allowLocalhost = false,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    try {
      final uri = Uri.parse(valueCandidate);

      if (requireProtocol && !uri.hasScheme) {
        return errorText ?? 'URL must include protocol (http:// or https://)';
      }

      if (uri.hasScheme && !protocols.contains(uri.scheme)) {
        return errorText ?? 'URL must use one of: ${protocols.join(', ')}';
      }

      if (!allowLocalhost &&
          (uri.host == 'localhost' || uri.host == '127.0.0.1')) {
        return errorText ?? 'Localhost URLs are not allowed';
      }

      if (uri.host.isEmpty) {
        return errorText ?? 'URL must include a valid host';
      }

      return null;
    } catch (e) {
      return errorText ?? 'Please enter a valid URL';
    }
  }
}
