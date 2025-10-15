import 'package:flutter/widgets.dart';
import '../base_validator.dart';

/// Validator that passes if ANY of the validators pass (OR logic).
///
/// At least one validator must pass for this validator to pass.
/// Returns an error only if all validators fail.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'contact',
///   validator: OrValidator<String>([
///     EmailValidator().validate,
///     PhoneNumberValidator().validate,
///   ]).validate,
/// )
/// ```
class OrValidator<T> extends BaseValidator<T> {
  /// List of validators (at least one must pass).
  final List<FormFieldValidator<T>> validators;

  /// Creates an OR validator.
  ///
  /// [validators]: List of validators (at least one must pass)
  /// [errorText]: Custom error message (optional)
  const OrValidator(
    this.validators, {
    super.errorText,
    super.checkNullOrEmpty = false,
  });

  @override
  String? validate(T? valueCandidate) {
    // At least one validator must return null (valid)
    for (final validator in validators) {
      final result = validator(valueCandidate);
      if (result == null) {
        return null; // At least one passed, so we're valid
      }
    }
    // All validators failed
    return errorText ?? 'Value does not meet any of the required criteria';
  }

  @override
  String? validateValue(T valueCandidate) {
    // Not used in OR validator
    return null;
  }
}

