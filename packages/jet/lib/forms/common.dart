/// A class that represents the state of a form, inspired by `AsyncValue` from Riverpod.
///
/// This class can be in one of four states:
/// - [AsyncFormIdle]: The form is in its initial state, not yet submitted.
/// - [AsyncFormData]: The form has data, which may include initial values,
///   request data, and response data.
/// - [AsyncFormError]: An error occurred. It contains the error and stack trace,
///   and can preserve previous data.
/// - [AsyncFormLoading]: The form is in a loading state. It can preserve
///   previous data while loading.
sealed class AsyncFormValue<Request, Response> {
  const AsyncFormValue();

  /// Creates an idle form state (initial state, not yet submitted).
  const factory AsyncFormValue.idle() = AsyncFormIdle<Request, Response>;

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

  /// Whether the form is in its initial idle state.
  bool get isIdle => this is AsyncFormIdle<Request, Response>;

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

  Object? get error => this is AsyncFormError<Request, Response>
      ? (this as AsyncFormError<Request, Response>).error
      : null;

  /// Pattern-matching over the form state.
  ///
  /// Provides callbacks for each state: [idle], [data], [error], and [loading].
  /// All callbacks are required.
  R map<R>({
    required R Function(AsyncFormIdle<Request, Response> idle) idle,
    required R Function(AsyncFormData<Request, Response> data) data,
    required R Function(AsyncFormError<Request, Response> error) error,
    required R Function(AsyncFormLoading<Request, Response> loading) loading,
  }) {
    if (this is AsyncFormIdle<Request, Response>) {
      return idle(this as AsyncFormIdle<Request, Response>);
    }
    if (this is AsyncFormData<Request, Response>) {
      return data(this as AsyncFormData<Request, Response>);
    }
    if (this is AsyncFormError<Request, Response>) {
      return error(this as AsyncFormError<Request, Response>);
    }
    return loading(this as AsyncFormLoading<Request, Response>);
  }

  /// Pattern-matching over the form state with direct values.
  ///
  /// Similar to [map] but with direct return values instead of callbacks.
  /// All parameters are required.
  R when<R>({
    required R idle,
    required R data,
    required R error,
    required R loading,
  }) {
    if (this is AsyncFormIdle<Request, Response>) {
      return idle;
    }
    if (this is AsyncFormData<Request, Response>) {
      return data;
    }
    if (this is AsyncFormError<Request, Response>) {
      return error;
    }
    return loading;
  }

  /// Optional pattern-matching over the form state with direct values.
  ///
  /// Similar to [when] but with optional parameters and a required [orElse] callback.
  R maybeWhen<R>({
    R? idle,
    R? data,
    R? error,
    R? loading,
    required R orElse,
  }) {
    if (this is AsyncFormIdle<Request, Response> && idle != null) {
      return idle;
    }
    if (this is AsyncFormData<Request, Response> && data != null) {
      return data;
    }
    if (this is AsyncFormError<Request, Response> && error != null) {
      return error;
    }
    if (this is AsyncFormLoading<Request, Response> && loading != null) {
      return loading;
    }
    return orElse;
  }

  /// Optional pattern-matching over the form state.
  ///
  /// Similar to [map] but with optional callbacks and a required [orElse] callback.
  R maybeMap<R>({
    R Function(AsyncFormIdle<Request, Response> idle)? idle,
    R Function(AsyncFormData<Request, Response> data)? data,
    R Function(AsyncFormError<Request, Response> error)? error,
    R Function(AsyncFormLoading<Request, Response> loading)? loading,
    required R orElse,
  }) {
    if (this is AsyncFormIdle<Request, Response> && idle != null) {
      return idle(this as AsyncFormIdle<Request, Response>);
    }
    if (this is AsyncFormData<Request, Response> && data != null) {
      return data(this as AsyncFormData<Request, Response>);
    }
    if (this is AsyncFormError<Request, Response> && error != null) {
      return error(this as AsyncFormError<Request, Response>);
    }
    if (this is AsyncFormLoading<Request, Response> && loading != null) {
      return loading(this as AsyncFormLoading<Request, Response>);
    }
    return orElse;
  }
}

/// Represents the idle state of a form (initial state, not yet submitted).
class AsyncFormIdle<Request, Response>
    extends AsyncFormValue<Request, Response> {
  const AsyncFormIdle();

  /// The request data is null in idle state.
  @override
  Request? get request => null;

  /// The response data is null in idle state.
  @override
  Response? get response => null;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AsyncFormIdle<Request, Response> &&
            runtimeType == other.runtimeType;
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AsyncFormIdle()';
  }
}

/// Represents the data state of a form.
class AsyncFormData<Request, Response>
    extends AsyncFormValue<Request, Response> {
  /// The request data associated with the form submission.
  @override
  final Request request;

  /// The response data from the form submission.
  @override
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
  @override
  final Request? request;

  /// The previous response data, if available.
  @override
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
  @override
  final Request? request;

  /// The previous response data, if available.
  @override
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
