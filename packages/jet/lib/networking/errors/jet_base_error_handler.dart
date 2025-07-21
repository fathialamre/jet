import 'dart:io';
import 'package:dio/dio.dart';
import 'jet_error.dart';

/// Abstract base class for handling errors in the Jet framework
/// Provides a contract for implementing custom error handlers
abstract class JetBaseErrorHandler {
  /// Handle any error and convert it to a standardized JetError
  ///
  /// This method should be overridden by concrete implementations
  /// to provide custom error handling logic
  JetError handle(Object error, [StackTrace? stackTrace]);

  /// Check if the error is a no-internet error
  ///
  /// Override this method to customize no-internet detection logic
  bool isNoInternetError(Object error) {
    if (error is DioException) {
      // Check for socket exceptions that indicate no internet
      if (error.error is SocketException) {
        final socketException = error.error as SocketException;
        return socketException.osError?.errorCode ==
                7 || // No address associated with hostname
            socketException.osError?.errorCode ==
                8 || // Nodename nor servname provided, or not known
            socketException.osError?.errorCode ==
                -2 || // Name or service not known
            socketException.osError?.errorCode ==
                -3 || // Temporary failure in name resolution
            socketException.osError?.errorCode == 110 || // Connection timed out
            socketException.osError?.errorCode == 111; // Connection refused
      }

      // Check for connection timeout
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return true;
      }

      // Check error message for network-related keywords
      final message = error.message?.toLowerCase() ?? '';
      return message.contains('network') ||
          message.contains('connection') ||
          message.contains('unreachable') ||
          message.contains('no address') ||
          message.contains('dns') ||
          message.contains('resolve');
    }

    if (error is SocketException) {
      return true;
    }

    // Check error message for common no-internet phrases
    final errorMessage = error.toString().toLowerCase();
    return errorMessage.contains('no internet') ||
        errorMessage.contains('network unavailable') ||
        errorMessage.contains('connection failed') ||
        errorMessage.contains('host unreachable');
  }

  /// Check if the error is a validation error
  ///
  /// Override this method to customize validation error detection
  bool isValidationError(Object error) {
    if (error is DioException) {
      return error.response?.statusCode == 422 || // Unprocessable Entity
          error.response?.statusCode == 400; // Bad Request
    }
    return false;
  }

  /// Extract validation errors from the error response
  ///
  /// Override this method to customize validation error extraction
  Map<String, List<String>>? extractValidationErrors(Object error) {
    if (error is DioException && error.response?.data is Map<String, dynamic>) {
      final data = error.response!.data as Map<String, dynamic>;

      // Try different common validation error formats
      if (data.containsKey('errors') && data['errors'] is Map) {
        final errors = data['errors'] as Map<String, dynamic>;
        final result = <String, List<String>>{};

        errors.forEach((key, value) {
          if (value is List) {
            result[key] = value.map((e) => e.toString()).toList();
          } else if (value is String) {
            result[key] = [value];
          }
        });

        return result.isNotEmpty ? result : null;
      }

      // Laravel-style validation errors
      if (data.containsKey('message') && data.containsKey('errors')) {
        final errors = data['errors'];
        if (errors is Map<String, dynamic>) {
          final result = <String, List<String>>{};
          errors.forEach((key, value) {
            if (value is List) {
              result[key] = value.map((e) => e.toString()).toList();
            } else if (value is String) {
              result[key] = [value];
            }
          });
          return result.isNotEmpty ? result : null;
        }
      }
    }

    return null;
  }

  /// Get user-friendly error message
  ///
  /// Override this method to customize error messages
  String getErrorMessage(Object error) {
    if (error is DioException) {
      // Handle different types of Dio exceptions
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Connection timeout. Please check your internet connection and try again.';
        case DioExceptionType.sendTimeout:
          return 'Send timeout. Please try again.';
        case DioExceptionType.receiveTimeout:
          return 'Receive timeout. Please try again.';
        case DioExceptionType.badCertificate:
          return 'Security certificate error. Please try again later.';
        case DioExceptionType.badResponse:
          return _handleBadResponse(error);
        case DioExceptionType.cancel:
          return 'Request was cancelled.';
        case DioExceptionType.connectionError:
          return 'Connection error. Please check your internet connection.';
        case DioExceptionType.unknown:
          return _handleUnknownDioError(error);
      }
    }

    return error.toString();
  }

  /// Handle bad response errors (4xx, 5xx status codes)
  String _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;

    if (statusCode == null) {
      return 'Network error occurred. Please try again.';
    }

    // Client errors (4xx)
    if (statusCode >= 400 && statusCode < 500) {
      switch (statusCode) {
        case 400:
          return 'Bad request. Please check your input and try again.';
        case 401:
          return 'Authentication failed. Please log in again.';
        case 403:
          return 'Access denied. You don\'t have permission to perform this action.';
        case 404:
          return 'The requested resource was not found.';
        case 422:
          return 'Validation failed. Please check your input.';
        case 429:
          return 'Too many requests. Please wait and try again.';
        default:
          return 'Client error occurred. Please try again.';
      }
    }

    // Server errors (5xx)
    if (statusCode >= 500 && statusCode < 600) {
      switch (statusCode) {
        case 500:
          return 'Internal server error. Please try again later.';
        case 502:
          return 'Bad gateway. Please try again later.';
        case 503:
          return 'Service unavailable. Please try again later.';
        case 504:
          return 'Gateway timeout. Please try again later.';
        default:
          return 'Server error occurred. Please try again later.';
      }
    }

    return 'HTTP error $statusCode occurred.';
  }

  /// Handle unknown Dio errors
  String _handleUnknownDioError(DioException error) {
    final message = error.message?.toLowerCase() ?? '';

    if (message.contains('socket') || message.contains('network')) {
      return 'Network connection error. Please check your internet connection.';
    }

    if (message.contains('certificate') ||
        message.contains('ssl') ||
        message.contains('tls')) {
      return 'Security certificate error. Please try again later.';
    }

    return 'Network error occurred. Please try again.';
  }

  /// Get the error type based on the error
  JetErrorType getErrorType(Object error) {
    if (isNoInternetError(error)) {
      return JetErrorType.noInternet;
    }

    if (isValidationError(error)) {
      return JetErrorType.validation;
    }

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return JetErrorType.timeout;
        case DioExceptionType.cancel:
          return JetErrorType.cancelled;
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode != null && statusCode >= 500) {
            return JetErrorType.server;
          } else if (statusCode != null && statusCode >= 400) {
            return JetErrorType.client;
          }
          break;
        default:
          break;
      }
    }

    return JetErrorType.unknown;
  }

  /// Get the HTTP status code from the error (if applicable)
  int? getStatusCode(Object error) {
    if (error is DioException) {
      return error.response?.statusCode;
    }
    return null;
  }

  /// Create additional metadata for the error
  Map<String, dynamic>? createMetadata(Object error) {
    final metadata = <String, dynamic>{};

    if (error is DioException) {
      metadata['dioErrorType'] = error.type.name;
      if (error.response != null) {
        metadata['statusCode'] = error.response!.statusCode;
        metadata['statusMessage'] = error.response!.statusMessage;
        metadata['requestPath'] = error.requestOptions.path;
        metadata['requestMethod'] = error.requestOptions.method;
      }
    }

    return metadata.isNotEmpty ? metadata : null;
  }
}
