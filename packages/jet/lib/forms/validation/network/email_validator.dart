import '../base_validator.dart';

/// Validator that requires a valid email address.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'email',
///   validator: EmailValidator().validate,
/// )
/// ```
class EmailValidator extends BaseValidator<String> {
  /// Custom email regex pattern (optional)
  final RegExp? regex;

  /// Creates an email validator.
  const EmailValidator({
    this.regex,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    final pattern =
        regex ??
        RegExp(
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
        );

    if (!pattern.hasMatch(valueCandidate)) {
      return errorText ?? 'Please enter a valid email address';
    }
    return null;
  }
}
