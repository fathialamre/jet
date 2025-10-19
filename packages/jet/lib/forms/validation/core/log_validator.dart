import 'package:flutter/foundation.dart';
import '../base_validator.dart';

/// Validator that logs the value during validation (for debugging).
///
/// This validator always passes but logs the value being validated.
/// Useful for debugging validation chains.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'debug_field',
///   validator: ComposeValidator([
///     LogValidator<String>(log: (v) => 'Value is: $v').validate,
///     RequiredValidator().validate,
///   ]).validate,
/// )
/// ```
class LogValidator<T> extends BaseValidator<T> {
  /// Function to generate log message from value.
  final String Function(T? value)? logFunction;

  /// Creates a log validator.
  ///
  /// [log]: Function to generate log message (optional)
  const LogValidator({
    String Function(T? value)? log,
    super.errorText,
    super.checkNullOrEmpty = false,
  }) : logFunction = log;

  @override
  String? validate(T? valueCandidate) {
    if (kDebugMode) {
      final message = logFunction != null
          ? logFunction!(valueCandidate)
          : 'LogValidator: $valueCandidate';
      debugPrint(message);
    }
    return null; // Always valid
  }

  @override
  String? validateValue(T valueCandidate) {
    // Not used in log validator
    return null;
  }
}

