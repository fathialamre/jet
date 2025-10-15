import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

/// Jet framework wrapper for form field validators.
///
/// This class provides a clean API for form validation without requiring
/// users to directly import flutter_form_builder packages.
///
/// Example usage:
/// ```dart
/// JetEmailField(
///   name: 'email',
///   validator: JetValidators.compose([
///     JetValidators.required(),
///     JetValidators.email(),
///   ]),
/// )
/// ```
class JetValidators {
  JetValidators._(); // Private constructor to prevent instantiation

  /// Compose multiple validators into one
  static FormFieldValidator<T> compose<T>(
    List<FormFieldValidator<T>?> validators,
  ) {
    return FormBuilderValidators.compose(
      validators.whereType<FormFieldValidator<T>>().toList(),
    );
  }

  /// Requires the field to have a non-empty value
  static FormFieldValidator<T> required<T>({
    String? errorText,
  }) {
    return FormBuilderValidators.required<T>(errorText: errorText);
  }

  /// Validates that the value is a valid email address
  static FormFieldValidator<String> email({
    String? errorText,
  }) {
    return FormBuilderValidators.email(errorText: errorText);
  }

  /// Validates that the value matches a regular expression pattern
  static FormFieldValidator<String> match(
    String pattern, {
    String? errorText,
  }) {
    return FormBuilderValidators.match(RegExp(pattern), errorText: errorText);
  }

  /// Validates that the value is numeric
  static FormFieldValidator<String> numeric({
    String? errorText,
  }) {
    return FormBuilderValidators.numeric(errorText: errorText);
  }

  /// Validates minimum length of a string
  static FormFieldValidator<String> minLength(
    int minLength, {
    String? errorText,
  }) {
    return FormBuilderValidators.minLength(minLength, errorText: errorText);
  }

  /// Validates maximum length of a string
  static FormFieldValidator<String> maxLength(
    int maxLength, {
    String? errorText,
  }) {
    return FormBuilderValidators.maxLength(maxLength, errorText: errorText);
  }

  /// Validates minimum value of a number
  static FormFieldValidator<num> min(
    num min, {
    String? errorText,
  }) {
    return FormBuilderValidators.min(min, errorText: errorText);
  }

  /// Validates maximum value of a number
  static FormFieldValidator<num> max(
    num max, {
    String? errorText,
  }) {
    return FormBuilderValidators.max(max, errorText: errorText);
  }

  /// Validates that the value equals a specific value
  static FormFieldValidator<T> equal<T>(
    Object value, {
    String? errorText,
  }) {
    return FormBuilderValidators.equal(value, errorText: errorText);
  }

  /// Validates that the value does not equal a specific value
  static FormFieldValidator<T> notEqual<T>(
    Object value, {
    String? errorText,
  }) {
    return FormBuilderValidators.notEqual(value, errorText: errorText);
  }

  /// Validates that the value is a valid URL
  static FormFieldValidator<String> url({
    String? errorText,
    List<String> protocols = const ['http', 'https', 'ftp'],
    bool requireTld = true,
    bool requireProtocol = false,
    bool allowUnderscore = false,
    List<String> hostWhitelist = const [],
    List<String> hostBlacklist = const [],
  }) {
    return FormBuilderValidators.url(
      errorText: errorText,
      protocols: protocols,
      requireTld: requireTld,
      requireProtocol: requireProtocol,
      allowUnderscore: allowUnderscore,
      hostWhitelist: hostWhitelist,
      hostBlacklist: hostBlacklist,
    );
  }

  /// Validates that the value is a valid credit card number
  static FormFieldValidator<String> creditCard({
    String? errorText,
  }) {
    return FormBuilderValidators.creditCard(errorText: errorText);
  }

  /// Validates that the value is a valid IP address
  static FormFieldValidator<String> ip({
    String? errorText,
    int version = 4,
  }) {
    return FormBuilderValidators.ip(errorText: errorText, version: version);
  }

  /// Validates that the value is a valid date string
  static FormFieldValidator<String> dateString({
    String? errorText,
  }) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;
      if (DateTime.tryParse(value) == null) {
        return errorText ?? 'Please enter a valid date';
      }
      return null;
    };
  }

  /// Validates that the value is a valid phone number
  static FormFieldValidator<String> phoneNumber({
    String? errorText,
  }) {
    return FormBuilderValidators.phoneNumber(errorText: errorText);
  }

  /// Validates that the value is an integer
  static FormFieldValidator<String> integer({
    String? errorText,
    int? radix,
  }) {
    return FormBuilderValidators.integer(errorText: errorText, radix: radix);
  }

  /// Validates that the value contains only alphabetic characters
  static FormFieldValidator<String> alphabetical({
    String? errorText,
  }) {
    return FormBuilderValidators.alphabetical(errorText: errorText);
  }

  /// Validates that the value contains only alphanumeric characters
  static FormFieldValidator<String> alphanumeric({
    String? errorText,
  }) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;
      if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
        return errorText ?? 'Only alphanumeric characters are allowed';
      }
      return null;
    };
  }

  /// Validates that the value contains only lowercase characters
  static FormFieldValidator<String> lowercase({
    String? errorText,
  }) {
    return FormBuilderValidators.lowercase(errorText: errorText);
  }

  /// Validates that the value contains only uppercase characters
  static FormFieldValidator<String> uppercase({
    String? errorText,
  }) {
    return FormBuilderValidators.uppercase(errorText: errorText);
  }

  /// Validates that the value is within a range
  static FormFieldValidator<num> range(
    num min,
    num max, {
    String? errorText,
  }) {
    return FormBuilderValidators.range(min, max, errorText: errorText);
  }

  /// Validates that the value is a valid color code
  static FormFieldValidator<String> colorCode({
    String? errorText,
  }) {
    return FormBuilderValidators.colorCode(errorText: errorText);
  }

  /// Validates that the value is a valid UUID
  static FormFieldValidator<String> uuid({
    String? errorText,
  }) {
    return FormBuilderValidators.uuid(errorText: errorText);
  }

  /// Validates that the value is a valid JSON
  static FormFieldValidator<String> json({
    String? errorText,
  }) {
    return FormBuilderValidators.json(errorText: errorText);
  }

  /// Validates that the value is a valid latitude
  static FormFieldValidator<String> latitude({
    String? errorText,
  }) {
    return FormBuilderValidators.latitude(errorText: errorText);
  }

  /// Validates that the value is a valid longitude
  static FormFieldValidator<String> longitude({
    String? errorText,
  }) {
    return FormBuilderValidators.longitude(errorText: errorText);
  }

  /// Validates that the value is a valid base64 string
  static FormFieldValidator<String> base64({
    String? errorText,
  }) {
    return FormBuilderValidators.base64(errorText: errorText);
  }

  /// Validates that the value is a valid path
  static FormFieldValidator<String> path({
    String? errorText,
  }) {
    return FormBuilderValidators.path(errorText: errorText);
  }

  /// Validates that a number is odd
  static FormFieldValidator<num> odd({
    String? errorText,
  }) {
    return (num? value) {
      if (value == null) return null;
      if (value % 2 == 0) {
        return errorText ?? 'Value must be odd';
      }
      return null;
    };
  }

  /// Validates that a number is even
  static FormFieldValidator<num> even({
    String? errorText,
  }) {
    return (num? value) {
      if (value == null) return null;
      if (value % 2 != 0) {
        return errorText ?? 'Value must be even';
      }
      return null;
    };
  }

  /// Validates that a number is positive
  static FormFieldValidator<num> positive({
    String? errorText,
  }) {
    return (num? value) {
      if (value == null) return null;
      if (value <= 0) {
        return errorText ?? 'Value must be positive';
      }
      return null;
    };
  }

  /// Validates that a number is negative
  static FormFieldValidator<num> negative({
    String? errorText,
  }) {
    return (num? value) {
      if (value == null) return null;
      if (value >= 0) {
        return errorText ?? 'Value must be negative';
      }
      return null;
    };
  }

  /// Validates that the value is a single line (no line breaks)
  static FormFieldValidator<String> singleLine({
    String? errorText,
  }) {
    return FormBuilderValidators.singleLine(errorText: errorText);
  }

  /// Validates using a custom validation function
  static FormFieldValidator<T> custom<T>(
    bool Function(T?) test, {
    String? errorText,
  }) {
    return (T? value) {
      if (!test(value)) {
        return errorText ?? 'Invalid value';
      }
      return null;
    };
  }

  /// Validates that the date is in the future
  static FormFieldValidator<DateTime> futureDate({
    String? errorText,
  }) {
    return (DateTime? value) {
      if (value == null) return null;
      if (value.isBefore(DateTime.now())) {
        return errorText ?? 'Date must be in the future';
      }
      return null;
    };
  }

  /// Validates that the date is in the past
  static FormFieldValidator<DateTime> pastDate({
    String? errorText,
  }) {
    return (DateTime? value) {
      if (value == null) return null;
      if (value.isAfter(DateTime.now())) {
        return errorText ?? 'Date must be in the past';
      }
      return null;
    };
  }

  /// Validates that the value is true (for checkboxes/agreements)
  static FormFieldValidator<bool> mustBeTrue({
    String? errorText,
  }) {
    return (bool? value) {
      if (value != true) {
        return errorText ?? 'This field must be checked';
      }
      return null;
    };
  }

  /// Validates that the value is false
  static FormFieldValidator<bool> mustBeFalse({
    String? errorText,
  }) {
    return (bool? value) {
      if (value != false) {
        return errorText ?? 'This field must be unchecked';
      }
      return null;
    };
  }
}
