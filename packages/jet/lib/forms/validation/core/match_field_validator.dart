import 'package:flutter/material.dart';
import '../base_validator.dart';
import '../../core/jet_form_field.dart';

/// Validator that requires the value to match another field in the form.
///
/// This validator compares the current field's value with another field's value
/// from the same form. Useful for password confirmation, email confirmation, etc.
///
/// Example:
/// ```dart
/// final formKey = GlobalKey<JetFormState>();
///
/// JetPasswordField(
///   name: 'password_confirmation',
///   validator: MatchFieldValidator<String>(
///     formKey,
///     'password',
///     errorText: 'Passwords do not match',
///   ).validate,
/// )
/// ```
class MatchFieldValidator<T> extends BaseValidator<T> {
  /// The form key used to access form state and field values.
  final GlobalKey<JetFormState> formKey;

  /// The name of the field to match against.
  final String fieldName;

  /// Creates a match field validator.
  ///
  /// [formKey]: The form key to access form state
  /// [fieldName]: The name of the field to compare against
  /// [errorText]: Custom error message (optional)
  /// [checkNullOrEmpty]: Whether to check for null/empty (default: false)
  const MatchFieldValidator(
    this.formKey,
    this.fieldName, {
    super.errorText,
    super.checkNullOrEmpty = false,
  });

  @override
  String? validateValue(T valueCandidate) {
    final formState = formKey.currentState;

    if (formState == null) {
      // Form state not available yet, skip validation
      return null;
    }

    // Get the value of the field to match against
    final matchValue = formState.getRawValue<T>(fieldName);

    // Compare values
    if (valueCandidate != matchValue) {
      return errorText ?? 'Value does not match $fieldName';
    }

    return null;
  }
}
