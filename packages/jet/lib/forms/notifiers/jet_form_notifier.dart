import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../common.dart';
import '../mixins/mixins.dart';

typedef JetFormProvider<Request, Response> =
    Provider<AsyncFormValue<Request, Response>>;

typedef JetForm<Request, Response> = JetFormNotifier<Request, Response>;

abstract class JetFormNotifier<Request, Response>
    extends Notifier<AsyncFormValue<Request, Response>>
    with
        FormValidationMixin,
        FormErrorHandlingMixin,
        FormLifecycleMixin<Request, Response> {
  @override
  AsyncFormValue<Request, Response> build();

  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

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

      triggerValidationError(validationError);
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

      state = AsyncFormValue.data(
        request: requestData,
        response: responseData,
      );

      triggerSuccess(responseData, requestData);
    } catch (error, stackTrace) {
      // Convert error to JetError
      final jetError = convertToJetError(error, stackTrace);

      state = AsyncFormValue.error(
        jetError,
        stackTrace,
        request: state.request,
        response: state.response,
      );

      triggerSubmissionError(jetError);
    }
  }

  Request decoder(Map<String, dynamic> json);

  void invalidateFormFields(Map<String, List<String>> fieldErrors) {
    super.invalidateFields(fieldErrors, formKey);
  }

  /// Invalidate fields based on JetError validation errors
  void invalidateFieldsFromError(Object error) {
    super.invalidateFieldsFromJetError(error, formKey);
  }

  void reset() {
    formKey.currentState?.reset();
    state = const AsyncFormValue.idle();
  }

  /// Validate a specific field
  void validateSingleField(String fieldName) {
    super.validateSpecificField(fieldName, formKey);
  }

  /// Validate all fields without submitting
  bool validateForm() {
    return super.validateAllFields(formKey);
  }

  Future<Response> action(Request data);
}
