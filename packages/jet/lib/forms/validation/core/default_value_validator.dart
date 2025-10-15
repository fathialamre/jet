import 'package:flutter/widgets.dart';
import '../base_validator.dart';

/// Validator that provides a default value if the value is null or empty.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'count',
///   validator: DefaultValueValidator<String>(
///     '0',
///     NumericValidator().validate,
///   ).validate,
/// )
/// ```
class DefaultValueValidator<T> extends BaseValidator<T> {
  /// The default value to use if the value is null or empty.
  final T defaultValue;

  /// The validator to apply after applying the default.
  final FormFieldValidator<T> validator;

  /// Creates a default value validator.
  ///
  /// [defaultValue]: The default value to use
  /// [validator]: The validator to apply
  const DefaultValueValidator(
    this.defaultValue,
    this.validator, {
    super.checkNullOrEmpty = false,
  });

  @override
  String? validate(T? valueCandidate) {
    final value = isNullOrEmpty(valueCandidate) ? defaultValue : valueCandidate;
    return validator(value);
  }

  @override
  String? validateValue(T valueCandidate) {
    // Not used in default value validator
    return null;
  }
}
