import 'package:flutter/widgets.dart';
import '../base_validator.dart';

/// Validator that transforms the value before applying another validator.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'username',
///   validator: TransformValidator<String>(
///     (value) => value?.trim().toLowerCase(),
///     MinLengthValidator(3).validate,
///   ).validate,
/// )
/// ```
class TransformValidator<T> extends BaseValidator<T> {
  /// Function to transform the value before validation.
  final T Function(T? value) transformer;

  /// The validator to apply after transformation.
  final FormFieldValidator<T> validator;

  /// Creates a transform validator.
  ///
  /// [transformer]: Function to transform the value
  /// [validator]: Validator to apply to transformed value
  const TransformValidator(
    this.transformer,
    this.validator, {
    super.checkNullOrEmpty = false,
  });

  @override
  String? validate(T? valueCandidate) {
    final transformed = transformer(valueCandidate);
    return validator(transformed);
  }

  @override
  String? validateValue(T valueCandidate) {
    // Not used in transform validator
    return null;
  }
}

