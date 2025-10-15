import 'package:flutter/material.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:jet/jet_framework.dart';

/// A customizable password field widget with built-in validation and visibility toggle.
///
/// This widget provides:1
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

  /// Label text for the field
  final String? labelText;

  /// Label style for the field
  final TextStyle? labelStyle;

  /// Whether the field should be filled
  final bool filled;

  /// Fill color for the field
  final Color? fillColor;

  /// Border for the field
  final InputBorder? border;

  /// Border when the field is enabled
  final InputBorder? enabledBorder;

  /// Border when the field is focused
  final InputBorder? focusedBorder;

  /// Border when the field has an error
  final InputBorder? errorBorder;

  /// Border when the field is disabled
  final InputBorder? disabledBorder;

  /// Content padding for the field
  final EdgeInsetsGeometry? contentPadding;

  /// Error style for validation messages
  final TextStyle? errorStyle;

  /// Helper text to display below the field
  final String? helperText;

  /// Helper text style
  final TextStyle? helperStyle;

  /// Constraints for the input field
  final BoxConstraints? constraints;

  /// Value transformer for the field
  final ValueTransformer<String?>? valueTransformer;

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
    this.labelText,
    this.labelStyle,
    this.filled = false,
    this.fillColor,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.disabledBorder,
    this.contentPadding,
    this.errorStyle,
    this.helperText,
    this.helperStyle,
    this.constraints,
    this.valueTransformer,
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
      valueTransformer: valueTransformer,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: labelStyle,
        hintText: hintText,
        prefixIcon: showPrefixIcon ? Icon(PhosphorIcons.lock()) : prefixIcon,
        suffixIcon: IconButton(
          icon: Icon(
            obscureTextState.value
                ? PhosphorIcons.eye()
                : PhosphorIcons.eyeClosed(),
          ),
          onPressed: toggleVisibility,
        ),
        filled: filled,
        fillColor: fillColor,
        border: border,
        enabledBorder: enabledBorder,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
        disabledBorder: disabledBorder,
        contentPadding: contentPadding,
        errorStyle: errorStyle,
        helperText: helperText,
        helperStyle: helperStyle,
        constraints: constraints,
      ),
      validator:
          validator ??
          JetValidators.compose([
            if (isRequired) JetValidators.required(),
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
