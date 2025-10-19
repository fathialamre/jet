import 'package:jet/forms/localization/jet_form_localizations.dart';
import 'package:jet/networking/errors/jet_error.dart';


/// Mixin that provides error handling capabilities for forms
mixin FormErrorHandlingMixin {
  /// Convert any error to JetError for consistent handling
  JetError convertToJetError(Object error, StackTrace stackTrace) {
    if (error is JetError) {
      return error;
    }

    return JetError.unknown(
      message: error.toString(),
      rawError: error,
      stackTrace: stackTrace,
    );
  }

  /// Create a validation error from form errors
  JetError createValidationError(Map<String, List<String>> formErrors) {
    return JetError.validation(
      message: JetFormLocalizations.current.alphabeticalErrorText,
      errors: formErrors,
    );
  }
}
