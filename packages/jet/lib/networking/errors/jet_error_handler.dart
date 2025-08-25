import 'jet_base_error_handler.dart';
import 'jet_error.dart';

/// Default implementation of error handler for the Jet framework
///
/// This class provides comprehensive error handling for:
/// - No internet connection errors
/// - All Dio exceptions (timeout, bad response, connection errors, etc.)
/// - Validation errors
/// - Other general exceptions
///
/// Usage:
/// ```dart
/// final errorHandler = JetErrorHandler();
/// final jetError = errorHandler.handle(someError, stackTrace);
/// ```
class JetErrorHandler extends JetBaseErrorHandler {
  /// Create a new instance of the default error handler
  JetErrorHandler();

  @override
  JetError handle(Object error, [StackTrace? stackTrace]) {
    // Handle no internet errors first
    if (isNoInternetError(error)) {
      return JetError.noInternet();
    }

    // Handle validation errors
    if (isValidationError(error)) {
      final validationErrors = extractValidationErrors(error);
      return JetError.validation(
        message: getErrorMessage(error),
        errors: validationErrors,
        rawError: error,
        stackTrace: stackTrace,
      );
    }

    // Get error type and other properties
    final errorType = getErrorType(error);
    final message = getErrorMessage(error);
    final statusCode = getStatusCode(error);
    final metadata = createMetadata(error);

    // Create appropriate JetError based on type
    switch (errorType) {
      case JetErrorType.server:
        return JetError.server(
          message: message,
          statusCode: statusCode,
          rawError: error,
          stackTrace: stackTrace,
        );

      case JetErrorType.client:
        return JetError.client(
          message: message,
          statusCode: statusCode,
          rawError: error,
          stackTrace: stackTrace,
        );

      case JetErrorType.timeout:
        return JetError.timeout(
          message: message,
          rawError: error,
          stackTrace: stackTrace,
        );

      case JetErrorType.cancelled:
        return JetError.cancelled(
          message: message,
          rawError: error,
          stackTrace: stackTrace,
        );

      case JetErrorType.noInternet:
        // This should be handled above, but just in case
        return JetError.noInternet();

      case JetErrorType.validation:
        // This should be handled above, but just in case
        return JetError.validation(
          message: message,
          rawError: error,
          stackTrace: stackTrace,
        );

      case JetErrorType.unknown:
      default:
        return JetError.unknown(
          message: message,
          rawError: error,
          stackTrace: stackTrace,
        );
    }
  }

  /// Create a singleton instance for global use
  static final JetErrorHandler instance = JetErrorHandler();
}
