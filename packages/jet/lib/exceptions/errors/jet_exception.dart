/// Base exception class for all Jet framework errors
abstract class JetException implements Exception {
  const JetException({
    required this.message,
    this.stackTrace,
    this.originalError,
  });

  final String message;
  final StackTrace? stackTrace;
  final Object? originalError;

  @override
  String toString() => 'JetException: $message';
}

/// Network-related exceptions
sealed class JetNetworkException extends JetException {
  const JetNetworkException({
    required super.message,
    super.stackTrace,
    super.originalError,
  });

  factory JetNetworkException.noConnection({
    String? message,
    StackTrace? stackTrace,
    Object? originalError,
  }) = NoConnectionException;

  factory JetNetworkException.timeout({
    String? message,
    StackTrace? stackTrace,
    Object? originalError,
  }) = TimeoutException;

  factory JetNetworkException.serverError({
    required int statusCode,
    String? message,
    StackTrace? stackTrace,
    Object? originalError,
  }) = ServerErrorException;

  factory JetNetworkException.clientError({
    required int statusCode,
    String? message,
    StackTrace? stackTrace,
    Object? originalError,
  }) = ClientErrorException;
}

/// No internet connection exception
final class NoConnectionException extends JetNetworkException {
  const NoConnectionException({
    String? message,
    super.stackTrace,
    super.originalError,
  }) : super(message: message ?? 'No internet connection');
}

/// Request timeout exception
final class TimeoutException extends JetNetworkException {
  const TimeoutException({
    String? message,
    super.stackTrace,
    super.originalError,
  }) : super(message: message ?? 'Request timeout');
}

/// Server error (5xx) exception
final class ServerErrorException extends JetNetworkException {
  const ServerErrorException({
    required this.statusCode,
    String? message,
    super.stackTrace,
    super.originalError,
  }) : super(message: message ?? 'Server error');

  final int statusCode;

  @override
  String toString() => 'ServerErrorException($statusCode): $message';
}

/// Client error (4xx) exception
final class ClientErrorException extends JetNetworkException {
  const ClientErrorException({
    required this.statusCode,
    String? message,
    super.stackTrace,
    super.originalError,
  }) : super(message: message ?? 'Client error');

  final int statusCode;

  @override
  String toString() => 'ClientErrorException($statusCode): $message';
}

/// Validation-related exceptions
sealed class JetValidationException extends JetException {
  const JetValidationException({
    required super.message,
    super.stackTrace,
    super.originalError,
  });

  factory JetValidationException.field({
    required Map<String, List<String>> fieldErrors,
    String? message,
    StackTrace? stackTrace,
    Object? originalError,
  }) = FieldValidationException;

  factory JetValidationException.form({
    String? message,
    StackTrace? stackTrace,
    Object? originalError,
  }) = FormValidationException;
}

/// Field validation exception with specific field errors
final class FieldValidationException extends JetValidationException {
  const FieldValidationException({
    required this.fieldErrors,
    String? message,
    super.stackTrace,
    super.originalError,
  }) : super(message: message ?? 'Some fields are invalid');

  final Map<String, List<String>> fieldErrors;

  @override
  String toString() =>
      'FieldValidationException: $message\nFields: $fieldErrors';
}

/// Form validation exception
final class FormValidationException extends JetValidationException {
  const FormValidationException({
    String? message,
    super.stackTrace,
    super.originalError,
  }) : super(message: message ?? 'Form validation failed');
}

/// Authentication and authorization exceptions
sealed class JetAuthException extends JetException {
  const JetAuthException({
    required super.message,
    super.stackTrace,
    super.originalError,
  });

  factory JetAuthException.unauthorized({
    String? message,
    StackTrace? stackTrace,
    Object? originalError,
  }) = UnauthorizedException;

  factory JetAuthException.forbidden({
    String? message,
    StackTrace? stackTrace,
    Object? originalError,
  }) = ForbiddenException;
}

/// Unauthorized access exception
final class UnauthorizedException extends JetAuthException {
  const UnauthorizedException({
    String? message,
    super.stackTrace,
    super.originalError,
  }) : super(message: message ?? 'Unauthorized access');
}

/// Forbidden access exception
final class ForbiddenException extends JetAuthException {
  const ForbiddenException({
    String? message,
    super.stackTrace,
    super.originalError,
  }) : super(message: message ?? 'Forbidden access');
}

/// Generic application exceptions
sealed class JetAppException extends JetException {
  const JetAppException({
    required super.message,
    super.stackTrace,
    super.originalError,
  });

  factory JetAppException.notFound({
    String? message,
    StackTrace? stackTrace,
    Object? originalError,
  }) = NotFoundException;

  factory JetAppException.unknown({
    String? message,
    StackTrace? stackTrace,
    Object? originalError,
  }) = UnknownException;
}

/// Not found exception
final class NotFoundException extends JetAppException {
  const NotFoundException({
    String? message,
    super.stackTrace,
    super.originalError,
  }) : super(message: message ?? 'Resource not found');
}

/// Unknown exception
final class UnknownException extends JetAppException {
  const UnknownException({
    String? message,
    super.stackTrace,
    super.originalError,
  }) : super(message: message ?? 'Unknown error occurred');
}
