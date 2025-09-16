import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:jet/extensions/build_context.dart';
import '../../bootstrap/boot.dart';
import '../../networking/errors/jet_error.dart';
import '../common.dart';

typedef JetFormProvider<Request, Response> =
    ProviderListenable<AsyncFormValue<Request, Response>>;

typedef JetForm<Request, Response> = JetFormNotifier<Request, Response>;

abstract class JetFormNotifier<Request, Response>
    extends Notifier<AsyncFormValue<Request, Response>> {
  @override
  AsyncFormValue<Request, Response> build();

  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  Future<void> submit({
    bool showErrorSnackBar = true,
    required BuildContext context,
  }) async {
    final formState = formKey.currentState!;
    if (!formState.saveAndValidate()) {
      if (showErrorSnackBar) {
        // Use jet error handler for form validation errors
        final handler = ref.read(jetProvider).config.errorHandler;
        final jetError = handler.handle(
          context.jetI10n.pleaseFixTheFormErrors,
          context,
          stackTrace: StackTrace.current,
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
      if (context.mounted) {
        final jetError = handler.handle(error, context, stackTrace: stackTrace);

        state = AsyncFormError(
          jetError,
          stackTrace,
        );
      }
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
