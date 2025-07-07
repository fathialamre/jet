import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:jet/exceptions/errors/jet_api_error.dart';
import 'package:jet/exceptions/errors/jet_exception.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:jet/helpers/jet_logger.dart';

/// Simplified error handler that converts exceptions to JetExceptions
class JetErrorHandler {
  /// Convert any error to a JetException (static method for convenience)
  static JetException handle(
    Object error,
    BuildContext context, {
    StackTrace? stackTrace,
  }) {
    return JetErrorHandler().handleErrorInternal(
      error,
      context,
      stackTrace: stackTrace,
    );
  }

  /// Convert any error to a JetException (instance method for configurability)
  JetException handleError(
    Object error,
    BuildContext context, {
    StackTrace? stackTrace,
  }) {
    return handleErrorInternal(error, context, stackTrace: stackTrace);
  }

  /// Internal method that does the actual error handling
  /// Can be overridden by subclasses for custom behavior
  @protected
  JetException handleErrorInternal(
    Object error,
    BuildContext context, {
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      dump(error, stackTrace: stackTrace, tag: 'JET ERROR HANDLER');
    }

    return switch (error) {
      // Already a JetException, return as-is
      JetException jetException => jetException,

      // Network/connectivity errors
      SocketException _ => JetNetworkException.noConnection(
        message: context.jetI10n.noInternetConnection,
        stackTrace: stackTrace,
        originalError: error,
      ),

      // Dio HTTP errors
      DioException dioError => _handleDioException(
        dioError,
        context,
        stackTrace,
      ),

      // Any other error
      _ => JetAppException.unknown(
        message: context.jetI10n.unknownError,
        stackTrace: stackTrace,
        originalError: error,
      ),
    };
  }

  /// Handle Dio exceptions with proper categorization
  static JetException _handleDioException(
    DioException error,
    BuildContext context,
    StackTrace? stackTrace,
  ) {
    // Handle connection/timeout errors first
    if (error.response?.statusCode == null) {
      return switch (error.type) {
        DioExceptionType.connectionError => JetNetworkException.noConnection(
          message: context.jetI10n.noInternetConnection,
          stackTrace: stackTrace,
          originalError: error,
        ),
        DioExceptionType.connectionTimeout => JetNetworkException.timeout(
          message: context.jetI10n.connectionTimeout,
          stackTrace: stackTrace,
          originalError: error,
        ),
        DioExceptionType.sendTimeout => JetNetworkException.timeout(
          message: context.jetI10n.sendTimeout,
          stackTrace: stackTrace,
          originalError: error,
        ),
        DioExceptionType.receiveTimeout => JetNetworkException.timeout(
          message: context.jetI10n.receiveTimeout,
          stackTrace: stackTrace,
          originalError: error,
        ),
        DioExceptionType.badCertificate => JetNetworkException.serverError(
          statusCode: 0,
          message: context.jetI10n.badCertificate,
          stackTrace: stackTrace,
          originalError: error,
        ),
        DioExceptionType.badResponse => JetNetworkException.serverError(
          statusCode: error.response?.statusCode ?? 0,
          message: context.jetI10n.badResponse,
          stackTrace: stackTrace,
          originalError: error,
        ),
        DioExceptionType.cancel => JetAppException.unknown(
          message: context.jetI10n.requestCancelled,
          stackTrace: stackTrace,
          originalError: error,
        ),
        DioExceptionType.unknown => JetAppException.unknown(
          message: _getErrorMessage(error, context),
          stackTrace: stackTrace,
          originalError: error,
        ),
      };
    }

    // Handle HTTP status codes
    return switch (error.response!.statusCode!) {
      // Validation errors
      422 => _handleValidationError(error, context, stackTrace),

      // Client errors (4xx)
      400 => JetNetworkException.clientError(
        statusCode: 400,
        message: _getErrorMessage(error, context),
        stackTrace: stackTrace,
        originalError: error,
      ),
      401 => JetAuthException.unauthorized(
        message: _getErrorMessage(error, context),
        stackTrace: stackTrace,
        originalError: error,
      ),
      403 => JetAuthException.forbidden(
        message: _getErrorMessage(error, context),
        stackTrace: stackTrace,
        originalError: error,
      ),
      404 => JetAppException.notFound(
        message: _getErrorMessage(error, context),
        stackTrace: stackTrace,
        originalError: error,
      ),
      >= 400 && < 500 => JetNetworkException.clientError(
        statusCode: error.response!.statusCode!,
        message: _getErrorMessage(error, context),
        stackTrace: stackTrace,
        originalError: error,
      ),

      // Server errors (5xx)
      >= 500 => JetNetworkException.serverError(
        statusCode: error.response!.statusCode!,
        message: _getErrorMessage(error, context),
        stackTrace: stackTrace,
        originalError: error,
      ),

      // Other status codes
      _ => JetAppException.unknown(
        message: _getErrorMessage(error, context),
        stackTrace: stackTrace,
        originalError: error,
      ),
    };
  }

  /// Handle validation errors with field-specific information
  static JetException _handleValidationError(
    DioException error,
    BuildContext context,
    StackTrace? stackTrace,
  ) {
    final responseData = error.response?.data as Map<String, dynamic>?;

    if (responseData == null) {
      return JetValidationException.form(
        message: context.jetI10n.someFieldsAreInvalid,
        stackTrace: stackTrace,
        originalError: error,
      );
    }

    final errors = responseData['errors'] as Map<String, dynamic>?;
    final fieldErrors = <String, List<String>>{};

    if (errors != null) {
      errors.forEach((key, value) {
        if (value is List) {
          fieldErrors[key] = value.cast<String>();
        }
      });
    }

    return fieldErrors.isNotEmpty
        ? JetValidationException.field(
            fieldErrors: fieldErrors,
            message: _getErrorMessage(error, context),
            stackTrace: stackTrace,
            originalError: error,
          )
        : JetValidationException.form(
            message: _getErrorMessage(error, context),
            stackTrace: stackTrace,
            originalError: error,
          );
  }

  /// Extract error message from DioException response
  static String _getErrorMessage(DioException error, BuildContext context) {
    final responseData = error.response?.data as Map<String, dynamic>?;
    return responseData?['message'] ?? context.jetI10n.unknownError;
  }
}

/// Extension methods for easier error handling
extension JetErrorHandlerExtensions on BuildContext {
  /// Handle any error and convert to JetException
  JetException handleError(Object error, [StackTrace? stackTrace]) {
    return JetErrorHandler.handle(error, this, stackTrace: stackTrace);
  }
}

/// Deprecated: Use JetErrorHandler instead
@Deprecated('Use JetErrorHandler instead')
abstract class JetBaseErrorHandler {
  JetError handle(Object error, BuildContext context, StackTrace stackTrace);
  JetError validation(
    DioException error,
    BuildContext context,
    StackTrace stackTrace,
  );
  JetError badRequest(
    DioException error,
    BuildContext context,
    StackTrace stackTrace,
  );
  JetError unauthorized(
    DioException error,
    BuildContext context,
    StackTrace stackTrace,
  );
  JetError forbidden(
    DioException error,
    BuildContext context,
    StackTrace stackTrace,
  );
  JetError notFound(
    DioException error,
    BuildContext context,
    StackTrace stackTrace,
  );
  JetError internalServerError(
    DioException error,
    BuildContext context,
    StackTrace stackTrace,
  );
  JetError unknown(
    DioException error,
    BuildContext context,
    StackTrace stackTrace,
  );
  JetError dioTypedError(
    DioException error,
    BuildContext context,
    StackTrace stackTrace,
  );
}
