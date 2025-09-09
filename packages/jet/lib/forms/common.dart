/// A class that represents the state of a form, inspired by `AsyncValue` from Riverpod.
///
/// This class can be in one of three states:
/// - [AsyncFormData]: The form has data, which may include initial values,
///   request data, and response data.
/// - [AsyncFormError]: An error occurred. It contains the error and stack trace,
///   and can preserve previous data.
/// - [AsyncFormLoading]: The form is in a loading state. It can preserve
///   previous data while loading.
sealed class AsyncFormValue<Request, Response> {
  const AsyncFormValue();

  /// Creates a form state with data.
  const factory AsyncFormValue.data({
    required Request request,
    required Response response,
  }) = AsyncFormData<Request, Response>;

  /// Creates a form state for an error.
  ///
  /// Optionally, you can provide the previous [request] and [response] data
  /// to be preserved during the error state.
  const factory AsyncFormValue.error(
    Object error,
    StackTrace stackTrace, {
    Request? request,
    Response? response,
  }) = AsyncFormError<Request, Response>;

  /// Creates a loading form state.
  ///
  /// Optionally, you can provide the previous [request] and [response] data
  /// to be preserved during the loading state.
  const factory AsyncFormValue.loading({
    Request? request,
    Response? response,
  }) = AsyncFormLoading<Request, Response>;

  /// Whether the form is currently in a loading state.
  bool get isLoading => this is AsyncFormLoading<Request, Response>;

  /// Whether the form has data.
  bool get hasValue => this is AsyncFormData<Request, Response>;

  Response? get response => this is AsyncFormData<Request, Response>
      ? (this as AsyncFormData<Request, Response>).response
      : null;
  Request? get request => this is AsyncFormData<Request, Response>
      ? (this as AsyncFormData<Request, Response>).request
      : null;

  /// Whether the form is in an error state.
  bool get hasError => this is AsyncFormError<Request, Response>;

  /// Pattern-matching over the form state.
  ///
  /// Provides callbacks for each state: [data], [error], and [loading].
  /// All callbacks are required.
  R map<R>({
    required R Function(AsyncFormData<Request, Response> data) data,
    required R Function(AsyncFormError<Request, Response> error) error,
    required R Function(AsyncFormLoading<Request, Response> loading) loading,
  }) {
    if (this is AsyncFormData<Request, Response>) {
      return data(this as AsyncFormData<Request, Response>);
    }
    if (this is AsyncFormError<Request, Response>) {
      return error(this as AsyncFormError<Request, Response>);
    }
    return loading(this as AsyncFormLoading<Request, Response>);
  }
}

/// Represents the data state of a form.
class AsyncFormData<Request, Response>
    extends AsyncFormValue<Request, Response> {
  /// The request data associated with the form submission.
  final Request request;

  /// The response data from the form submission.
  final Response response;

  const AsyncFormData({required this.request, required this.response});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AsyncFormData<Request, Response> &&
            runtimeType == other.runtimeType &&
            request == other.request &&
            response == other.response;
  }

  @override
  int get hashCode => Object.hash(runtimeType, request, response);

  @override
  String toString() {
    return 'AsyncFormData(request: $request, response: $response)';
  }
}

/// Represents the error state of a form.
class AsyncFormError<Request, Response>
    extends AsyncFormValue<Request, Response> {
  /// The error that occurred.
  final Object error;

  /// The stack trace of the error.
  final StackTrace stackTrace;

  /// The previous request data, if available.
  final Request? request;

  /// The previous response data, if available.
  final Response? response;

  const AsyncFormError(
    this.error,
    this.stackTrace, {
    this.request,
    this.response,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AsyncFormError<Request, Response> &&
            runtimeType == other.runtimeType &&
            error == other.error &&
            stackTrace == other.stackTrace &&
            request == other.request &&
            response == other.response;
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, error, stackTrace, request, response);

  @override
  String toString() {
    return 'AsyncFormError(error: $error, stackTrace: $stackTrace, request: $request, response: $response)';
  }
}

/// Represents the loading state of a form.
class AsyncFormLoading<Request, Response>
    extends AsyncFormValue<Request, Response> {
  /// The previous request data, if available.
  final Request? request;

  /// The previous response data, if available.
  final Response? response;

  const AsyncFormLoading({this.request, this.response});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AsyncFormLoading<Request, Response> &&
            runtimeType == other.runtimeType &&
            request == other.request &&
            response == other.response;
  }

  @override
  int get hashCode => Object.hash(runtimeType, request, response);

  @override
  String toString() {
    return 'AsyncFormLoading(request: $request, response: $response)';
  }
}
