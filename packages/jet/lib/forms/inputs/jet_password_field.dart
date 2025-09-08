import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:jet/jet_framework.dart';

/// A customizable password field widget with built-in validation and visibility toggle.
///
/// This widget provides:
/// - Password visibility toggle
/// - Password confirmation validation
/// - Customizable validation rules
/// - Integrated with Flutter Form Builder
///
/// Example usage:
/// ```dart
/// JetPasswordField(
///   name: 'password',
///   hintText: 'Enter your password',
///   identicalWith: 'confirmPassword', // For password confirmation
///   formKey: formKey,
/// )
/// ```
class JetPasswordField extends HookWidget {
  /// The name identifier for this form field
  final String name;

  /// Initial value for the password field
  final String? initialValue;

  /// Custom validator function
  final FormFieldValidator<String>? validator;

  /// Custom prefix icon widget
  final Widget? prefixIcon;

  /// Whether to show the default lock icon
  final bool showPrefixIcon;

  /// Whether this field is required
  final bool isRequired;

  /// Form key reference for password confirmation validation
  final GlobalKey<FormBuilderState>? formKey;

  /// Field name to match for password confirmation
  final String? identicalWith;

  /// Hint text to display when field is empty
  final String hintText;

  /// Whether to initially obscure the password text
  final bool obscureText;

  /// Keyboard type for this field
  final TextInputType? keyboardType;

  /// Whether the field is read-only
  final bool readOnly;

  /// Whether to autofocus this field
  final bool autofocus;

  /// Whether the field is enabled
  final bool enabled;

  const JetPasswordField({
    super.key,
    required this.name,
    this.initialValue,
    this.validator,
    this.prefixIcon,
    this.showPrefixIcon = true,
    this.isRequired = true,
    this.formKey,
    this.identicalWith,
    this.hintText = '',
    this.obscureText = true,
    this.keyboardType,
    this.readOnly = false,
    this.autofocus = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final obscureTextState = useState(true);

    void toggleVisibility() {
      obscureTextState.value = !obscureTextState.value;
    }

    return FormBuilderTextField(
      name: name,
      initialValue: initialValue,
      obscureText: obscureTextState.value,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: showPrefixIcon ? const Icon(LucideIcons.lock) : prefixIcon,
        hintText: hintText,
        suffixIcon: IconButton(
          icon: Icon(
            obscureTextState.value ? LucideIcons.eye : LucideIcons.eyeClosed,
          ),
          onPressed: toggleVisibility,
        ),
      ),
      validator:
          validator ??
          FormBuilderValidators.compose([
            if (isRequired) FormBuilderValidators.required(),
            (value) {
              if (identicalWith != null) {
                if (formKey == null) {
                  throw FlutterError(
                    'formKey is required when using identicalWith for field: $name',
                  );
                }
                final otherFieldValue =
                    formKey?.currentState?.fields[identicalWith]?.value;
                if (value != otherFieldValue) {
                  return context.jetI10n.passwordNotIdentical;
                }
              }
              return null;
            },
          ]),
    );
  }
}
