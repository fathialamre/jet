/// # Jet Exception System
///
/// This module provides a comprehensive, type-safe exception handling system for the Jet framework.
///
/// ## Key Features
///
/// - **Sealed class hierarchy**: Better pattern matching and type safety
/// - **Factory constructors**: Eliminates code duplication
/// - **Result pattern**: Functional approach to error handling
/// - **Extension methods**: Convenient error handling utilities
/// - **Proper categorization**: Network, validation, auth, and app exceptions
///
/// ## Usage Examples
///
/// ### Basic Exception Handling
/// ```dart
/// try {
///   // Some operation that might fail
///   await apiCall();
/// } catch (error, stackTrace) {
///   final jetException = JetErrorHandler.handle(error, context, stackTrace: stackTrace);
///
///   switch (jetException) {
///     case JetNetworkException():
///       // Handle network errors
///     case JetValidationException():
///       // Handle validation errors
///     case JetAuthException():
///       // Handle authentication errors
///   }
/// }
/// ```
///
/// ### Result Pattern
/// ```dart
/// Future<JetResult<String>> fetchData() async {
///   try {
///     final data = await apiCall();
///     return JetResult.success(data);
///   } catch (error, stackTrace) {
///     final exception = JetErrorHandler.handle(error, context, stackTrace: stackTrace);
///     return JetResult.failure(exception);
///   }
/// }
///
/// // Using the result
/// final result = await fetchData();
/// result
///   .onSuccess((data) => print('Success: $data'))
///   .onFailure((exception) => print('Error: ${exception.message}'));
/// ```
///
/// ### Creating Specific Exceptions
/// ```dart
/// // Network exceptions
/// final noConnection = JetNetworkException.noConnection();
/// final timeout = JetNetworkException.timeout();
/// final serverError = JetNetworkException.serverError(statusCode: 500);
///
/// // Validation exceptions
/// final fieldError = JetValidationException.field(fieldErrors: {'email': ['Invalid']});
/// final formError = JetValidationException.form();
///
/// // Auth exceptions
/// final unauthorized = JetAuthException.unauthorized();
/// final forbidden = JetAuthException.forbidden();
/// ```
///
/// ### Custom Error Handler
/// ```dart
/// class CustomErrorHandler extends JetErrorHandler {
///   @override
///   JetException handleErrorInternal(
///     Object error,
///     BuildContext context, {
///     StackTrace? stackTrace,
///   }) {
///     // Custom logic before default handling
///     if (error is CustomException) {
///       return JetAppException.unknown(
///         message: 'Custom error: ${error.message}',
///         stackTrace: stackTrace,
///         originalError: error,
///       );
///     }
///
///     // Use default handling for other errors
///     return super.handleErrorInternal(error, context, stackTrace: stackTrace);
///   }
/// }
///
/// // In your JetConfig:
/// class AppConfig extends JetConfig {
///   @override
///   JetErrorHandler get errorHandler => CustomErrorHandler();
/// }
/// ```

// Core exception classes
export 'errors/jet_exception.dart';
export 'errors/jet_api_error.dart';
export 'errors/jet_error_handler.dart';
export 'errors/jet_form_validation_error.dart';

// Re-export commonly used types for convenience
export 'errors/jet_exception.dart'
    show
        JetException,
        JetNetworkException,
        JetValidationException,
        JetAuthException,
        JetAppException,
        NoConnectionException,
        TimeoutException,
        ServerErrorException,
        ClientErrorException,
        FieldValidationException,
        FormValidationException,
        UnauthorizedException,
        ForbiddenException,
        NotFoundException,
        UnknownException;

export 'errors/jet_api_error.dart'
    show JetResult, JetSuccess, JetFailure, JetResultExtensions;
