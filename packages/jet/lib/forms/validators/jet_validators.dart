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
        return errorText;
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

  /// Validates that the string contains special characters
  static FormFieldValidator<String> hasSpecialChars({
    String? errorText,
    int atLeast = 1,
  }) {
    return FormBuilderValidators.hasSpecialChars(
      errorText: errorText,
      atLeast: atLeast,
    );
  }

  /// Validates that the string contains numeric characters
  static FormFieldValidator<String> hasNumericChars({
    String? errorText,
    int atLeast = 1,
  }) {
    return FormBuilderValidators.hasNumericChars(
      errorText: errorText,
      atLeast: atLeast,
    );
  }

  /// Validates that the string contains uppercase characters
  static FormFieldValidator<String> hasUppercaseChars({
    String? errorText,
    int atLeast = 1,
  }) {
    return FormBuilderValidators.hasUppercaseChars(
      errorText: errorText,
      atLeast: atLeast,
    );
  }

  /// Validates that the string contains lowercase characters
  static FormFieldValidator<String> hasLowercaseChars({
    String? errorText,
    int atLeast = 1,
  }) {
    return FormBuilderValidators.hasLowercaseChars(
      errorText: errorText,
      atLeast: atLeast,
    );
  }

  /// Validates that the value is a valid DateTime
  static FormFieldValidator<DateTime> dateTime({
    String? errorText,
  }) {
    return FormBuilderValidators.dateTime(errorText: errorText);
  }

  /// Validates that the value is a valid time
  static FormFieldValidator<String> time({
    String? errorText,
  }) {
    return FormBuilderValidators.time(errorText: errorText);
  }

  /// Validates that the value is a valid credit card expiration date
  static FormFieldValidator<String> creditCardExpirationDate({
    String? errorText,
  }) {
    return FormBuilderValidators.creditCardExpirationDate(errorText: errorText);
  }

  /// Validates that the value is a valid credit card CVC
  static FormFieldValidator<String> creditCardCVC({
    String? errorText,
  }) {
    return FormBuilderValidators.creditCardCVC(errorText: errorText);
  }

  /// Validates that the value is a valid IBAN
  static FormFieldValidator<String> iban({
    String? errorText,
  }) {
    return FormBuilderValidators.iban(errorText: errorText);
  }

  /// Validates that the value is a valid BIC
  static FormFieldValidator<String> bic({
    String? errorText,
  }) {
    return FormBuilderValidators.bic(errorText: errorText);
  }

  /// Validates that the value contains a specific substring
  static FormFieldValidator<String> contains(
    String substring, {
    String? errorText,
    bool caseSensitive = true,
  }) {
    return FormBuilderValidators.contains(
      substring,
      errorText: errorText,
      caseSensitive: caseSensitive,
    );
  }

  /// Validates that the value starts with a specific substring
  static FormFieldValidator<String> startsWith(
    String prefix, {
    String? errorText,
    bool caseSensitive = true,
  }) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;
      final valueToCheck = caseSensitive ? value : value.toLowerCase();
      final prefixToCheck = caseSensitive ? prefix : prefix.toLowerCase();
      if (!valueToCheck.startsWith(prefixToCheck)) {
        return errorText;
      }
      return null;
    };
  }

  /// Validates that the value ends with a specific substring
  static FormFieldValidator<String> endsWith(
    String suffix, {
    String? errorText,
    bool caseSensitive = true,
  }) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;
      final valueToCheck = caseSensitive ? value : value.toLowerCase();
      final suffixToCheck = caseSensitive ? suffix : suffix.toLowerCase();
      if (!valueToCheck.endsWith(suffixToCheck)) {
        return errorText;
      }
      return null;
    };
  }

  /// Validates minimum word count
  static FormFieldValidator<String> minWordsCount(
    int minWords, {
    String? errorText,
  }) {
    return FormBuilderValidators.minWordsCount(
      minWords,
      errorText: errorText,
    );
  }

  /// Validates maximum word count
  static FormFieldValidator<String> maxWordsCount(
    int maxWords, {
    String? errorText,
  }) {
    return FormBuilderValidators.maxWordsCount(
      maxWords,
      errorText: errorText,
    );
  }

  /// Validates word count range
  static FormFieldValidator<String> wordsCount(
    int minWords,
    int maxWords, {
    String? errorText,
  }) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;
      final words = value.trim().split(RegExp(r'\s+'));
      if (words.length < minWords || words.length > maxWords) {
        return errorText;
      }
      return null;
    };
  }

  /// Validates using OR logic (at least one validator must pass)
  static FormFieldValidator<T> or<T>(
    List<FormFieldValidator<T>> validators, {
    String? errorText,
  }) {
    return (T? value) {
      // If any validator passes, return null (valid)
      for (final validator in validators) {
        final result = validator(value);
        if (result == null) {
          return null;
        }
      }
      // All validators failed
      return errorText;
    };
  }

  /// Validates using AND logic with custom condition
  static FormFieldValidator<T> conditional<T>(
    FormFieldValidator<T> validator, {
    required bool Function() condition,
  }) {
    return (T? value) {
      if (!condition()) return null;
      return validator(value);
    };
  }

  /// Validates that password has minimum length (alias for common use case)
  static FormFieldValidator<String> hasMinLength(
    int minLength, {
    String? errorText,
  }) {
    return FormBuilderValidators.minLength(
      minLength,
      errorText: errorText,
    );
  }

  /// Validates strong password (min 8 chars, uppercase, lowercase, number, special char)
  static FormFieldValidator<String> strongPassword({
    String? errorText,
    int minLength = 8,
  }) {
    return compose([
      hasMinLength(minLength),
      hasUppercaseChars(),
      hasLowercaseChars(),
      hasNumericChars(),
      hasSpecialChars(),
    ]);
  }

  /// Validates medium password (min 6 chars, uppercase, lowercase, number)
  static FormFieldValidator<String> mediumPassword({
    String? errorText,
    int minLength = 6,
  }) {
    return compose([
      hasMinLength(minLength),
      hasUppercaseChars(),
      hasLowercaseChars(),
      hasNumericChars(),
    ]);
  }

  /// Validates that two fields match (e.g., password confirmation)
  /// Alias for [equal] with better name for field matching scenarios
  static FormFieldValidator<String> matchValue(
    String matchValue, {
    String? errorText,
  }) {
    return equal(matchValue, errorText: errorText);
  }

  /// Validates username format (alphanumeric, underscore, hyphen, 3-20 chars)
  static FormFieldValidator<String> username({
    String? errorText,
    int minLength = 3,
    int maxLength = 20,
  }) {
    return compose([
      required(errorText: errorText),
      FormBuilderValidators.match(
        RegExp(r'^[a-zA-Z0-9_-]+$'),
        errorText: errorText,
      ),
      FormBuilderValidators.minLength(minLength),
      FormBuilderValidators.maxLength(maxLength),
    ]);
  }

  /// Validates age is at least the specified minimum
  static FormFieldValidator<num> minAge(
    int minAge, {
    String? errorText,
  }) {
    return (num? value) {
      if (value == null) return null;
      if (value < minAge) {
        return errorText;
      }
      return null;
    };
  }

  /// Validates age is no more than the specified maximum
  static FormFieldValidator<num> maxAge(
    int maxAge, {
    String? errorText,
  }) {
    return (num? value) {
      if (value == null) return null;
      if (value > maxAge) {
        return errorText;
      }
      return null;
    };
  }

  /// Validates that the list/array is not empty
  static FormFieldValidator<List<T>> notEmpty<T>({
    String? errorText,
  }) {
    return (List<T>? value) {
      if (value == null || value.isEmpty) {
        return errorText ?? 'Please select at least one option';
      }
      return null;
    };
  }

  /// Validates minimum list length
  static FormFieldValidator<List<T>> minListLength<T>(
    int minLength, {
    String? errorText,
  }) {
    return (List<T>? value) {
      if (value == null || value.length < minLength) {
        return errorText ??
            'Please select at least $minLength option${minLength > 1 ? 's' : ''}';
      }
      return null;
    };
  }

  /// Validates maximum list length
  static FormFieldValidator<List<T>> maxListLength<T>(
    int maxLength, {
    String? errorText,
  }) {
    return (List<T>? value) {
      if (value != null && value.length > maxLength) {
        return errorText ??
            'Please select no more than $maxLength option${maxLength > 1 ? 's' : ''}';
      }
      return null;
    };
  }

  /// Validates that the file size is within the specified limit (in bytes)
  static FormFieldValidator<int> fileSize(
    int maxSizeInBytes, {
    String? errorText,
  }) {
    return (int? value) {
      if (value == null) return null;
      if (value > maxSizeInBytes) {
        final maxSizeInMB = (maxSizeInBytes / (1024 * 1024)).toStringAsFixed(2);
        return errorText ?? 'File size must not exceed $maxSizeInMB MB';
      }
      return null;
    };
  }

  /// Validates file extension
  static FormFieldValidator<String> fileExtension(
    List<String> allowedExtensions, {
    String? errorText,
  }) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;
      final extension = value.split('.').last.toLowerCase();
      if (!allowedExtensions.map((e) => e.toLowerCase()).contains(extension)) {
        return errorText ??
            'Allowed file types: ${allowedExtensions.join(', ')}';
      }
      return null;
    };
  }
}
