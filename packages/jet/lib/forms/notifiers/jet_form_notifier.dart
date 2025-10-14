import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../networking/errors/jet_error.dart';
import '../common.dart';
import '../mixins/mixins.dart';

typedef JetFormProvider<Request, Response> =
    Provider<AsyncFormValue<Request, Response>>;

typedef JetForm<Request, Response> = JetFormNotifier<Request, Response>;

/// Base interface for form notifiers that provides access to state
abstract class FormNotifierBase<Request, Response> {
  AsyncFormValue<Request, Response> get state;
  set state(AsyncFormValue<Request, Response> value);
}

/// Mixin version of JetFormNotifier for use with Riverpod's @riverpod annotation
///
/// Use this mixin when you need to work with Riverpod's code generation:
/// ```dart
/// @riverpod
/// class MyForm extends _$MyForm with JetFormMixin<Request, Response> {
///   // implementation
/// }
/// ```
mixin JetFormMixin<Request, Response>
    implements
        FormNotifierBase<Request, Response>,
        FormValidationMixin,
        FormErrorHandlingMixin,
        FormLifecycleMixin<Request, Response> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  // FormLifecycleMixin implementation
  FormLifecycleCallbacks<Request, Response>? _callbacks;

  @override
  void setLifecycleCallbacks(
    FormLifecycleCallbacks<Request, Response>? callbacks,
  ) {
    _callbacks = callbacks;
  }

  @override
  void triggerSubmissionStart() {
    _callbacks?.onSubmissionStart?.call();
  }

  @override
  void triggerSuccess(Response response, Request request) {
    _callbacks?.onSuccess?.call(response, request);
  }

  @override
  void triggerSubmissionError(Object error, StackTrace stackTrace) {
    _callbacks?.onSubmissionError?.call(error, stackTrace);
  }

  @override
  void triggerValidationError(Object error, StackTrace stackTrace) {
    _callbacks?.onValidationError?.call(error, stackTrace);
  }

  // FormValidationMixin implementation
  @override
  bool get validateOnChange => false;

  @override
  bool get validateOnFocusLoss => false;

  @override
  bool get autoValidate => false;

  @override
  List<String> validateField(String fieldName, dynamic value) {
    return [];
  }

  @override
  void validateSpecificField(
    String fieldName,
    GlobalKey<FormBuilderState> formKey,
  ) {
    final formState = formKey.currentState;
    if (formState == null) return;

    final field = formState.fields[fieldName];
    if (field == null) return;

    final errors = validateField(fieldName, field.value);
    if (errors.isNotEmpty) {
      field.invalidate(errors.first);
    } else {
      field.validate();
    }
  }

  @override
  bool validateAllFields(GlobalKey<FormBuilderState> formKey) {
    final formState = formKey.currentState;
    if (formState == null) return false;

    bool isValid = true;
    for (final entry in formState.fields.entries) {
      final fieldName = entry.key;
      final field = entry.value;

      final errors = validateField(fieldName, field.value);
      if (errors.isNotEmpty) {
        field.invalidate(errors.first);
        isValid = false;
      }
    }

    return isValid && formState.saveAndValidate();
  }

  @override
  Map<String, List<String>> extractFormErrors(FormBuilderState? formState) {
    if (formState == null) return {};

    final errors = <String, List<String>>{};
    formState.fields.forEach((fieldName, field) {
      if (field.hasError && field.errorText != null) {
        errors[fieldName] = [field.errorText!];
      }
    });
    return errors;
  }

  @override
  void invalidateFields(
    Map<String, List<String>> fieldErrors,
    GlobalKey<FormBuilderState> formKey,
  ) {
    fieldErrors.forEach((field, errorText) {
      formKey.currentState?.fields[field]?.invalidate(errorText.first);
    });
  }

  // FormErrorHandlingMixin implementation
  @override
  JetError convertToJetError(Object error, StackTrace stackTrace) {
    if (error is JetError) {
      return error;
    }

    return JetError.unknown(
      message: error.toString(),
      rawError: error,
      stackTrace: stackTrace,
    );
  }

  @override
  JetError createValidationError(Map<String, List<String>> formErrors) {
    return JetError.validation(
      message: 'Please fix the form errors',
      errors: formErrors,
    );
  }

  // Form submission and management methods
  Future<void> submit() async {
    final formState = formKey.currentState;
    if (formState == null || !formState.saveAndValidate()) {
      // Extract form validation errors
      final formErrors = extractFormErrors(formState);
      final validationError = createValidationError(formErrors);

      state = AsyncFormValue.error(
        validationError,
        StackTrace.current,
        request: state.request,
        response: state.response,
      );

      triggerValidationError(validationError, StackTrace.current);
      return;
    }

    // Notify submission start
    triggerSubmissionStart();

    // Preserve current data while loading
    state = AsyncFormValue.loading(
      request: state.request,
      response: state.response,
    );

    try {
      final requestData = decoder(formState.value);
      final responseData = await action(requestData);

      state = AsyncFormValue.data(request: requestData, response: responseData);

      triggerSuccess(responseData, requestData);
    } catch (error, stackTrace) {
      state = AsyncFormValue.error(error, stackTrace);
      triggerSubmissionError(error, stackTrace);
    }
  }

  Request decoder(Map<String, dynamic> json);

  void invalidateFormFields(Map<String, List<String>> fieldErrors) {
    invalidateFields(fieldErrors, formKey);
  }

  void reset() {
    formKey.currentState?.reset();
    state = const AsyncFormValue.idle();
  }

  /// Validate a specific field
  void validateSingleField(String fieldName) {
    validateSpecificField(fieldName, formKey);
  }

  /// Validate all fields without submitting
  bool validateForm() {
    return validateAllFields(formKey);
  }

  Future<Response> action(Request data);
}

/// Traditional class-based JetFormNotifier for backward compatibility
///
/// Use this when you're not using Riverpod's @riverpod annotation:
/// ```dart
/// class MyForm extends JetFormNotifier<Request, Response> {
///   @override
///   AsyncFormValue<Request, Response> build() {
///     return const AsyncFormIdle();
///   }
///   // implementation
/// }
/// ```
abstract class JetFormNotifier<Request, Response>
    extends Notifier<AsyncFormValue<Request, Response>>
    with JetFormMixin<Request, Response> {
  @override
  AsyncFormValue<Request, Response> build();
}
