import 'package:flutter/widgets.dart';

/// Extension methods for composing and chaining validators.
extension ValidatorExtensions<T> on FormFieldValidator<T> {
  /// Combines this validator with another validator using AND logic.
  ///
  /// Both validators must pass for the combined validator to pass.
  ///
  /// Example:
  /// ```dart
  /// final validator = JetValidators.required<String>()
  ///     .and(JetValidators.email());
  /// ```
  FormFieldValidator<T> and(FormFieldValidator<T> other) {
    return (T? value) {
      final result1 = this(value);
      if (result1 != null) return result1;
      return other(value);
    };
  }

  /// Combines this validator with another validator using OR logic.
  ///
  /// At least one validator must pass for the combined validator to pass.
  ///
  /// Example:
  /// ```dart
  /// final validator = JetValidators.email()
  ///     .or(JetValidators.phoneNumber());
  /// ```
  FormFieldValidator<T> or(FormFieldValidator<T> other) {
    return (T? value) {
      final result1 = this(value);
      if (result1 == null) return null;
      final result2 = other(value);
      if (result2 == null) return null;
      return result1; // Return first error if both fail
    };
  }

  /// Applies this validator only when the condition is true.
  ///
  /// Example:
  /// ```dart
  /// final validator = JetValidators.required<String>()
  ///     .when(() => showAdvancedFields);
  /// ```
  FormFieldValidator<T> when(bool Function() condition) {
    return (T? value) {
      if (!condition()) return null;
      return this(value);
    };
  }

  /// Transforms the value before validation.
  ///
  /// Example:
  /// ```dart
  /// final validator = JetValidators.minLength(5)
  ///     .transform((value) => value?.trim());
  /// ```
  FormFieldValidator<T> transform(T? Function(T? value) transformer) {
    return (T? value) {
      final transformed = transformer(value);
      return this(transformed);
    };
  }
}

/// Extension for nullable validators
extension NullableValidatorExtensions<T> on FormFieldValidator<T>? {
  /// Safely applies the validator if it's not null.
  ///
  /// Returns null if the validator is null.
  FormFieldValidator<T>? orNull() => this;
}
