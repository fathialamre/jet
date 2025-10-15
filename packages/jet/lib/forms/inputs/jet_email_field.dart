import 'package:flutter/material.dart';
import 'package:jet/forms/core/jet_form_field.dart';
import 'package:jet/forms/core/value_transformer.dart';
import 'package:jet/forms/validators/jet_validators.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// A customizable email field widget with built-in validation.
///
/// This widget provides:
/// - Email-specific keyboard
/// - Built-in email validation with regex
/// - Customizable validation rules
/// - Optional prefix icon (envelope)
///
/// Example usage:
/// ```dart
/// JetEmailField(
///   name: 'email',
///   hintText: 'Enter your email',
///   labelText: 'Email Address',
/// )
/// ```
class JetEmailField extends StatelessWidget {
  /// The name identifier for this form field
  final String name;

  /// Initial value for the email field
  final String? initialValue;

  /// Custom validator function
  final FormFieldValidator<String>? validator;

  /// Custom prefix icon widget
  final Widget? prefixIcon;

  /// Whether to show the default email icon
  final bool showPrefixIcon;

  /// Whether this field is required
  final bool isRequired;

  /// Hint text to display when field is empty
  final String hintText;

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

  /// Whether to convert email to lowercase automatically
  final bool toLowerCase;

  /// Focus node for this field
  final FocusNode? focusNode;

  /// Auto-validate mode
  final AutovalidateMode? autovalidateMode;

  const JetEmailField({
    super.key,
    required this.name,
    this.initialValue,
    this.validator,
    this.showPrefixIcon = true,
    this.prefixIcon,
    this.autofocus = false,
    this.isRequired = true,
    this.hintText = '',
    this.enabled = true,
    this.labelText,
    this.labelStyle,
    this.filled = true,
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
    this.toLowerCase = true,
    this.focusNode,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return JetFormField<String>(
      name: name,
      initialValue: initialValue,
      enabled: enabled,
      autovalidateMode: autovalidateMode,
      focusNode: focusNode,
      valueTransformer: toLowerCase
          ? (value) => value?.trim().toLowerCase()
          : (value) => value?.trim(),
      validator:
          validator ??
          JetValidators.compose([
            if (isRequired) JetValidators.required(),
            JetValidators.email(),
          ]),
      builder: (FormFieldState<String> field) {
        final state = field as JetFormFieldState<JetFormField<String>, String>;
        return TextField(
          controller: TextEditingController(text: field.value ?? '')
            ..selection = TextSelection.collapsed(
              offset: (field.value ?? '').length,
            ),
          focusNode: state.effectiveFocusNode,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autofocus: autofocus,
          enabled: enabled && state.enabled,
          onChanged: field.didChange,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: labelStyle,
            hintText: hintText,
            prefixIcon: showPrefixIcon
                ? prefixIcon ?? Icon(PhosphorIcons.envelope())
                : null,
            filled: filled,
            fillColor: fillColor,
            border: border,
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            errorBorder: errorBorder,
            disabledBorder: disabledBorder,
            contentPadding: contentPadding,
            errorText: field.errorText,
            errorStyle: errorStyle,
            helperText: helperText,
            helperStyle: helperStyle,
            constraints: constraints,
          ),
        );
      },
    );
  }
}
