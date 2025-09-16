import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/bootstrap/boot.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:jet/forms/common.dart';
import 'package:jet/forms/notifiers/jet_form_notifier.dart';
import 'package:jet/networking/errors/jet_error.dart';
import 'package:jet/widgets/widgets/buttons/jet_button.dart';

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
  final Map<String, dynamic> staticValues;
  final bool useDefaultErrorHandler;
  final String? submitButtonText;
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
    this.staticValues = const {},
    this.submitButtonText,
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
        jetError = handler.handle(error, context, stackTrace: stackTrace);
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
    // Use dynamic casting to access the notifier
    final form = ref.read((provider as dynamic).notifier);
    final formState = ref.watch(provider);

    ref.listen<AsyncFormValue<Request, Response>>(provider, (previous, next) {
      next.map(
        idle: (idle) {},
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
              isExpanded: true,
              text: submitButtonText ?? context.jetI10n.submit,
              onTap: () => form.submit(context: context),
            ),
        ],
      ),
    );
  }
}
