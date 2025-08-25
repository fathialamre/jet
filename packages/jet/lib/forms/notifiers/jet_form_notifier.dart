import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../bootstrap/boot.dart';
import '../../networking/errors/jet_error.dart';
import '../common.dart';

typedef JetFormProvider<Request, Response> =
    AutoDisposeStateNotifierProvider<
      JetFormNotifier<Request, Response>,
      AsyncFormValue<Request, Response>
    >;

typedef JetForm<Request, Response> = JetFormNotifier<Request, Response>;

abstract class JetFormNotifier<Request, Response>
    extends StateNotifier<AsyncFormValue<Request, Response>> {
  final Ref ref;

  JetFormNotifier(this.ref) : super(const AsyncFormLoading());

  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  Future<void> submit({
    bool showErrorSnackBar = true,
  }) async {
    final formState = formKey.currentState!;
    if (!formState.saveAndValidate()) {
      if (showErrorSnackBar) {
        // Use jet error handler for form validation errors
        final handler = ref.read(jetProvider).config.errorHandler;
        final jetError = handler.handle(
          'Please fix the form errors',
          StackTrace.current,
        );

        state = AsyncFormError(
          jetError,
          StackTrace.current,
        );
      }

      return;
    }

    state = const AsyncFormLoading();

    try {
      final requestData = decoder(formState.value);
      final responseData = await action(requestData);
      state = AsyncFormData(
        request: requestData,
        response: responseData,
      );
    } catch (error, stackTrace) {
      // Use jet error handler to process the error
      final handler = ref.read(jetProvider).config.errorHandler;
      final jetError = handler.handle(error, stackTrace);

      state = AsyncFormError(
        jetError,
        stackTrace,
      );
    }
  }

  Request decoder(Map<String, dynamic> json);

  void invalidateFields(Map<String, List<String>> fieldErrors) {
    fieldErrors.forEach((field, errorText) {
      formKey.currentState?.fields[field]?.invalidate(errorText.first);
    });
  }

  /// Invalidate fields based on JetError validation errors
  void invalidateFieldsFromJetError(Object error) {
    if (error is JetError && error.isValidation && error.errors != null) {
      invalidateFields(error.errors!);
    }
  }

  void reset() {
    formKey.currentState?.reset();
    state = const AsyncFormLoading();
  }

  Future<Response> action(Request data);
}
