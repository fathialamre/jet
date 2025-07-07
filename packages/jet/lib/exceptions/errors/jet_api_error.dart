import 'package:jet/exceptions/errors/jet_exception.dart';

/// Result wrapper for operations that can fail
sealed class JetResult<T> {
  const JetResult();

  /// Create a successful result
  const factory JetResult.success(T data) = JetSuccess<T>;

  /// Create a failure result
  const factory JetResult.failure(JetException exception) = JetFailure<T>;

  /// Check if the result is successful
  bool get isSuccess => this is JetSuccess<T>;

  /// Check if the result is a failure
  bool get isFailure => this is JetFailure<T>;

  /// Get the data if successful, otherwise null
  T? get data => switch (this) {
    JetSuccess<T> success => success.data,
    JetFailure<T> _ => null,
  };

  /// Get the exception if failure, otherwise null
  JetException? get exception => switch (this) {
    JetSuccess<T> _ => null,
    JetFailure<T> failure => failure.exception,
  };

  /// Transform the success value
  JetResult<R> map<R>(R Function(T) transform) => switch (this) {
    JetSuccess<T> success => JetResult.success(transform(success.data)),
    JetFailure<T> failure => JetResult.failure(failure.exception),
  };

  /// Transform the failure exception
  JetResult<T> mapError(JetException Function(JetException) transform) =>
      switch (this) {
        JetSuccess<T> success => success,
        JetFailure<T> failure => JetResult.failure(
          transform(failure.exception),
        ),
      };

  /// Fold the result into a single value
  R fold<R>(R Function(T) onSuccess, R Function(JetException) onFailure) =>
      switch (this) {
        JetSuccess<T> success => onSuccess(success.data),
        JetFailure<T> failure => onFailure(failure.exception),
      };
}

/// Successful result
final class JetSuccess<T> extends JetResult<T> {
  const JetSuccess(this.data);

  final T data;

  @override
  String toString() => 'JetSuccess($data)';
}

/// Failed result
final class JetFailure<T> extends JetResult<T> {
  const JetFailure(this.exception);

  final JetException exception;

  @override
  String toString() => 'JetFailure($exception)';
}

/// Deprecated: Use JetResult instead
@Deprecated('Use JetResult instead')
class JetError {
  final Map<String, List<String>>? fieldErrors;
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;

  JetError({
    this.fieldErrors,
    required this.message,
    required this.error,
    this.stackTrace,
  });

  @override
  String toString() {
    return 'JetError(message: $message, error: $error, stackTrace: $stackTrace, fieldErrors: $fieldErrors)';
  }
}

/// Extension methods for easier exception handling
extension JetResultExtensions<T> on JetResult<T> {
  /// Execute a callback if successful
  JetResult<T> onSuccess(void Function(T) callback) {
    if (this is JetSuccess<T>) {
      callback((this as JetSuccess<T>).data);
    }
    return this;
  }

  /// Execute a callback if failed
  JetResult<T> onFailure(void Function(JetException) callback) {
    if (this is JetFailure<T>) {
      callback((this as JetFailure<T>).exception);
    }
    return this;
  }

  /// Get the data or throw the exception
  T getOrThrow() => switch (this) {
    JetSuccess<T> success => success.data,
    JetFailure<T> failure => throw failure.exception,
  };

  /// Get the data or return a default value
  T getOrElse(T defaultValue) => switch (this) {
    JetSuccess<T> success => success.data,
    JetFailure<T> _ => defaultValue,
  };
}
