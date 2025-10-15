import 'package:flutter/widgets.dart';
import 'base_validator.dart';

/// A validator that supports internationalization through Flutter's localization system.
///
/// This validator can provide localized error messages based on the current locale.
abstract class TranslatedValidator<T> extends BaseValidator<T> {
  /// Creates a translated validator.
  const TranslatedValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  /// Gets the localized error message for this validator.
  ///
  /// Override this method to provide localized error messages.
  /// The default implementation returns [errorText] or a fallback message.
  String getLocalizedErrorText(BuildContext? context) {
    return errorText ?? getFallbackErrorText();
  }

  /// Returns a fallback error message when no localized message is available.
  ///
  /// This should return an English error message as a fallback.
  String getFallbackErrorText();

  @override
  String? validate(T? valueCandidate) {
    // For translated validators, we don't use the standard validate
    // Instead, we require a BuildContext for localization
    throw UnimplementedError(
      'TranslatedValidator requires validateWithContext to be called instead of validate',
    );
  }

  /// Validates the value with localization support.
  ///
  /// [context]: BuildContext for accessing localization (optional)
  /// [valueCandidate]: The value to validate
  ///
  /// Returns null if valid, or a localized error message if invalid.
  String? validateWithContext(BuildContext? context, T? valueCandidate) {
    final bool isNullOrEmpty = this.isNullOrEmpty(valueCandidate);

    if (checkNullOrEmpty && isNullOrEmpty) {
      return getLocalizedErrorText(context);
    } else if (!checkNullOrEmpty && isNullOrEmpty) {
      return null;
    } else {
      final result = validateValue(valueCandidate as T);
      if (result != null) {
        return getLocalizedErrorText(context);
      }
      return null;
    }
  }
}

