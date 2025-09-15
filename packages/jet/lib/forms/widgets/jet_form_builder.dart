import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:jet/forms/common.dart';
import 'package:jet/forms/notifiers/jet_form_notifier.dart';
import 'package:jet/forms/mixins/mixins.dart';
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

  // Lifecycle callbacks
  final void Function()? onSubmissionStart;
  final void Function(Response response, Request request)? onSuccess;
  final void Function(JetError error)? onSubmissionError;
  final void Function(JetError error)? onValidationError;

  // Legacy error handler (for backward compatibility)
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
    this.onSubmissionStart,
    this.onSuccess,
    this.onSubmissionError,
    this.onValidationError,
    this.onError, // Legacy support
    this.showErrorSnackBar = true,
    this.useDefaultErrorHandler = true,
    this.initialValues = const {},
    this.staticValues = const {},
    this.submitButtonText,
    this.showDefaultSubmitButton = true,
    this.fieldSpacing = 12,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.read(provider.notifier);
    final formState = ref.watch(provider);

    // Configure lifecycle callbacks in the form notifier
    form.setLifecycleCallbacks(
      FormLifecycleCallbacks<Request, Response>(
        onSubmissionStart: onSubmissionStart,
        onSuccess: onSuccess,
        onSubmissionError: (error) {
          // Handle new callback first
          onSubmissionError?.call(error);

          // Then handle legacy callback and error display
          if (useDefaultErrorHandler && showErrorSnackBar) {
            context.showToast(error.message);
          }

          // Legacy callback support
          onError?.call(error, StackTrace.current, form.invalidateFormFields);
        },
        onValidationError: (error) {
          // Handle new callback first
          onValidationError?.call(error);

          // Then handle legacy callback and error display
          if (useDefaultErrorHandler && showErrorSnackBar) {
            context.showToast(error.message);
          }

          // Legacy callback support
          onError?.call(error, StackTrace.current, form.invalidateFormFields);
        },
      ),
    );

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
              onTap: () => form.submit(),
            ),
        ],
      ),
    );
  }
}
