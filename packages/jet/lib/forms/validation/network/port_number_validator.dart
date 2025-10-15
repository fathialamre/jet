import '../base_validator.dart';

/// Validator that requires a valid port number.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'port',
///   validator: PortNumberValidator().validate,
/// )
/// ```
class PortNumberValidator<T> extends BaseValidator<T> {
  /// The minimum port number (default: 1).
  final int min;

  /// The maximum port number (default: 65535).
  final int max;

  /// Creates a port number validator.
  const PortNumberValidator({
    this.min = 1,
    this.max = 65535,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(T valueCandidate) {
    int? port;

    if (valueCandidate is int) {
      port = valueCandidate;
    } else if (valueCandidate is String) {
      port = int.tryParse(valueCandidate);
    }

    if (port == null) {
      return errorText ?? 'Port must be a number';
    }

    if (port < min || port > max) {
      return errorText ?? 'Port must be between $min and $max';
    }

    return null;
  }
}
