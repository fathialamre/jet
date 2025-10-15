import 'package:flutter/widgets.dart';
import '../base_validator.dart';

/// Validator that conditionally applies another validator.
///
/// The validator is only applied if the condition function returns true.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'optional_email',
///   validator: ConditionalValidator<String>(
///     (value) => value != null && value.isNotEmpty,
///     EmailValidator().validate,
///   ).validate,
/// )
/// ```
class ConditionalValidator<T> extends BaseValidator<T> {
  /// Function that determines if the validator should be applied.
  final bool Function(T? value) condition;

  /// The validator to apply if the condition is true.
  final FormFieldValidator<T> validator;

  /// Creates a conditional validator.
  ///
  /// [condition]: Function that returns true if validation should occur
  /// [validator]: The validator to apply when condition is true
  const ConditionalValidator(
    this.condition,
    this.validator, {
    super.checkNullOrEmpty = false,
  });

  @override
  String? validate(T? valueCandidate) {
    if (!condition(valueCandidate)) {
      return null; // Condition not met, skip validation
    }
    return validator(valueCandidate);
  }

  @override
  String? validateValue(T valueCandidate) {
    // Not used in conditional validator
    return null;
  }
}

