import 'package:flutter/material.dart';
import '../core/jet_form_field.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../common.dart';
import '../mixins/mixins.dart';
import '../notifiers/jet_form_notifier.dart';
import 'jet_form_controller.dart';

/// A hook that creates a simple form controller without requiring a separate notifier class.
///
/// This hook simplifies form handling for simple use cases by allowing you to define
/// form logic inline without creating separate notifier files.
///
/// **Important:** This hook must be used within a [HookConsumerWidget].
///
/// Example:
/// ```dart
/// class LoginPage extends HookConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final form = useJetForm<LoginRequest, LoginResponse>(
///       ref: ref,
///       decoder: (json) => LoginRequest.fromJson(json),
///       action: (request) async {
///         return await apiService.login(request);
///       },
///       onSuccess: (response, request) {
///         context.showToast('Login successful!');
///         Navigator.pushReplacement(context, HomePage.route());
///       },
///       onError: (error, stackTrace) {
///         print('Login error: $error');
///       },
///     );
///
///     return JetSimpleForm(
///       controller: form,
///       children: [
///         FormBuilderTextField(name: 'email'),
///         JetPasswordField(name: 'password'),
///       ],
///     );
///   }
/// }
/// ```
///
/// Parameters:
/// - [ref]: WidgetRef from HookConsumerWidget
/// - [decoder]: Function to convert form values (Map) to Request object
/// - [action]: Async function that processes the request and returns a response
/// - [initialValues]: Initial values for the form fields
/// - [onSuccess]: Callback invoked when form submission succeeds
/// - [onError]: Callback invoked when form submission fails
/// - [onValidationError]: Callback invoked when form validation fails
JetFormController<Request, Response> useJetForm<Request, Response>({
  required WidgetRef ref,
  required Request Function(Map<String, dynamic> json) decoder,
  required Future<Response> Function(Request data) action,
  Map<String, dynamic> initialValues = const {},
  void Function(Response response, Request request)? onSuccess,
  void Function(Object error, StackTrace stackTrace)? onError,
  void Function(Object error, StackTrace stackTrace)? onValidationError,
}) {
  // Create a unique key for this hook instance
  final hookId = useRef(DateTime.now().microsecondsSinceEpoch.toString());

  // Create form key that persists across rebuilds
  final formKey = useMemoized(() => GlobalKey<JetFormState>());

  // Create a provider for this specific form instance
  final provider =
      useMemoized<
        NotifierProvider<
          _InlineFormNotifier<Request, Response>,
          AsyncFormValue<Request, Response>
        >
      >(
        () =>
            NotifierProvider<
              _InlineFormNotifier<Request, Response>,
              AsyncFormValue<Request, Response>
            >(
              () => _InlineFormNotifier<Request, Response>(
                decoder: decoder,
                action: action,
                formKey: formKey,
                onSuccess: onSuccess,
                onError: onError,
                onValidationError: onValidationError,
              ),
              name: 'useJetForm_${hookId.value}',
            ),
        [],
      );

  // Watch the form state
  final state = ref.watch(provider);
  final notifier = ref.read(provider.notifier);

  // Create controller
  return JetFormController<Request, Response>(
    formKey: formKey,
    state: state,
    submit: notifier.submit,
    reset: notifier.reset,
    validateField: notifier.validateSingleField,
    validateForm: notifier.validateForm,
    invalidateFields: notifier.invalidateFormFields,
  );
}

/// Internal notifier class used by useJetForm hook
class _InlineFormNotifier<Request, Response>
    extends JetFormNotifier<Request, Response> {
  final Request Function(Map<String, dynamic> json) _decoder;
  final Future<Response> Function(Request data) _action;
  final GlobalKey<JetFormState> _formKey;

  _InlineFormNotifier({
    required Request Function(Map<String, dynamic> json) decoder,
    required Future<Response> Function(Request data) action,
    required GlobalKey<JetFormState> formKey,
    void Function(Response response, Request request)? onSuccess,
    void Function(Object error, StackTrace stackTrace)? onError,
    void Function(Object error, StackTrace stackTrace)? onValidationError,
  }) : _decoder = decoder,
       _action = action,
       _formKey = formKey {
    // Setup lifecycle callbacks if provided
    if (onSuccess != null || onError != null || onValidationError != null) {
      setLifecycleCallbacks(
        FormLifecycleCallbacks<Request, Response>(
          onSuccess: onSuccess,
          onSubmissionError: onError,
          onValidationError: onValidationError,
        ),
      );
    }
  }

  @override
  GlobalKey<JetFormState> get formKey => _formKey;

  @override
  AsyncFormValue<Request, Response> build() {
    return const AsyncFormIdle();
  }

  @override
  Request decoder(Map<String, dynamic> json) => _decoder(json);

  @override
  Future<Response> action(Request data) => _action(data);
}
