import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// Jet framework wrapper for FormBuilder.
///
/// This widget wraps flutter_form_builder's FormBuilder to provide
/// a consistent Jet API without requiring users to import external packages.
///
/// Example usage:
/// ```dart
/// final formKey = GlobalKey<FormBuilderState>();
///
/// JetFormWidget(
///   key: formKey,
///   child: Column(
///     children: [
///       JetEmailField(name: 'email'),
///       JetPasswordField(name: 'password'),
///     ],
///   ),
/// )
/// ```
class JetFormWidget extends StatelessWidget {
  /// Creates a Jet form widget.
  const JetFormWidget({
    super.key,
    required this.child,
    this.onChanged,
    this.autovalidateMode,
    this.initialValue = const {},
    this.skipDisabled = false,
    this.enabled = true,
    this.clearValueOnUnregister = false,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// Called whenever any form field value changes.
  final VoidCallback? onChanged;

  /// Used to enable/disable form fields auto validation and update their error
  /// text when the user interacts with the form.
  final AutovalidateMode? autovalidateMode;

  /// An optional map of field names to initial values.
  /// Initial values will be set on the form fields when the form is first built.
  final Map<String, dynamic> initialValue;

  /// Whether to skip disabled fields when collecting form values.
  final bool skipDisabled;

  /// Whether the form fields are enabled.
  final bool enabled;

  /// Whether to clear the value of a field when it is unregistered.
  final bool clearValueOnUnregister;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: key as GlobalKey<FormBuilderState>?,
      onChanged: onChanged,
      autovalidateMode: autovalidateMode,
      initialValue: initialValue,
      skipDisabled: skipDisabled,
      enabled: enabled,
      clearValueOnUnregister: clearValueOnUnregister,
      child: child,
    );
  }

  /// Get the FormBuilderState from the closest JetFormWidget ancestor.
  static FormBuilderState? of(BuildContext context) {
    return FormBuilder.of(context);
  }
}

/// Type alias for form key.
typedef JetFormKey = GlobalKey<FormBuilderState>;

/// Type alias for form field validator.
typedef JetFieldValidator<T> = FormFieldValidator<T>;
