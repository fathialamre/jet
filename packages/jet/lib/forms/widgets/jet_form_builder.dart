import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/bootstrap/boot.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:jet/helpers/jet_logger.dart';
import 'package:jet/widgets/widgets/buttons/jet_button.dart';

import '../../networking/errors/jet_error.dart';
import '../common.dart';
import '../notifiers/jet_form_notifier.dart';

class JetFormBuilder<Request, Response> extends ConsumerWidget {
  final JetFormProvider<Request, Response> provider;
  final List<Widget> Function(
    BuildContext context,
    WidgetRef ref,
    JetForm<Request, Response> form,
    AsyncFormValue<Request, Response> formState,
  )
  builder;
  final void Function(Response responseData, Request requestData)? onSuccess;
  final void Function(
    Object error,
    StackTrace stackTrace,
    void Function(Map<String, List<String>>) invalidateFields,
  )?
  onError;
  final Map<String, dynamic> initialValues;
  final bool useDefaultErrorHandler;
  final String submitButtonText;
  final bool showDefaultSubmitButton;
  final bool showErrorSnackBar;
  final double fieldSpacing;

  const JetFormBuilder({
    super.key,
    required this.provider,
    required this.builder,
    this.showErrorSnackBar = true,
    this.onSuccess,
    this.onError,
    this.useDefaultErrorHandler = true,
    this.initialValues = const {},
    this.submitButtonText = 'Submit',
    this.showDefaultSubmitButton = true,
    this.fieldSpacing = 12,
  });

  void _handleFormError(
    WidgetRef ref,
    BuildContext context,
    JetForm<Request, Response> form,
    Object error,
    StackTrace stackTrace,
  ) {
    JetError jetError;

    if (useDefaultErrorHandler) {
      if (error is JetError) {
        // Error is already processed by JetFormNotifier
        jetError = error;
      } else {
        // Process raw error with handler
        final handler = ref.read(jetProvider).config.errorHandler;
        jetError = handler.handle(error, stackTrace);
      }

      // Show error message if available
      if (jetError.message.isNotEmpty && showErrorSnackBar) {
        context.showToast(jetError.message);
      }

      // Handle validation errors by invalidating specific fields
      if (jetError.errors != null && jetError.errors!.isNotEmpty) {
        form.invalidateFields(jetError.errors!);
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
    onError?.call(jetError, stackTrace, form.invalidateFields);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.read(provider.notifier);
    final formState = ref.watch(provider);

    ref.listen<AsyncFormValue<Request, Response>>(provider, (previous, next) {
      next.map(
        data: (data) => onSuccess?.call(data.response, data.request),
        error: (e) => _handleFormError(
          ref,
          context,
          form,
          e.error,
          e.stackTrace,
        ),
        loading: (_) {},
      );
    });

    return FormBuilder(
      key: form.formKey,
      initialValue: initialValues,
      child: Column(
        spacing: fieldSpacing,
        children: [
          ...builder(context, ref, form, formState),
          if (showDefaultSubmitButton)
            JetButton(
              text: submitButtonText,
              onTap: form.submit,
            ),
        ],
      ),
    );
  }
}
