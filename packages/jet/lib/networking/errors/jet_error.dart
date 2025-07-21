/// Represents an error in the Jet framework with comprehensive error information
class JetError {
  /// Human-readable error message
  final String message;

  /// Validation errors (for form validation failures)
  final Map<String, List<String>>? errors;

  /// The raw/original error object
  final Object? rawError;

  /// Stack trace for debugging
  final StackTrace? stackTrace;

  /// Error type for categorization
  final JetErrorType type;

  /// HTTP status code (if applicable)
  final int? statusCode;

  /// Additional metadata
  final Map<String, dynamic>? metadata;

  const JetError({
    required this.message,
    this.errors,
    this.rawError,
    this.stackTrace,
    this.type = JetErrorType.unknown,
    this.statusCode,
    this.metadata,
  });

  /// Create a network connectivity error
  factory JetError.noInternet() {
    return const JetError(
      message: 'Please check your network settings.',
      type: JetErrorType.noInternet,
    );
  }

  /// Create a server error
  factory JetError.server({
    String? message,
    int? statusCode,
    Object? rawError,
    StackTrace? stackTrace,
  }) {
    return JetError(
      message: message ?? 'Server error occurred',
      type: JetErrorType.server,
      statusCode: statusCode,
      rawError: rawError,
      stackTrace: stackTrace,
    );
  }

  /// Create a client error (4xx status codes)
  factory JetError.client({
    String? message,
    int? statusCode,
    Object? rawError,
    StackTrace? stackTrace,
  }) {
    return JetError(
      message: message ?? 'Client error occurred',
      type: JetErrorType.client,
      statusCode: statusCode,
      rawError: rawError,
      stackTrace: stackTrace,
    );
  }

  /// Create a validation error
  factory JetError.validation({
    String? message,
    Map<String, List<String>>? errors,
    Object? rawError,
    StackTrace? stackTrace,
  }) {
    return JetError(
      message: message ?? 'Validation failed',
      errors: errors,
      type: JetErrorType.validation,
      rawError: rawError,
      stackTrace: stackTrace,
    );
  }

  /// Create a timeout error
  factory JetError.timeout({
    String? message,
    Object? rawError,
    StackTrace? stackTrace,
  }) {
    return JetError(
      message: message ?? 'Request timed out',
      type: JetErrorType.timeout,
      rawError: rawError,
      stackTrace: stackTrace,
    );
  }

  /// Create a cancelled error
  factory JetError.cancelled({
    String? message,
    Object? rawError,
    StackTrace? stackTrace,
  }) {
    return JetError(
      message: message ?? 'Request was cancelled',
      type: JetErrorType.cancelled,
      rawError: rawError,
      stackTrace: stackTrace,
    );
  }

  /// Create an unknown error
  factory JetError.unknown({
    String? message,
    Object? rawError,
    StackTrace? stackTrace,
  }) {
    return JetError(
      message: message ?? 'An unknown error occurred',
      type: JetErrorType.unknown,
      rawError: rawError,
      stackTrace: stackTrace,
    );
  }

  /// Whether this is a validation error
  bool get isValidation => type == JetErrorType.validation;

  /// Whether this is a network connectivity error
  bool get isNoInternet => type == JetErrorType.noInternet;

  /// Whether this is a server error (5xx)
  bool get isServerError => type == JetErrorType.server;

  /// Whether this is a client error (4xx)
  bool get isClientError => type == JetErrorType.client;

  /// Whether this is a timeout error
  bool get isTimeout => type == JetErrorType.timeout;

  /// Whether this is a cancelled error
  bool get isCancelled => type == JetErrorType.cancelled;

  /// Get the first validation error message (if any)
  String? get firstValidationError {
    if (errors == null || errors!.isEmpty) return null;
    final firstKey = errors!.keys.first;
    final firstErrors = errors![firstKey];
    return firstErrors?.isNotEmpty == true ? firstErrors!.first : null;
  }

  /// Get all validation error messages as a single string
  String get allValidationErrors {
    if (errors == null || errors!.isEmpty) return message;

    final allErrors = <String>[];
    errors!.forEach((field, fieldErrors) {
      for (final error in fieldErrors) {
        allErrors.add('$field: $error');
      }
    });

    return allErrors.join('\n');
  }

  @override
  String toString() {
    if (isValidation && errors != null && errors!.isNotEmpty) {
      return allValidationErrors;
    }
    return message;
  }

  /// Convert to a map for serialization
  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'errors': errors,
      'type': type.name,
      'statusCode': statusCode,
      'metadata': metadata,
    };
  }
}

/// Types of errors that can occur in the Jet framework
enum JetErrorType {
  /// No internet connection
  noInternet,

  /// Server error (5xx status codes)
  server,

  /// Client error (4xx status codes)
  client,

  /// Validation error
  validation,

  /// Request timeout
  timeout,

  /// Request was cancelled
  cancelled,

  /// Unknown/unexpected error
  unknown,
}
