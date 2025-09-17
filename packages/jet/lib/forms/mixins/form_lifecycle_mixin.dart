/// Callbacks for form lifecycle events
/// These are configured in JetFormBuilder, not in the notifier
class FormLifecycleCallbacks<Request, Response> {
  /// Called when form submission starts
  final void Function()? onSubmissionStart;

  /// Called when form submission succeeds
  final void Function(Response response, Request request)? onSuccess;

  /// Called when form submission fails
  final void Function(Object error, StackTrace stackTrace)? onSubmissionError;

  /// Called when form validation fails
  final void Function(Object error, StackTrace stackTrace)? onValidationError;

  const FormLifecycleCallbacks({
    this.onSubmissionStart,
    this.onSuccess,
    this.onSubmissionError,
    this.onValidationError,
  });
}

/// Mixin that provides lifecycle callback functionality
mixin FormLifecycleMixin<Request, Response> {
  FormLifecycleCallbacks<Request, Response>? _callbacks;

  /// Set the lifecycle callbacks (called by JetFormBuilder)
  void setLifecycleCallbacks(
    FormLifecycleCallbacks<Request, Response>? callbacks,
  ) {
    _callbacks = callbacks;
  }

  /// Trigger submission start callback
  void triggerSubmissionStart() {
    _callbacks?.onSubmissionStart?.call();
  }

  /// Trigger success callback
  void triggerSuccess(Response response, Request request) {
    _callbacks?.onSuccess?.call(response, request);
  }

  /// Trigger submission error callback
  void triggerSubmissionError(Object error, StackTrace stackTrace) {
    _callbacks?.onSubmissionError?.call(error, stackTrace);
  }

  /// Trigger validation error callback
  void triggerValidationError(Object error, StackTrace stackTrace) {
    _callbacks?.onValidationError?.call(error, stackTrace);
  }
}
