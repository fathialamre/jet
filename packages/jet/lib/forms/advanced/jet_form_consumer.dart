import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/forms/advanced/jet_form_notifier.dart';
import 'package:jet/forms/core/jet_form_field.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:jet/bootstrap/boot.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:jet/forms/common.dart';
import 'package:jet/networking/errors/jet_error.dart';
import 'package:jet/widgets/buttons/jet_button.dart';

/// A reactive form widget that integrates with Riverpod state management.
///
/// [JetFormConsumer] provides a declarative way to build forms that automatically
/// react to state changes, handle validation, manage submissions, and process
/// errors. It bridges Jet forms with Riverpod providers for seamless state management.
///
/// ## Key Features
///
/// - **Reactive State Management**: Automatically reacts to provider state changes
/// - **Built-in Error Handling**: Processes and displays errors from form submissions
/// - **Validation Integration**: Connects backend validation errors to form fields
/// - **Flexible Callbacks**: Hooks for success and error scenarios
/// - **Default UI Elements**: Optional submit button with loading states
/// - **Static Values**: Merge additional data that isn't collected from fields
///
/// ## Basic Usage
///
/// ```dart
/// JetFormConsumer<LoginRequest, LoginResponse>(
///   provider: loginFormProvider,
///   builder: (context, ref, form, formState) => [
///     JetEmailField(name: 'email'),
///     JetPasswordField(name: 'password'),
///   ],
///   onSuccess: (response, request) {
///     // Navigate to home screen
///     context.go('/home');
///   },
/// )
/// ```
///
/// ## Advanced Usage
///
/// For forms requiring custom error handling or UI control:
///
/// ```dart
/// JetFormConsumer.advanced(
///   provider: complexFormProvider,
///   builder: (context, ref, form, formState) => [
///     JetTextField(name: 'title'),
///     // Custom submit button
///     CustomButton(
///       onPressed: () => form.submit(),
///       loading: formState.isLoading,
///     ),
///   ],
///   useDefaultErrorHandler: false,
///   showDefaultSubmitButton: false,
///   onError: (error, stackTrace, invalidateFields) {
///     // Custom error processing
///   },
/// )
/// ```
///
/// ## Type Parameters
///
/// - `Request`: The type of data sent to the backend (e.g., LoginRequest)
/// - `Response`: The type of data received from the backend (e.g., LoginResponse)
///
/// See also:
/// - [FormNotifierBase], the notifier that manages form state
/// - [AsyncFormValue], the state structure for async form operations
/// - [JetFormBuilder], for basic forms without state management integration
class JetFormConsumer<Request, Response> extends ConsumerWidget {
  /// The Riverpod provider that manages this form's state.
  ///
  /// This provider should return an [AsyncFormValue] and have a notifier
  /// that extends [FormNotifierBase].
  ///
  /// Example:
  /// ```dart
  /// final loginFormProvider = StateNotifierProvider<LoginFormNotifier, AsyncFormValue>((ref) {
  ///   return LoginFormNotifier(ref);
  /// });
  /// ```
  final ProviderListenable<AsyncFormValue<Request, Response>> provider;

  /// Builder function that returns a list of form field widgets.
  ///
  /// This function is called on every state change and provides:
  /// - `context`: The build context
  /// - `ref`: The widget ref for reading other providers
  /// - `form`: The form notifier with methods like submit(), reset()
  /// - `formState`: The current async state (idle, loading, data, error)
  ///
  /// Returns a list of widgets that will be displayed in a [Column] with
  /// spacing defined by [fieldSpacing].
  final List<Widget> Function(
    BuildContext context,
    WidgetRef ref,
    FormNotifierBase<Request, Response> form,
    AsyncFormValue<Request, Response> formState,
  )
  builder;

  /// Callback invoked when form submission succeeds.
  ///
  /// Receives both the response data from the backend and the original
  /// request data that was submitted.
  ///
  /// Common use cases:
  /// - Navigate to a new screen
  /// - Show success message
  /// - Update app state with response data
  /// - Clear form or reset to initial state
  ///
  /// Example:
  /// ```dart
  /// onSuccess: (response, request) {
  ///   context.showToast('Login successful!');
  ///   context.go('/dashboard');
  /// }
  /// ```
  final void Function(Response responseData, Request requestData)? onSuccess;

  /// Callback invoked when form submission encounters an error.
  ///
  /// Provides:
  /// - `error`: The error object (typically a [JetError])
  /// - `stackTrace`: The error's stack trace for debugging
  /// - `invalidateFields`: Function to manually mark fields as invalid
  ///
  /// This is called after the default error handler (if enabled) processes
  /// the error, allowing you to add custom error handling logic.
  ///
  /// Example:
  /// ```dart
  /// onError: (error, stackTrace, invalidateFields) {
  ///   if (error is JetError && error.statusCode == 401) {
  ///     context.go('/login');
  ///   }
  /// }
  /// ```
  final void Function(
    Object error,
    StackTrace stackTrace,
    void Function(Map<String, List<String>>) invalidateFields,
  )?
  onError;

  /// Initial values for form fields, keyed by field name.
  ///
  /// Use this to pre-populate the form when it first loads. The map keys
  /// should match the `name` property of your form fields.
  ///
  /// Example:
  /// ```dart
  /// initialValues: {
  ///   'email': 'user@example.com',
  ///   'remember_me': true,
  /// }
  /// ```
  final Map<String, dynamic> initialValues;

  /// Static values to merge with form data on submission.
  ///
  /// These values are not displayed in the form but are automatically
  /// included when the form is submitted. Useful for:
  /// - Hidden metadata (user IDs, timestamps, etc.)
  /// - Context values from other parts of the app
  /// - Configuration flags
  ///
  /// Example:
  /// ```dart
  /// staticValues: {
  ///   'device_id': deviceInfo.id,
  ///   'app_version': '1.0.0',
  /// }
  /// ```
  final Map<String, dynamic> staticValues;

  /// Whether to use Jet's default error handling system.
  ///
  /// When `true` (default):
  /// - Processes errors through [JetErrorHandler]
  /// - Converts validation errors to field-level errors
  /// - Shows error messages via snackbar (if [showErrorSnackBar] is true)
  /// - Transforms generic errors into [JetError] instances
  ///
  /// When `false`:
  /// - Errors are passed directly to [onError] without processing
  /// - You must handle all error display and field invalidation manually
  ///
  /// Defaults to `true`.
  final bool useDefaultErrorHandler;

  /// Custom text for the default submit button.
  ///
  /// If not provided, uses the localized "Submit" text from Jet's
  /// localization system.
  ///
  /// Only relevant when [showDefaultSubmitButton] is `true`.
  final String? submitButtonText;

  /// Whether to display the default submit button.
  ///
  /// When `true` (default), a [JetButton] is automatically added at the
  /// bottom of the form with proper loading states and tap handling.
  ///
  /// Set to `false` if you want to provide your own custom submit button
  /// or multiple action buttons.
  ///
  /// Defaults to `true`.
  final bool showDefaultSubmitButton;

  /// Whether to show error messages in a snackbar/toast.
  ///
  /// When `true` (default) and [useDefaultErrorHandler] is also true,
  /// error messages from [JetError] will be displayed using the app's
  /// toast notification system.
  ///
  /// Set to `false` if you want to handle error display manually in [onError].
  ///
  /// Defaults to `true`.
  final bool showErrorSnackBar;

  /// Vertical spacing between form fields in logical pixels.
  ///
  /// This spacing is applied between all widgets returned by [builder]
  /// and before the submit button (if shown).
  ///
  /// Defaults to `12.0`.
  final double fieldSpacing;

  /// Creates a [JetFormConsumer] with standard configuration.
  ///
  /// This constructor provides sensible defaults for most form scenarios:
  /// - Error handling enabled
  /// - Submit button displayed
  /// - Error snackbar shown
  ///
  /// Use this for typical forms that follow standard patterns.
  const JetFormConsumer({
    super.key,
    required this.provider,

    required this.builder,
    this.showErrorSnackBar = true,
    this.onSuccess,
    this.onError,
    this.useDefaultErrorHandler = true,
    this.initialValues = const {},
    this.staticValues = const {},
    this.submitButtonText,
    this.showDefaultSubmitButton = true,
    this.fieldSpacing = 12,
  });

  /// Creates a [JetFormConsumer] with advanced configuration options.
  ///
  /// This constructor disables default behaviors, giving you full control over:
  /// - Error handling and display
  /// - Submit button implementation
  /// - Snackbar/toast notifications
  ///
  /// Use this when building complex forms that require custom UI elements or
  /// specialized error handling logic beyond what the default configuration provides.
  ///
  /// ## Configuration Differences from Default
  ///
  /// - [useDefaultErrorHandler] defaults to `false` (you handle errors)
  /// - [showDefaultSubmitButton] defaults to `false` (you provide button)
  /// - [showErrorSnackBar] defaults to `false` (you show error messages)
  ///
  /// ## Example
  ///
  /// ```dart
  /// JetFormConsumer.advanced(
  ///   provider: loginFormProvider,
  ///   builder: (context, ref, form, formState) => [
  ///     JetEmailField(name: 'email'),
  ///     JetPasswordField(name: 'password'),
  ///     // Custom submit button with loading state
  ///     ElevatedButton(
  ///       onPressed: formState.isLoading ? null : () => form.submit(),
  ///       child: formState.isLoading
  ///         ? CircularProgressIndicator()
  ///         : Text('Login'),
  ///     ),
  ///   ],
  ///   onError: (error, stackTrace, invalidateFields) {
  ///     // Custom error dialog or logging
  ///     showDialog(
  ///       context: context,
  ///       builder: (_) => AlertDialog(
  ///         title: Text('Error'),
  ///         content: Text(error.toString()),
  ///       ),
  ///     );
  ///   },
  /// )
  /// ```
  const JetFormConsumer.advanced({
    super.key,
    required this.provider,
    required this.builder,
    this.onSuccess,
    this.onError,
    this.initialValues = const {},
    this.staticValues = const {},
    this.submitButtonText,
    this.fieldSpacing = 12,
    this.showErrorSnackBar = false,
    this.useDefaultErrorHandler = false,
    this.showDefaultSubmitButton = false,
  });

  /// Creates a [JetFormConsumer] optimized for use with Flutter hooks.
  ///
  /// This constructor is functionally identical to the default constructor but
  /// is semantically named to indicate its intended use within [HookConsumerWidget]
  /// or [HookWidget] contexts where the [builder] function can safely use hooks.
  ///
  /// ## When to Use
  ///
  /// Use this constructor when your form fields need to:
  /// - Manage local animations or controllers via hooks
  /// - Use `useState` for transient UI state
  /// - Leverage `useEffect` for side effects
  /// - Utilize other hook-based functionality
  ///
  /// ## Example with Hooks
  ///
  /// ```dart
  /// class LoginForm extends HookConsumerWidget {
  ///   @override
  ///   Widget build(BuildContext context, WidgetRef ref) {
  ///     return JetFormConsumer.hook(
  ///       provider: loginFormProvider,
  ///       builder: (context, ref, form, formState) {
  ///         // Use hooks within the builder
  ///         final passwordVisible = useState(false);
  ///         final animationController = useAnimationController(
  ///           duration: Duration(milliseconds: 300),
  ///         );
  ///
  ///         return [
  ///           JetEmailField(name: 'email'),
  ///           JetPasswordField(
  ///             name: 'password',
  ///             obscureText: !passwordVisible.value,
  ///           ),
  ///           IconButton(
  ///             icon: Icon(passwordVisible.value
  ///               ? Icons.visibility
  ///               : Icons.visibility_off),
  ///             onPressed: () => passwordVisible.value = !passwordVisible.value,
  ///           ),
  ///         ];
  ///       },
  ///     );
  ///   }
  /// }
  /// ```
  ///
  /// See also:
  /// - [HookConsumerWidget], for creating widgets that use both hooks and providers
  /// - [useState], [useEffect], and other hooks from `flutter_hooks`
  const JetFormConsumer.hook({
    super.key,
    required this.provider,
    required this.builder,
    this.showErrorSnackBar = true,
    this.onSuccess,
    this.onError,
    this.useDefaultErrorHandler = true,
    this.initialValues = const {},
    this.staticValues = const {},
    this.submitButtonText,
    this.showDefaultSubmitButton = true,
    this.fieldSpacing = 12,
  });

  /// Internal method that processes form submission errors.
  ///
  /// This method orchestrates error handling by:
  /// 1. Converting raw errors to [JetError] instances
  /// 2. Processing errors through [JetErrorHandler] (if enabled)
  /// 3. Displaying error messages via toast/snackbar (if enabled)
  /// 4. Mapping validation errors to specific form fields
  /// 5. Invoking the custom [onError] callback
  ///
  /// The error handling flow respects [useDefaultErrorHandler] and
  /// [showErrorSnackBar] settings to provide flexible error management.
  void _handleFormError(
    WidgetRef ref,
    BuildContext context,
    FormNotifierBase<Request, Response> form,
    Object error,
    StackTrace stackTrace,
  ) {
    JetError jetError;

    if (useDefaultErrorHandler) {
      if (error is JetError) {
        jetError = error;
      } else {
        // Process raw error with handler
        final jet = ref.read(jetProvider);
        final handler = jet.config.errorHandler;

        jetError = handler.handle(
          error,
          stackTrace: stackTrace,
          showErrorStackTrace: jet.config.showErrorStackTrace,
        );
      }

      // Show error message if available
      if (jetError.message.isNotEmpty && showErrorSnackBar) {
        context.showToast(jetError.message);
      }

      // Handle validation errors by invalidating specific fields
      if (jetError.errors != null && jetError.errors!.isNotEmpty) {
        form.invalidateFormFields(jetError.errors!);
      }
    } else {
      // Use raw error if default handler is disabled
      jetError = error is JetError
          ? error
          : JetError.unknown(
              message: error.toString(),
              rawError: error,
              stackTrace: stackTrace,
            );
    }

    // Call custom error handler if provided
    onError?.call(jetError, stackTrace, form.invalidateFormFields);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the form notifier and watch the current form state
    final form = ref.read((provider as dynamic).notifier);
    final formState = ref.watch(provider);

    // Listen for state changes to trigger callbacks
    // Only trigger callbacks when transitioning to new states
    ref.listen<AsyncFormValue<Request, Response>>(provider, (previous, next) {
      // Ignore if state type hasn't changed (prevents duplicate callbacks)
      if (previous != null && previous.runtimeType == next.runtimeType) {
        // For data state, also check if response actually changed
        if (next is AsyncFormData<Request, Response> &&
            previous is AsyncFormData<Request, Response>) {
          if (identical(next.response, previous.response)) {
            return;
          }
        } else if (next is AsyncFormError<Request, Response> &&
            previous is AsyncFormError<Request, Response>) {
          // For error state, check if it's the same error
          if (identical(next.error, previous.error)) {
            return;
          }
        } else {
          // For loading/idle states, skip if they're the same type
          return;
        }
      }

      next.map(
        idle: (idle) {}, // No action needed for idle state
        data: (data) {
          // Only call onSuccess when transitioning to data state
          onSuccess?.call(data.response, data.request);
        },
        error: (e) {
          // Only handle error when transitioning to error state
          _handleFormError(
            ref,
            context,
            form,
            e.error,
            e.stackTrace,
          );
        },
        loading: (_) {}, // Loading state is handled by UI reactivity
      );
    });

    // Build the form with fields and optional submit button
    return JetForm(
      key: form.formKey,
      // autovalidateMode: AutovalidateMode.always,
      initialValue: initialValues,
      child: Column(
        spacing: fieldSpacing,
        children: [
          // Render user-defined form fields
          ...builder(context, ref, form, formState),
          // Add default submit button if enabled
          if (showDefaultSubmitButton)
            JetButton(
              isExpanded: true,
              text: submitButtonText ?? context.jetI10n.submit,
              onTap: () => form.submit(),
            ),
        ],
      ),
    );
  }
}
