import 'package:flutter/widgets.dart';
import '../base_validator.dart';

/// Validator that runs all validators and collects all error messages.
///
/// Unlike ComposeValidator which returns the first error,
/// this validator returns all errors combined.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'password',
///   validator: AggregateValidator<String>([
///     MinLengthValidator(8).validate,
///     HasUppercaseCharsValidator().validate,
///     HasNumericCharsValidator().validate,
///   ]).validate,
/// )
/// ```
class AggregateValidator<T> extends BaseValidator<T> {
  /// List of validators to run.
  final List<FormFieldValidator<T>> validators;

  /// Separator to use between error messages.
  final String separator;

  /// Creates an aggregate validator.
  ///
  /// [validators]: List of validators to run
  /// [separator]: Separator between error messages (default: ', ')
  const AggregateValidator(
    this.validators, {
    this.separator = ', ',
    super.checkNullOrEmpty = false,
  });

  @override
  String? validate(T? valueCandidate) {
    final errors = <String>[];

    for (final validator in validators) {
      final result = validator(valueCandidate);
      if (result != null) {
        errors.add(result);
      }
    }

    if (errors.isEmpty) {
      return null;
    }

    return errors.join(separator);
  }

  @override
  String? validateValue(T valueCandidate) {
    // Not used in aggregate validator
    return null;
  }
}
