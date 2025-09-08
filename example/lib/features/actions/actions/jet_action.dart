import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jet/extensions/text_extensions.dart';
import 'package:jet/jet_framework.dart';

/// An optimized action widget that supports both simple actions and complex form-based actions
/// using the powerful Jet Forms system.
///
/// ## Named Constructors for Different Use Cases:
///
/// ### Simple Action
/// ```dart
/// JetAction.action(
///   text: 'Save Data',
///   icon: Icons.save,
///   onTap: () => saveData(),
/// )
/// ```
///
/// ### Confirmation Action
/// ```dart
/// JetAction.confirmation(
///   text: 'Delete Item',
///   icon: Icons.delete,
///   confirmationTitle: 'Delete Confirmation',
///   onTap: () => deleteItem(),
/// )
/// ```
///
/// ### Legacy Form Action
/// ```dart
/// JetAction.form(
///   text: 'Edit Profile',
///   formTitle: 'Edit Your Profile',
///   formBuilder: Column(
///     children: [
///       TextFormField(decoration: InputDecoration(labelText: 'Name')),
///       ElevatedButton(onPressed: () => save(), child: Text('Save')),
///     ],
///   ),
/// )
/// ```
///
/// ### Optimized JetForm Action
/// ```dart
/// JetAction.jetForm<CommentRequest, CommentResponse>(
///   text: 'Add Comment',
///   formProvider: commentFormProvider,
///   formTitle: 'Create New Comment',
///   jetFormBuilder: (context, ref, form, state) => [
///     JetTextField(name: 'title'),
///     JetPasswordField(name: 'description'),
///   ],
///   onFormSuccess: (response, request) {
///     // Handle successful form submission
///   },
/// )
/// ```
class JetAction<TRequest, TResponse> extends HookConsumerWidget {
  const JetAction._({
    super.key,
    // Basic action parameters
    required this.text,
    this.onTap,
    this.confirmationRequired = false,
    this.confirmationTitle,
    this.confirmationMessage,
    this.confirmationType = ConfirmationSheetType.info,
    this.icon,
    this.buttonType = JetButtonType.filled,
    this.isExpanded = false,
    this.isEnabled = true,

    // Form parameters (original pattern - for backward compatibility)
    this.formBuilder,
    this.formTitle,
    this.showDragHandle,
    this.formPadding,

    // Advanced form parameters (new optimized pattern)
    this.formProvider,
    this.jetFormBuilder,
    this.initialFormValues,
    this.onFormSuccess,
    this.onFormError,
    this.showFormErrorSnackBar = true,
    this.formSubmitButtonText,
    this.showFormSubmitButton = true,
    this.formFieldSpacing = 12,
  });

  /// Creates a simple action button without forms or confirmations
  ///
  /// Example:
  /// ```dart
  /// JetAction.action(
  ///   text: 'Save Data',
  ///   icon: Icons.save,
  ///   onTap: () => saveData(),
  /// )
  /// ```
  factory JetAction.action({
    Key? key,
    required String text,
    required FutureOr<void> Function() onTap,
    IconData? icon,
    JetButtonType buttonType = JetButtonType.filled,
    bool isExpanded = false,
    bool isEnabled = true,
  }) {
    return JetAction._(
      key: key,
      text: text,
      onTap: onTap,
      icon: icon,
      buttonType: buttonType,
      isExpanded: isExpanded,
      isEnabled: isEnabled,
    );
  }

  /// Creates an action button that requires user confirmation
  ///
  /// Example:
  /// ```dart
  /// JetAction.confirmation(
  ///   text: 'Delete Item',
  ///   icon: Icons.delete,
  ///   confirmationType: JetActionConfirmationType.error,
  ///   confirmationTitle: 'Delete Confirmation',
  ///   confirmationMessage: 'Are you sure you want to delete this item?',
  ///   onTap: () => deleteItem(),
  /// )
  /// ```
  factory JetAction.confirmation({
    Key? key,
    required String text,
    required FutureOr<void> Function() onTap,
    IconData? icon,
    JetButtonType buttonType = JetButtonType.filled,
    bool isExpanded = false,
    bool isEnabled = true,
    String? confirmationTitle,
    String? confirmationMessage,
    ConfirmationSheetType confirmationType = ConfirmationSheetType.info,
  }) {
    return JetAction._(
      key: key,
      text: text,
      onTap: onTap,
      icon: icon,
      buttonType: buttonType,
      isExpanded: isExpanded,
      isEnabled: isEnabled,
      confirmationRequired: true,
      confirmationTitle: confirmationTitle,
      confirmationMessage: confirmationMessage,
      confirmationType: confirmationType,
    );
  }

  /// Creates an action button with a legacy form (backward compatibility)
  ///
  /// Example:
  /// ```dart
  /// JetAction.form(
  ///   text: 'Edit Profile',
  ///   icon: Icons.edit,
  ///   formTitle: 'Edit Your Profile',
  ///   formBuilder: Column(
  ///     children: [
  ///       TextFormField(decoration: InputDecoration(labelText: 'Name')),
  ///       ElevatedButton(onPressed: () => save(), child: Text('Save')),
  ///     ],
  ///   ),
  /// )
  /// ```
  factory JetAction.form({
    Key? key,
    required String text,
    required Widget formBuilder,
    IconData? icon,
    JetButtonType buttonType = JetButtonType.filled,
    bool isExpanded = false,
    bool isEnabled = true,
    String? formTitle,
    bool? showDragHandle,
    EdgeInsets? formPadding,
  }) {
    return JetAction._(
      key: key,
      text: text,
      icon: icon,
      buttonType: buttonType,
      isExpanded: isExpanded,
      isEnabled: isEnabled,
      formBuilder: formBuilder,
      formTitle: formTitle,
      showDragHandle: showDragHandle,
      formPadding: formPadding,
    );
  }

  /// Creates an action button with optimized JetForm integration
  ///
  /// Example:
  /// ```dart
  /// JetAction.jetForm<CommentRequest, CommentResponse>(
  ///   text: 'Add Comment',
  ///   icon: Icons.comment,
  ///   formProvider: commentFormProvider,
  ///   formTitle: 'Create New Comment',
  ///   jetFormBuilder: (context, ref, form, state) => [
  ///     JetTextField(name: 'title'),
  ///     JetPasswordField(name: 'description'),
  ///   ],
  ///   onFormSuccess: (response, request) {
  ///     // Handle success
  ///   },
  /// )
  /// ```
  factory JetAction.jetForm({
    Key? key,
    required String text,
    required JetFormProvider<TRequest, TResponse> formProvider,
    required List<Widget> Function(
      BuildContext context,
      WidgetRef ref,
      JetForm<TRequest, TResponse> form,
      AsyncFormValue<TRequest, TResponse> formState,
    )
    jetFormBuilder,
    IconData? icon,
    JetButtonType buttonType = JetButtonType.filled,
    bool isExpanded = false,
    bool isEnabled = true,
    String? formTitle,
    bool? showDragHandle,
    Map<String, dynamic>? initialFormValues,
    void Function(TResponse response, TRequest request)? onFormSuccess,
    void Function(
      Object error,
      StackTrace stackTrace,
      void Function(Map<String, List<String>>) invalidateFields,
    )?
    onFormError,
    bool showFormErrorSnackBar = true,
    String? formSubmitButtonText,
    bool showFormSubmitButton = true,
    double formFieldSpacing = 12,
  }) {
    return JetAction._(
      key: key,
      text: text,
      icon: icon,
      buttonType: buttonType,
      isExpanded: isExpanded,
      isEnabled: isEnabled,
      formTitle: formTitle,
      showDragHandle: showDragHandle,
      formProvider: formProvider,
      jetFormBuilder: jetFormBuilder,
      initialFormValues: initialFormValues,
      onFormSuccess: onFormSuccess,
      onFormError: onFormError,
      showFormErrorSnackBar: showFormErrorSnackBar,
      formSubmitButtonText: formSubmitButtonText,
      showFormSubmitButton: showFormSubmitButton,
      formFieldSpacing: formFieldSpacing,
    );
  }

  // Basic action parameters
  final String text;
  final FutureOr<void> Function()? onTap;
  final bool confirmationRequired;
  final String? confirmationTitle;
  final String? confirmationMessage;
  final ConfirmationSheetType confirmationType;
  final IconData? icon;
  final JetButtonType buttonType;
  final bool isExpanded;
  final bool isEnabled;

  // Form parameters (original pattern)
  final Widget? formBuilder;
  final String? formTitle;
  final bool? showDragHandle;
  final EdgeInsets? formPadding;

  // Advanced form parameters (new pattern)
  final JetFormProvider<TRequest, TResponse>? formProvider;
  final List<Widget> Function(
    BuildContext context,
    WidgetRef ref,
    JetForm<TRequest, TResponse> form,
    AsyncFormValue<TRequest, TResponse> formState,
  )?
  jetFormBuilder;
  final Map<String, dynamic>? initialFormValues;
  final void Function(TResponse response, TRequest request)? onFormSuccess;
  final void Function(
    Object error,
    StackTrace stackTrace,
    void Function(Map<String, List<String>>) invalidateFields,
  )?
  onFormError;
  final bool showFormErrorSnackBar;
  final String? formSubmitButtonText;
  final bool showFormSubmitButton;
  final double formFieldSpacing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Determine if we're using the new form system
    final bool useJetForms = formProvider != null && jetFormBuilder != null;

    return JetButton(
      type: buttonType,
      text: text,
      icon: icon,
      isExpanded: isExpanded,
      isEnabled: isEnabled,
      onTap: () => _handleAction(context, ref, useJetForms),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    WidgetRef ref,
    bool useJetForms,
  ) async {
    if (confirmationRequired) {
      _showConfirmationSheet(
        context: context,
        title: confirmationTitle ?? 'Confirmation',
        message:
            confirmationMessage ??
            'Are you sure you want to perform this action?',
        type: confirmationType,
        onConfirm: () => _executeAction(context, ref, useJetForms),
      );
    } else {
      await _executeAction(context, ref, useJetForms);
    }
  }

  void _showConfirmationSheet({
    required BuildContext context,
    required String title,
    required String message,
    required ConfirmationSheetType type,
    required VoidCallback onConfirm,
  }) {
    // Get colors based on confirmation type

    showConfirmationSheet(
      context: context,
      title: title,
      message: message,
      onConfirm: onConfirm,
      type: type,
    );
  }

  Future<void> _executeAction(
    BuildContext context,
    WidgetRef ref,
    bool useJetForms,
  ) async {
    if (useJetForms) {
      // Use the new optimized form system
      _showJetFormModal(context, ref);
    } else if (formBuilder != null) {
      // Use the original form builder pattern for backward compatibility
      _showLegacyFormModal(context);
    } else {
      // Simple action without form
      await onTap?.call();
    }
  }

  void _showJetFormModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _DynamicBottomSheet(
        showDragHandle: showDragHandle ?? true,
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: showDragHandle ?? true ? 8 : 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              if (showDragHandle ?? true) ...[
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Form title
              if (formTitle != null) ...[
                Text(formTitle!).titleLarge(context).bold(),
                const SizedBox(height: 20),
              ],

              // JetFormBuilder with optimized form handling
              JetFormBuilder<TRequest, TResponse>(
                provider: formProvider!,
                initialValues: initialFormValues ?? {},
                showErrorSnackBar: showFormErrorSnackBar,
                submitButtonText: formSubmitButtonText,
                showDefaultSubmitButton: showFormSubmitButton,
                fieldSpacing: formFieldSpacing,
                builder: jetFormBuilder!,
                onSuccess: (response, request) {
                  Navigator.of(context).pop(); // Close the modal
                  onFormSuccess?.call(response, request);
                },
                onError: onFormError,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLegacyFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _DynamicBottomSheet(
        showDragHandle: showDragHandle ?? true,
        child: Padding(
          padding: EdgeInsets.only(
            left: (formPadding?.left ?? 20),
            right: (formPadding?.right ?? 20),
            top: showDragHandle ?? true ? 8 : (formPadding?.top ?? 20),
            bottom:
                MediaQuery.of(context).viewInsets.bottom +
                (formPadding?.bottom ?? 20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              if (showDragHandle ?? true) ...[
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (formTitle != null) ...[
                Text(formTitle!).titleLarge(context).bold(),
                const SizedBox(height: 20),
              ],

              formBuilder!,
            ],
          ),
        ),
      ),
    );
  }
}

/// A dynamic bottom sheet that adjusts its height based on content
class _DynamicBottomSheet extends StatelessWidget {
  final Widget child;
  final bool showDragHandle;

  const _DynamicBottomSheet({
    required this.child,
    this.showDragHandle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
        minHeight: 0,
      ),
      child: IntrinsicHeight(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            child,
            // Add some bottom padding for safe area
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
