import 'package:flutter/material.dart';
import 'package:jet/forms/simple/jet_form_controller.dart';
import '../core/jet_form_field.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:jet/widgets/widgets/buttons/jet_button.dart';

/// A simplified form widget that works with [JetFormController] from [useJetForm].
///
/// This widget provides a streamlined way to build forms without the ceremony
/// of [JetFormBuilder]. It's ideal for simple forms with straightforward requirements.
///
/// Example:
/// ```dart
/// class LoginPage extends HookConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final form = useJetForm<LoginRequest, LoginResponse>(
///       decoder: (json) => LoginRequest.fromJson(json),
///       action: (request) => apiService.login(request),
///     );
///
///     return Scaffold(
///       body: JetSimpleForm(
///         controller: form,
///         submitButtonText: 'Login',
///         children: [
///           FormBuilderTextField(
///             name: 'email',
///             decoration: InputDecoration(labelText: 'Email'),
///           ),
///           JetPasswordField(
///             name: 'password',
///             hintText: 'Password',
///           ),
///         ],
///       ),
///     );
///   }
/// }
/// ```
class JetSimpleForm<Request, Response> extends ConsumerWidget {
  /// The form controller from useJetForm hook
  final JetFormController<Request, Response> form;

  /// The form field widgets
  final List<Widget> children;

  /// Text for the submit button
  final String? submitButtonText;

  /// Whether to show the default submit button
  final bool showSubmitButton;

  /// Spacing between form fields
  final double fieldSpacing;

  /// Initial values for the form fields
  final Map<String, dynamic> initialValues;

  /// Callback invoked before form submission
  /// Return false to prevent submission
  final bool Function()? onBeforeSubmit;

  /// Whether the submit button should be expanded (full width)
  final bool expandSubmitButton;

  /// Custom submit button widget
  /// If provided, this will be used instead of the default JetButton
  final Widget? submitButton;

  const JetSimpleForm({
    super.key,
    required this.form,
    required this.children,
    this.submitButtonText,
    this.showSubmitButton = true,
    this.fieldSpacing = 16,
    this.initialValues = const {},
    this.onBeforeSubmit,
    this.expandSubmitButton = true,
    this.submitButton,
  });

  void _handleSubmit() {
    if (onBeforeSubmit != null && !onBeforeSubmit!()) {
      return;
    }
    form.submit();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return JetForm(
      key: form.formKey,
      initialValue: initialValues,
      child: Column(
        // Note: spacing parameter requires Flutter 3.16+
        spacing: fieldSpacing,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...children,
          if (showSubmitButton)
            submitButton ??
                JetButton(
                  text: submitButtonText ?? context.jetI10n.submit,
                  onTap: _handleSubmit,
                  isExpanded: expandSubmitButton,
                ),
        ],
      ),
    );
  }
}
