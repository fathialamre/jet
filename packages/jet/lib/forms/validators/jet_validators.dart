import 'package:flutter/material.dart';

// Core validators
import '../validation/core/core.dart';

// String validators
import '../validation/string/string.dart';

// Numeric validators
import '../validation/numeric/numeric.dart';

// Collection validators
import '../validation/collection/collection.dart';

// Network validators
import '../validation/network/network.dart';

// DateTime validators
import '../validation/datetime/datetime.dart';

// Identity validators
import '../validation/identity/identity.dart';

// Finance validators
import '../validation/finance/finance.dart';

// File validators
import '../validation/file/file.dart';

// Bool validators
import '../validation/bool/bool.dart';

// Usecase validators
import '../validation/usecase/usecase.dart';

/// Jet framework validators for form fields.
///
/// This class provides a comprehensive set of validators for form validation
/// with support for localization, composition, and custom error messages.
///
/// Example usage:
/// ```dart
/// JetTextField(
///   name: 'email',
///   validator: JetValidators.compose([
///     JetValidators.required(),
///     JetValidators.email(),
///   ]),
/// )
/// ```
///
/// All validators support custom error messages and can be composed together
/// using `compose()`, combined with `or()`, or made conditional.
class JetValidators {
  JetValidators._(); // Private constructor to prevent instantiation

  // ==========================================================================
  // CORE VALIDATORS
  // ==========================================================================

  /// Composes multiple validators into one.
  ///
  /// All validators must pass for the composite validator to pass.
  /// Returns the first error encountered.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.compose([
  ///   JetValidators.required(),
  ///   JetValidators.email(),
  /// ])
  /// ```
  static FormFieldValidator<T> compose<T>(
    List<FormFieldValidator<T>?> validators,
  ) {
    final nonNullValidators = validators
        .whereType<FormFieldValidator<T>>()
        .toList();
    return ComposeValidator<T>(nonNullValidators).validate;
  }

  /// Validates using OR logic - at least one validator must pass.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.or([
  ///   JetValidators.email(),
  ///   JetValidators.phoneNumber(),
  /// ])
  /// ```
  static FormFieldValidator<T> or<T>(
    List<FormFieldValidator<T>> validators, {
    String? errorText,
  }) {
    return OrValidator<T>(validators, errorText: errorText).validate;
  }

  /// Applies validator only when condition is true.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.conditional(
  ///   JetValidators.required(),
  ///   condition: () => showAdvancedFields,
  /// )
  /// ```
  static FormFieldValidator<T> conditional<T>(
    FormFieldValidator<T> validator, {
    required bool Function() condition,
  }) {
    return ConditionalValidator<T>((_) => condition(), validator).validate;
  }

  /// Skips validation when condition is met.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.skipWhen(
  ///   (value) => value == null || value.isEmpty,
  ///   JetValidators.email(),
  /// )
  /// ```
  static FormFieldValidator<T> skipWhen<T>(
    bool Function(T?) condition,
    FormFieldValidator<T> validator,
  ) {
    return SkipWhenValidator<T>(condition, validator).validate;
  }

  /// Transforms value before applying validator.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.transform(
  ///   (value) => value?.trim(),
  ///   JetValidators.minLength(3),
  /// )
  /// ```
  static FormFieldValidator<T> transform<T>(
    T Function(T? value) transformer,
    FormFieldValidator<T> validator,
  ) {
    return TransformValidator<T>(transformer, validator).validate;
  }

  /// Runs all validators and collects all error messages.
  ///
  /// Unlike `compose()` which returns the first error, this returns all errors.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.aggregate([
  ///   JetValidators.minLength(8),
  ///   JetValidators.hasUppercaseChars(),
  ///   JetValidators.hasNumericChars(),
  /// ])
  /// ```
  static FormFieldValidator<T> aggregate<T>(
    List<FormFieldValidator<T>> validators, {
    String separator = ', ',
  }) {
    return AggregateValidator<T>(validators, separator: separator).validate;
  }

  /// Provides default value if value is null/empty, then validates.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.defaultValue(
  ///   '0',
  ///   JetValidators.numeric(),
  /// )
  /// ```
  static FormFieldValidator<T> defaultValue<T>(
    T defaultValue,
    FormFieldValidator<T> validator,
  ) {
    return DefaultValueValidator<T>(defaultValue, validator).validate;
  }

  /// Logs value during validation (for debugging).
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.log(
  ///   log: (v) => 'Password value: $v',
  /// )
  /// ```
  static FormFieldValidator<T> log<T>({
    String Function(T? value)? log,
  }) {
    return LogValidator<T>(log: log).validate;
  }

  /// Requires field to have a non-empty value.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.required()
  /// ```
  static FormFieldValidator<T> required<T>({
    String? errorText,
  }) {
    return RequiredValidator<T>(errorText: errorText).validate;
  }

  /// Requires value to equal a specific value.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.equal('expected')
  /// ```
  static FormFieldValidator<T> equal<T>(
    Object comparisonValue, {
    String? errorText,
  }) {
    return EqualValidator<T>(comparisonValue, errorText: errorText).validate;
  }

  /// Requires value to NOT equal a specific value.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.notEqual('forbidden')
  /// ```
  static FormFieldValidator<T> notEqual<T>(
    Object comparisonValue, {
    String? errorText,
  }) {
    return NotEqualValidator<T>(comparisonValue, errorText: errorText).validate;
  }

  // ==========================================================================
  // STRING VALIDATORS
  // ==========================================================================

  /// Requires value to contain only alphabetical characters.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.alphabetical()
  /// ```
  static FormFieldValidator<String> alphabetical({
    RegExp? regex,
    String? errorText,
  }) {
    return AlphabeticalValidator(regex: regex, errorText: errorText).validate;
  }

  /// Requires value to contain a specific substring.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.contains('required')
  /// ```
  static FormFieldValidator<String> contains(
    String substring, {
    bool caseSensitive = true,
    String? errorText,
  }) {
    return ContainsValidator(
      substring,
      caseSensitive: caseSensitive,
      errorText: errorText,
    ).validate;
  }

  /// Requires value to start with a specific prefix.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.startsWith('+1')
  /// ```
  static FormFieldValidator<String> startsWith(
    String prefix, {
    String? errorText,
  }) {
    return StartsWithValidator(prefix, errorText: errorText).validate;
  }

  /// Requires value to end with a specific suffix.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.endsWith('@company.com')
  /// ```
  static FormFieldValidator<String> endsWith(
    String suffix, {
    String? errorText,
  }) {
    return EndsWithValidator(suffix, errorText: errorText).validate;
  }

  /// Requires value to match a regex pattern.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.match(RegExp(r'^[A-Z]{3}\d{3}$'))
  /// ```
  static FormFieldValidator<String> match(
    RegExp pattern, {
    String? errorText,
  }) {
    return MatchValidator(pattern, errorText: errorText).validate;
  }

  /// Requires value to NOT match a regex pattern.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.matchNot(RegExp(r'[^a-zA-Z0-9]'))
  /// ```
  static FormFieldValidator<String> matchNot(
    RegExp pattern, {
    String? errorText,
  }) {
    return MatchNotValidator(pattern, errorText: errorText).validate;
  }

  /// Requires value to be all uppercase.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.uppercase()
  /// ```
  static FormFieldValidator<String> uppercase({
    String? errorText,
  }) {
    return UppercaseValidator(errorText: errorText).validate;
  }

  /// Requires value to be all lowercase.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.lowercase()
  /// ```
  static FormFieldValidator<String> lowercase({
    String? errorText,
  }) {
    return LowercaseValidator(errorText: errorText).validate;
  }

  /// Requires value to be a single line (no newlines).
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.singleLine()
  /// ```
  static FormFieldValidator<String> singleLine({
    String? errorText,
  }) {
    return SingleLineValidator(errorText: errorText).validate;
  }

  /// Requires minimum word count.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.minWordsCount(10)
  /// ```
  static FormFieldValidator<String> minWordsCount(
    int minWordsCount, {
    String? errorText,
  }) {
    return MinWordsCountValidator(minWordsCount, errorText: errorText).validate;
  }

  /// Requires maximum word count.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.maxWordsCount(100)
  /// ```
  static FormFieldValidator<String> maxWordsCount(
    int maxWordsCount, {
    String? errorText,
  }) {
    return MaxWordsCountValidator(maxWordsCount, errorText: errorText).validate;
  }

  /// Requires minimum number of uppercase characters.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.hasUppercaseChars(atLeast: 2)
  /// ```
  static FormFieldValidator<String> hasUppercaseChars({
    int atLeast = 1,
    RegExp? regex,
    String? errorText,
  }) {
    return HasUppercaseCharsValidator(
      atLeast: atLeast,
      regex: regex,
      errorText: errorText,
    ).validate;
  }

  /// Requires minimum number of lowercase characters.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.hasLowercaseChars(atLeast: 2)
  /// ```
  static FormFieldValidator<String> hasLowercaseChars({
    int atLeast = 1,
    RegExp? regex,
    String? errorText,
  }) {
    return HasLowercaseCharsValidator(
      atLeast: atLeast,
      regex: regex,
      errorText: errorText,
    ).validate;
  }

  /// Requires minimum number of numeric characters.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.hasNumericChars(atLeast: 2)
  /// ```
  static FormFieldValidator<String> hasNumericChars({
    int atLeast = 1,
    RegExp? regex,
    String? errorText,
  }) {
    return HasNumericCharsValidator(
      atLeast: atLeast,
      regex: regex,
      errorText: errorText,
    ).validate;
  }

  /// Requires minimum number of special characters.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.hasSpecialChars(atLeast: 1)
  /// ```
  static FormFieldValidator<String> hasSpecialChars({
    int atLeast = 1,
    RegExp? regex,
    String? errorText,
  }) {
    return HasSpecialCharsValidator(
      atLeast: atLeast,
      regex: regex,
      errorText: errorText,
    ).validate;
  }

  // ==========================================================================
  // NUMERIC VALIDATORS
  // ==========================================================================

  /// Requires value to be numeric.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.numeric()
  /// ```
  static FormFieldValidator<String> numeric({
    String? errorText,
  }) {
    return NumericValidator(errorText: errorText).validate;
  }

  /// Requires value to be an integer.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.integer()
  /// ```
  static FormFieldValidator<String> integer({
    String? errorText,
  }) {
    return IntegerValidator(errorText: errorText).validate;
  }

  /// Requires value to be a floating point number.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.float()
  /// ```
  static FormFieldValidator<String> float({
    String? errorText,
  }) {
    return FloatValidator(errorText: errorText).validate;
  }

  /// Requires minimum numeric value.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.min(18)
  /// ```
  static FormFieldValidator<T> min<T>(
    num min, {
    String? errorText,
  }) {
    return MinValidator<T>(min, errorText: errorText).validate;
  }

  /// Requires maximum numeric value.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.max(100)
  /// ```
  static FormFieldValidator<T> max<T>(
    num max, {
    String? errorText,
  }) {
    return MaxValidator<T>(max, errorText: errorText).validate;
  }

  /// Requires value to be between min and max (inclusive).
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.between(1, 5)
  /// ```
  static FormFieldValidator<T> between<T>(
    num min,
    num max, {
    String? errorText,
  }) {
    return BetweenValidator<T>(min, max, errorText: errorText).validate;
  }

  /// Alias for `between` with better name for ranges.
  static FormFieldValidator<T> range<T>(
    num min,
    num max, {
    String? errorText,
  }) {
    return between<T>(min, max, errorText: errorText);
  }

  /// Requires value to be a positive number (> 0).
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.positive()
  /// ```
  static FormFieldValidator<T> positive<T>({
    String? errorText,
  }) {
    return PositiveNumberValidator<T>(errorText: errorText).validate;
  }

  /// Requires value to be a negative number (< 0).
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.negative()
  /// ```
  static FormFieldValidator<T> negative<T>({
    String? errorText,
  }) {
    return NegativeNumberValidator<T>(errorText: errorText).validate;
  }

  /// Requires value to not be zero.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.notZero()
  /// ```
  static FormFieldValidator<T> notZero<T>({
    String? errorText,
  }) {
    return NotZeroNumberValidator<T>(errorText: errorText).validate;
  }

  /// Requires value to be an even number.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.even()
  /// ```
  static FormFieldValidator<T> even<T>({
    String? errorText,
  }) {
    return EvenNumberValidator<T>(errorText: errorText).validate;
  }

  /// Requires value to be an odd number.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.odd()
  /// ```
  static FormFieldValidator<T> odd<T>({
    String? errorText,
  }) {
    return OddNumberValidator<T>(errorText: errorText).validate;
  }

  /// Requires value to be a prime number.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.prime()
  /// ```
  static FormFieldValidator<T> prime<T>({
    String? errorText,
  }) {
    return PrimeNumberValidator<T>(errorText: errorText).validate;
  }

  /// Requires value to be a hexadecimal number.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.hexadecimal()
  /// ```
  static FormFieldValidator<String> hexadecimal({
    bool allowPrefix = true,
    String? errorText,
  }) {
    return HexadecimalValidator(
      allowPrefix: allowPrefix,
      errorText: errorText,
    ).validate;
  }

  // ==========================================================================
  // COLLECTION VALIDATORS
  // ==========================================================================

  /// Requires minimum length for collections/strings.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.minLength(8)
  /// ```
  static FormFieldValidator<T> minLength<T>(
    int minLength, {
    String? errorText,
  }) {
    return MinLengthValidator<T>(minLength, errorText: errorText).validate;
  }

  /// Requires maximum length for collections/strings.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.maxLength(20)
  /// ```
  static FormFieldValidator<T> maxLength<T>(
    int maxLength, {
    String? errorText,
  }) {
    return MaxLengthValidator<T>(maxLength, errorText: errorText).validate;
  }

  /// Requires exact length for collections/strings.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.equalLength(4) // PIN code
  /// ```
  static FormFieldValidator<T> equalLength<T>(
    int length, {
    String? errorText,
  }) {
    return EqualLengthValidator<T>(length, errorText: errorText).validate;
  }

  /// Requires collection to contain a specific element.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.containsElement('required')
  /// ```
  static FormFieldValidator<Iterable<T>> containsElement<T>(
    T element, {
    String? errorText,
  }) {
    return ContainsElementValidator<T>(element, errorText: errorText).validate;
  }

  /// Requires all elements in collection to be unique.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.unique()
  /// ```
  static FormFieldValidator<Iterable<T>> unique<T>({
    String? errorText,
  }) {
    return UniqueValidator<T>(errorText: errorText).validate;
  }

  /// Requires collection length to be within a range.
  ///
  /// Example:
  /// ```dart
  /// validator: JetValidators.lengthRange(minLength: 1, maxLength: 5)
  /// ```
  static FormFieldValidator<T> lengthRange<T>({
    int? minLength,
    int? maxLength,
    String? errorText,
  }) {
    return RangeValidator<T>(
      minLength: minLength,
      maxLength: maxLength,
      errorText: errorText,
    ).validate;
  }

  // Convenience aliases for list validators
  static FormFieldValidator<List<T>> notEmpty<T>({String? errorText}) {
    return minLength<List<T>>(1, errorText: errorText);
  }

  static FormFieldValidator<List<T>> minListLength<T>(
    int minLength, {
    String? errorText,
  }) {
    return JetValidators.minLength<List<T>>(minLength, errorText: errorText);
  }

  static FormFieldValidator<List<T>> maxListLength<T>(
    int maxLength, {
    String? errorText,
  }) {
    return JetValidators.maxLength<List<T>>(maxLength, errorText: errorText);
  }

  // ==========================================================================
  // NETWORK VALIDATORS
  // ==========================================================================

  /// Requires valid email address.
  static FormFieldValidator<String> email({RegExp? regex, String? errorText}) {
    return EmailValidator(regex: regex, errorText: errorText).validate;
  }

  /// Requires valid URL.
  static FormFieldValidator<String> url({
    bool requireProtocol = true,
    List<String> protocols = const ['http', 'https'],
    bool allowLocalhost = false,
    String? errorText,
  }) {
    return UrlValidator(
      requireProtocol: requireProtocol,
      protocols: protocols,
      allowLocalhost: allowLocalhost,
      errorText: errorText,
    ).validate;
  }

  /// Requires valid IP address.
  static FormFieldValidator<String> ip({int? version, String? errorText}) {
    return IpValidator(version: version, errorText: errorText).validate;
  }

  /// Requires valid MAC address.
  static FormFieldValidator<String> macAddress({String? errorText}) {
    return MacAddressValidator(errorText: errorText).validate;
  }

  /// Requires valid phone number.
  static FormFieldValidator<String> phoneNumber({
    RegExp? regex,
    String? errorText,
  }) {
    return PhoneNumberValidator(regex: regex, errorText: errorText).validate;
  }

  /// Requires valid port number.
  static FormFieldValidator<T> portNumber<T>({
    int min = 1,
    int max = 65535,
    String? errorText,
  }) {
    return PortNumberValidator<T>(
      min: min,
      max: max,
      errorText: errorText,
    ).validate;
  }

  /// Requires valid latitude.
  static FormFieldValidator<T> latitude<T>({String? errorText}) {
    return LatitudeValidator<T>(errorText: errorText).validate;
  }

  /// Requires valid longitude.
  static FormFieldValidator<T> longitude<T>({String? errorText}) {
    return LongitudeValidator<T>(errorText: errorText).validate;
  }

  // ==========================================================================
  // DATETIME VALIDATORS
  // ==========================================================================

  /// Requires valid date string.
  static FormFieldValidator<String> date({RegExp? regex, String? errorText}) {
    return DateValidator(regex: regex, errorText: errorText).validate;
  }

  static FormFieldValidator<String> dateString({String? errorText}) {
    return date(errorText: errorText);
  }

  /// Requires valid datetime string.
  static FormFieldValidator<String> dateTime({String? errorText}) {
    return DateTimeValidator(errorText: errorText).validate;
  }

  /// Requires valid time string.
  static FormFieldValidator<String> time({String? errorText}) {
    return TimeValidator(errorText: errorText).validate;
  }

  /// Requires date to be within a range.
  static FormFieldValidator<T> dateRange<T>({
    DateTime? minDate,
    DateTime? maxDate,
    String? errorText,
  }) {
    return DateRangeValidator<T>(
      minDate: minDate,
      maxDate: maxDate,
      errorText: errorText,
    ).validate;
  }

  /// Requires date to be in the future.
  static FormFieldValidator<T> futureDate<T>({String? errorText}) {
    return DateFutureValidator<T>(errorText: errorText).validate;
  }

  /// Requires date to be in the past.
  static FormFieldValidator<T> pastDate<T>({String? errorText}) {
    return DatePastValidator<T>(errorText: errorText).validate;
  }

  /// Requires valid timezone.
  static FormFieldValidator<String> timezone({
    List<String>? validTimezones,
    String? errorText,
  }) {
    return TimezoneValidator(
      validTimezones: validTimezones,
      errorText: errorText,
    ).validate;
  }

  // ==========================================================================
  // IDENTITY VALIDATORS
  // ==========================================================================

  /// Requires valid first name.
  static FormFieldValidator<String> firstName({
    int minLength = 2,
    int maxLength = 50,
    RegExp? regex,
    String? errorText,
  }) {
    return FirstNameValidator(
      minLength: minLength,
      maxLength: maxLength,
      regex: regex,
      errorText: errorText,
    ).validate;
  }

  /// Requires valid last name.
  static FormFieldValidator<String> lastName({
    int minLength = 2,
    int maxLength = 50,
    RegExp? regex,
    String? errorText,
  }) {
    return LastNameValidator(
      minLength: minLength,
      maxLength: maxLength,
      regex: regex,
      errorText: errorText,
    ).validate;
  }

  /// Requires valid username.
  static FormFieldValidator<String> username({
    int minLength = 3,
    int maxLength = 20,
    bool allowSpecialChars = false,
    RegExp? regex,
    String? errorText,
  }) {
    return UsernameValidator(
      minLength: minLength,
      maxLength: maxLength,
      allowSpecialChars: allowSpecialChars,
      regex: regex,
      errorText: errorText,
    ).validate;
  }

  /// Requires strong password.
  static FormFieldValidator<String> password({
    int minLength = 8,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireNumbers = true,
    bool requireSpecialChars = true,
    String? errorText,
  }) {
    return PasswordValidator(
      minLength: minLength,
      requireUppercase: requireUppercase,
      requireLowercase: requireLowercase,
      requireNumbers: requireNumbers,
      requireSpecialChars: requireSpecialChars,
      errorText: errorText,
    ).validate;
  }

  /// Convenience validators for password strength
  static FormFieldValidator<String> strongPassword({int minLength = 8}) {
    return password(minLength: minLength);
  }

  static FormFieldValidator<String> mediumPassword({int minLength = 6}) {
    return password(minLength: minLength, requireSpecialChars: false);
  }

  /// Requires valid SSN.
  static FormFieldValidator<String> ssn({String? errorText}) {
    return SsnValidator(errorText: errorText).validate;
  }

  /// Requires valid passport number.
  static FormFieldValidator<String> passportNumber({
    RegExp? regex,
    String? errorText,
  }) {
    return PassportNumberValidator(regex: regex, errorText: errorText).validate;
  }

  /// Requires valid city name.
  static FormFieldValidator<String> city({
    int minLength = 2,
    int maxLength = 50,
    String? errorText,
  }) {
    return CityValidator(
      minLength: minLength,
      maxLength: maxLength,
      errorText: errorText,
    ).validate;
  }

  /// Requires valid country name.
  static FormFieldValidator<String> country({
    int minLength = 2,
    int maxLength = 60,
    String? errorText,
  }) {
    return CountryValidator(
      minLength: minLength,
      maxLength: maxLength,
      errorText: errorText,
    ).validate;
  }

  /// Requires valid state name.
  static FormFieldValidator<String> state({
    int minLength = 2,
    int maxLength = 50,
    String? errorText,
  }) {
    return StateValidator(
      minLength: minLength,
      maxLength: maxLength,
      errorText: errorText,
    ).validate;
  }

  /// Requires valid street name.
  static FormFieldValidator<String> street({
    int minLength = 3,
    int maxLength = 100,
    String? errorText,
  }) {
    return StreetValidator(
      minLength: minLength,
      maxLength: maxLength,
      errorText: errorText,
    ).validate;
  }

  /// Requires valid ZIP/postal code.
  static FormFieldValidator<String> zipCode({
    String? countryCode,
    RegExp? regex,
    String? errorText,
  }) {
    return ZipCodeValidator(
      countryCode: countryCode,
      regex: regex,
      errorText: errorText,
    ).validate;
  }

  // ==========================================================================
  // FINANCE VALIDATORS
  // ==========================================================================

  /// Requires valid credit card number.
  static FormFieldValidator<String> creditCard({String? errorText}) {
    return CreditCardValidator(errorText: errorText).validate;
  }

  /// Requires valid credit card CVC.
  static FormFieldValidator<String> creditCardCVC({
    int? length,
    String? errorText,
  }) {
    return CreditCardCvcValidator(
      length: length,
      errorText: errorText,
    ).validate;
  }

  /// Requires valid credit card expiration date.
  static FormFieldValidator<String> creditCardExpirationDate({
    String? errorText,
  }) {
    return CreditCardExpirationDateValidator(errorText: errorText).validate;
  }

  /// Requires valid IBAN.
  static FormFieldValidator<String> iban({String? errorText}) {
    return IbanValidator(errorText: errorText).validate;
  }

  /// Requires valid BIC.
  static FormFieldValidator<String> bic({String? errorText}) {
    return BicValidator(errorText: errorText).validate;
  }

  // ==========================================================================
  // FILE VALIDATORS
  // ==========================================================================

  /// Requires specific file extension.
  static FormFieldValidator<String> fileExtension(
    List<String> allowedExtensions, {
    bool caseSensitive = false,
    String? errorText,
  }) {
    return FileExtensionValidator(
      allowedExtensions,
      caseSensitive: caseSensitive,
      errorText: errorText,
    ).validate;
  }

  /// Requires file size within limits.
  static FormFieldValidator<T> fileSize<T>({
    int? maxSizeInBytes,
    int? minSizeInBytes,
    String? errorText,
  }) {
    return FileSizeValidator<T>(
      maxSizeInBytes: maxSizeInBytes,
      minSizeInBytes: minSizeInBytes,
      errorText: errorText,
    ).validate;
  }

  /// Requires valid file name.
  static FormFieldValidator<String> fileName({String? errorText}) {
    return FileNameValidator(errorText: errorText).validate;
  }

  /// Requires specific MIME type.
  static FormFieldValidator<String> mimeType(
    List<String> allowedMimeTypes, {
    String? errorText,
  }) {
    return MimeTypeValidator(allowedMimeTypes, errorText: errorText).validate;
  }

  /// Requires valid path.
  static FormFieldValidator<String> path({
    bool absoluteOnly = false,
    bool relativeOnly = false,
    String? errorText,
  }) {
    return PathValidator(
      absoluteOnly: absoluteOnly,
      relativeOnly: relativeOnly,
      errorText: errorText,
    ).validate;
  }

  // ==========================================================================
  // BOOL VALIDATORS
  // ==========================================================================

  /// Requires value to be true.
  static FormFieldValidator<bool> mustBeTrue({String? errorText}) {
    return IsTrueValidator(errorText: errorText).validate;
  }

  /// Requires value to be false.
  static FormFieldValidator<bool> mustBeFalse({String? errorText}) {
    return IsFalseValidator(errorText: errorText).validate;
  }

  // ==========================================================================
  // USECASE VALIDATORS
  // ==========================================================================

  /// Requires valid base64 string.
  static FormFieldValidator<String> base64({String? errorText}) {
    return Base64Validator(errorText: errorText).validate;
  }

  /// Requires valid UUID.
  static FormFieldValidator<String> uuid({int? version, String? errorText}) {
    return UuidValidator(version: version, errorText: errorText).validate;
  }

  /// Requires valid JSON.
  static FormFieldValidator<String> json({String? errorText}) {
    return JsonValidator(errorText: errorText).validate;
  }

  /// Requires valid ISBN.
  static FormFieldValidator<String> isbn({String? errorText}) {
    return IsbnValidator(errorText: errorText).validate;
  }

  /// Requires valid color code.
  static FormFieldValidator<String> colorCode({
    String? format,
    String? errorText,
  }) {
    return ColorCodeValidator(format: format, errorText: errorText).validate;
  }

  /// Requires valid DUNS number.
  static FormFieldValidator<String> duns({String? errorText}) {
    return DunsValidator(errorText: errorText).validate;
  }

  /// Requires valid language code.
  static FormFieldValidator<String> languageCode({
    String? format,
    String? errorText,
  }) {
    return LanguageCodeValidator(format: format, errorText: errorText).validate;
  }

  /// Requires valid license plate.
  static FormFieldValidator<String> licensePlate({
    String? countryCode,
    RegExp? regex,
    String? errorText,
  }) {
    return LicensePlateValidator(
      countryCode: countryCode,
      regex: regex,
      errorText: errorText,
    ).validate;
  }

  /// Requires valid VIN.
  static FormFieldValidator<String> vin({String? errorText}) {
    return VinValidator(errorText: errorText).validate;
  }

  // ==========================================================================
  // CONVENIENCE METHODS
  // ==========================================================================

  /// Alias for equal - validates that two fields match.
  static FormFieldValidator<String> matchValue(
    String matchValue, {
    String? errorText,
  }) {
    return equal<String>(matchValue, errorText: errorText);
  }

  /// Validates age is at least minimum.
  static FormFieldValidator<num> minAge(int minAge, {String? errorText}) {
    return min<num>(minAge, errorText: errorText);
  }

  /// Validates age is at most maximum.
  static FormFieldValidator<num> maxAge(int maxAge, {String? errorText}) {
    return max<num>(maxAge, errorText: errorText);
  }

  /// Custom validator with test function.
  static FormFieldValidator<T> custom<T>(
    bool Function(T?) test, {
    String? errorText,
  }) {
    return (T? value) {
      if (!test(value)) return errorText;
      return null;
    };
  }

  /// Alias for minLength with better name.
  static FormFieldValidator<String> hasMinLength(
    int minLength, {
    String? errorText,
  }) {
    return JetValidators.minLength<String>(minLength, errorText: errorText);
  }

  /// Convenience for alphanumeric validation.
  static FormFieldValidator<String> alphanumeric({String? errorText}) {
    return match(
      RegExp(r'^[a-zA-Z0-9]+$'),
      errorText: errorText ?? 'Only alphanumeric characters are allowed',
    );
  }

  /// Word count range validator.
  static FormFieldValidator<String> wordsCount(
    int minWords,
    int maxWords, {
    String? errorText,
  }) {
    return compose([
      minWordsCount(minWords),
      maxWordsCount(maxWords),
    ]);
  }
}
