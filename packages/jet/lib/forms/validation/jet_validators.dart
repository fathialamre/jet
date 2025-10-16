import 'package:flutter/material.dart';
import 'validation.dart';
import '../core/jet_form_field.dart';

/// Facade for accessing all Jet form validators with a clean API.
///
/// This class provides static methods for creating validators in a fluent way.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'email',
///   validator: JetValidators.compose([
///     JetValidators.required(),
///     JetValidators.email(),
///   ]),
/// )
/// ```
class JetValidators {
  JetValidators._();

  // ============================================================================
  // Core Validators
  // ============================================================================

  /// Creates a validator that composes multiple validators.
  ///
  /// Returns the first error found, or null if all validators pass.
  static FormFieldValidator<T> compose<T>(
    List<FormFieldValidator<T>?> validators,
  ) {
    final nonNullValidators = validators
        .whereType<FormFieldValidator<T>>()
        .toList();
    return ComposeValidator<T>(nonNullValidators).validate;
  }

  /// Creates a validator that requires at least one validator to pass.
  static FormFieldValidator<T> or<T>(
    List<FormFieldValidator<T>> validators, {
    String? errorText,
  }) {
    return OrValidator<T>(validators, errorText: errorText).validate;
  }

  /// Creates a conditional validator.
  static FormFieldValidator<T> conditional<T>(
    bool Function(T? value) condition,
    FormFieldValidator<T> validator,
  ) {
    return ConditionalValidator<T>(condition, validator).validate;
  }

  /// Creates a required field validator.
  static FormFieldValidator<T> required<T>({String? errorText}) {
    return RequiredValidator<T>(errorText: errorText).validate;
  }

  /// Creates an equal value validator.
  static FormFieldValidator<T> equal<T>(
    Object value, {
    String? errorText,
  }) {
    return EqualValidator<T>(value, errorText: errorText).validate;
  }

  /// Creates a not equal value validator.
  static FormFieldValidator<T> notEqual<T>(
    Object value, {
    String? errorText,
  }) {
    return NotEqualValidator<T>(value, errorText: errorText).validate;
  }

  /// Creates a validator that matches another field's value in the form.
  ///
  /// Useful for password confirmation, email confirmation, etc.
  ///
  /// Example:
  /// ```dart
  /// final formKey = GlobalKey<JetFormState>();
  ///
  /// JetPasswordField(
  ///   name: 'password_confirmation',
  ///   validator: JetValidators.matchField<String>(
  ///     formKey,
  ///     'password',
  ///     errorText: 'Passwords do not match',
  ///   ),
  /// )
  /// ```
  static FormFieldValidator<T> matchField<T>(
    GlobalKey<JetFormState> formKey,
    String fieldName, {
    String? errorText,
  }) {
    return MatchFieldValidator<T>(
      formKey,
      fieldName,
      errorText: errorText,
    ).validate;
  }

  // ============================================================================
  // String Validators
  // ============================================================================

  /// Creates a minimum length validator for strings.
  static FormFieldValidator<String> minLength(
    int minLength, {
    String? errorText,
    bool checkNullOrEmpty = false,
  }) {
    return MinLengthValidator(
      minLength,
      errorText: errorText,
      checkNullOrEmpty: checkNullOrEmpty,
    ).validate;
  }

  /// Creates a maximum length validator for strings.
  static FormFieldValidator<String> maxLength(
    int maxLength, {
    String? errorText,
    bool checkNullOrEmpty = false,
  }) {
    return MaxLengthValidator(
      maxLength,
      errorText: errorText,
      checkNullOrEmpty: checkNullOrEmpty,
    ).validate;
  }

  /// Creates an equal length validator for strings.
  static FormFieldValidator<String> equalLength(
    int length, {
    String? errorText,
    bool checkNullOrEmpty = false,
  }) {
    return EqualLengthValidator(
      length,
      errorText: errorText,
      checkNullOrEmpty: checkNullOrEmpty,
    ).validate;
  }

  /// Creates a regex match validator.
  static FormFieldValidator<String> match(
    RegExp pattern, {
    String? errorText,
    bool checkNullOrEmpty = false,
  }) {
    return MatchValidator(
      pattern,
      errorText: errorText,
      checkNullOrEmpty: checkNullOrEmpty,
    ).validate;
  }

  /// Creates a regex non-match validator.
  static FormFieldValidator<String> matchNot(
    RegExp pattern, {
    String? errorText,
    bool checkNullOrEmpty = false,
  }) {
    return MatchNotValidator(
      pattern,
      errorText: errorText,
      checkNullOrEmpty: checkNullOrEmpty,
    ).validate;
  }

  // ============================================================================
  // Network Validators
  // ============================================================================

  /// Creates an email validator.
  static FormFieldValidator<String> email({
    RegExp? regex,
    String? errorText,
    bool checkNullOrEmpty = false,
  }) {
    return EmailValidator(
      regex: regex,
      errorText: errorText,
      checkNullOrEmpty: checkNullOrEmpty,
    ).validate;
  }

  /// Creates a URL validator.
  static FormFieldValidator<String> url({
    List<String> protocols = const ['http', 'https'],
    bool requireProtocol = true,
    bool allowLocalhost = false,
    String? errorText,
    bool checkNullOrEmpty = false,
  }) {
    return UrlValidator(
      protocols: protocols,
      requireProtocol: requireProtocol,
      allowLocalhost: allowLocalhost,
      errorText: errorText,
      checkNullOrEmpty: checkNullOrEmpty,
    ).validate;
  }

  /// Creates a phone number validator.
  static FormFieldValidator<String> phoneNumber({
    String? errorText,
    bool checkNullOrEmpty = false,
  }) {
    return PhoneNumberValidator(
      errorText: errorText,
      checkNullOrEmpty: checkNullOrEmpty,
    ).validate;
  }

  /// Creates an IP address validator.
  static FormFieldValidator<String> ip({
    int? version,
    String? errorText,
    bool checkNullOrEmpty = false,
  }) {
    return IpValidator(
      version: version,
      errorText: errorText,
      checkNullOrEmpty: checkNullOrEmpty,
    ).validate;
  }

  // ============================================================================
  // Numeric Validators
  // ============================================================================

  /// Creates a numeric validator.
  static FormFieldValidator<String> numeric({
    String? errorText,
    bool checkNullOrEmpty = false,
  }) {
    return NumericValidator(
      errorText: errorText,
      checkNullOrEmpty: checkNullOrEmpty,
    ).validate;
  }

  /// Creates an integer validator.
  static FormFieldValidator<String> integer({
    String? errorText,
    bool checkNullOrEmpty = false,
  }) {
    return IntegerValidator(
      errorText: errorText,
      checkNullOrEmpty: checkNullOrEmpty,
    ).validate;
  }

  /// Creates a minimum value validator.
  static FormFieldValidator<num> min(
    num min, {
    String? errorText,
    bool checkNullOrEmpty = false,
  }) {
    return MinValidator(
      min,
      errorText: errorText,
      checkNullOrEmpty: checkNullOrEmpty,
    ).validate;
  }

  /// Creates a maximum value validator.
  static FormFieldValidator<num> max(
    num max, {
    String? errorText,
    bool checkNullOrEmpty = false,
  }) {
    return MaxValidator(
      max,
      errorText: errorText,
      checkNullOrEmpty: checkNullOrEmpty,
    ).validate;
  }

  /// Creates a range validator for numeric values.
  static FormFieldValidator<num> between(
    num min,
    num max, {
    String? errorText,
    bool checkNullOrEmpty = false,
  }) {
    return BetweenValidator(
      min,
      max,
      errorText: errorText,
      checkNullOrEmpty: checkNullOrEmpty,
    ).validate;
  }

  // ============================================================================
  // DateTime Validators
  // ============================================================================

  /// Creates a future date validator.
  static FormFieldValidator<DateTime> dateFuture({
    String? errorText,
    bool checkNullOrEmpty = false,
  }) {
    return DateFutureValidator(
      errorText: errorText,
      checkNullOrEmpty: checkNullOrEmpty,
    ).validate;
  }

  /// Creates a past date validator.
  static FormFieldValidator<DateTime> datePast({
    String? errorText,
    bool checkNullOrEmpty = false,
  }) {
    return DatePastValidator(
      errorText: errorText,
      checkNullOrEmpty: checkNullOrEmpty,
    ).validate;
  }

  /// Creates a date range validator.
  static FormFieldValidator<DateTime> dateRange({
    DateTime? minDate,
    DateTime? maxDate,
    String? errorText,
    bool checkNullOrEmpty = false,
  }) {
    return DateRangeValidator(
      minDate: minDate,
      maxDate: maxDate,
      errorText: errorText,
      checkNullOrEmpty: checkNullOrEmpty,
    ).validate;
  }

  // ============================================================================
  // Bool Validators
  // ============================================================================

  /// Creates a true value validator.
  static FormFieldValidator<bool> isTrue({
    String? errorText,
  }) {
    return IsTrueValidator(errorText: errorText).validate;
  }

  /// Creates a false value validator.
  static FormFieldValidator<bool> isFalse({
    String? errorText,
  }) {
    return IsFalseValidator(errorText: errorText).validate;
  }

  // ============================================================================
  // Identity Validators
  // ============================================================================

  /// Creates a password strength validator.
  static FormFieldValidator<String> password({
    int minLength = 8,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireNumbers = true,
    bool requireSpecialChars = true,
    String? errorText,
    bool checkNullOrEmpty = false,
  }) {
    return PasswordValidator(
      minLength: minLength,
      requireUppercase: requireUppercase,
      requireLowercase: requireLowercase,
      requireNumbers: requireNumbers,
      requireSpecialChars: requireSpecialChars,
      errorText: errorText,
      checkNullOrEmpty: checkNullOrEmpty,
    ).validate;
  }

  // ============================================================================
  // Finance Validators
  // ============================================================================

  /// Creates a credit card number validator.
  static FormFieldValidator<String> creditCard({
    String? errorText,
    bool checkNullOrEmpty = false,
  }) {
    return CreditCardValidator(
      errorText: errorText,
      checkNullOrEmpty: checkNullOrEmpty,
    ).validate;
  }

  /// Creates a credit card CVC validator.
  static FormFieldValidator<String> creditCardCvc({
    String? errorText,
    bool checkNullOrEmpty = false,
  }) {
    return CreditCardCvcValidator(
      errorText: errorText,
      checkNullOrEmpty: checkNullOrEmpty,
    ).validate;
  }
}
