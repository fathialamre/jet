import 'package:flutter/widgets.dart';
import '../base_validator.dart';

/// Validator that composes multiple validators into one.
///
/// All validators must pass for the composite validator to pass.
/// Returns the first error encountered.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'email',
///   validator: ComposeValidator<String>([
///     RequiredValidator().validate,
///     EmailValidator().validate,
///   ]).validate,
/// )
/// ```
class ComposeValidator<T> extends BaseValidator<T> {
  /// List of validators to compose.
  final List<FormFieldValidator<T>> validators;

  /// Creates a compose validator.
  ///
  /// [validators]: List of validators to run sequentially
  const ComposeValidator(this.validators, {super.checkNullOrEmpty = false});

  @override
  String? validate(T? valueCandidate) {
    // For compose validator, we run each validator
    // and return the first error
    for (final validator in validators) {
      final result = validator(valueCandidate);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  @override
  String? validateValue(T valueCandidate) {
    // Not used in compose validator
    return null;
  }
}

