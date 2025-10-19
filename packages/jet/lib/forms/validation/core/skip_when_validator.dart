import 'package:flutter/widgets.dart';
import '../base_validator.dart';

/// Validator that skips validation when a condition is met.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'optional_field',
///   validator: SkipWhenValidator<String>(
///     (value) => value == null || value.isEmpty,
///     RequiredValidator().validate,
///   ).validate,
/// )
/// ```
class SkipWhenValidator<T> extends BaseValidator<T> {
  /// Function that determines if validation should be skipped.
  final bool Function(T? value) condition;

  /// The validator to apply if the condition is false.
  final FormFieldValidator<T> validator;

  /// Creates a skip-when validator.
  ///
  /// [condition]: Function that returns true to skip validation
  /// [validator]: The validator to apply when condition is false
  const SkipWhenValidator(
    this.condition,
    this.validator, {
    super.checkNullOrEmpty = false,
  });

  @override
  String? validate(T? valueCandidate) {
    if (condition(valueCandidate)) {
      return null; // Skip validation
    }
    return validator(valueCandidate);
  }

  @override
  String? validateValue(T valueCandidate) {
    // Not used in skip-when validator
    return null;
  }
}
