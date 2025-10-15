import 'package:flutter/widgets.dart';
import '../base_validator.dart';

/// Validator that requires a non-empty value.
///
/// This validator checks that the field has a value and is not empty.
/// For strings, it also checks that the value is not just whitespace.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'username',
///   validator: RequiredValidator().validate,
/// )
/// ```
class RequiredValidator<T> extends BaseValidator<T> {
  /// Creates a required validator.
  ///
  /// [errorText]: Custom error message (optional)
  const RequiredValidator({super.errorText}) : super(checkNullOrEmpty: true);

  @override
  String? validateValue(T valueCandidate) {
    // If we reach here, the value is not null or empty
    // So it's valid
    return null;
  }

  @override
  String? get errorText => super.errorText ?? 'This field is required';
}
