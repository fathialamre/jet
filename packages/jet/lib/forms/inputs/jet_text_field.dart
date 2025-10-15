import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jet/forms/core/jet_form_field.dart';
import 'package:jet/forms/core/value_transformer.dart';
import 'package:jet/forms/validators/jet_validators.dart';

/// A customizable text field widget with built-in validation.
///
/// This is the most basic and commonly used form field in the Jet framework.
/// It provides a simple text input with comprehensive customization options.
///
/// Example usage:
/// ```dart
/// JetTextField(
///   name: 'username',
///   labelText: 'Username',
///   hintText: 'Enter your username',
/// )
/// ```
class JetTextField extends StatelessWidget {
  /// The name identifier for this form field
  final String name;

  /// Initial value for the text field
  final String? initialValue;

  /// Custom validator function
  final FormFieldValidator<String>? validator;

  /// Custom prefix icon widget
  final Widget? prefixIcon;

  /// Custom suffix icon widget
  final Widget? suffixIcon;

  /// Whether to show the default prefix icon
  final bool showPrefixIcon;

  /// Whether this field is required
  final bool isRequired;

  /// Hint text to display when field is empty
  final String hintText;

  /// Whether to autofocus this field
  final bool autofocus;

  /// Whether the field is enabled
  final bool enabled;

  /// Whether the field is read-only
  final bool readOnly;

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

  /// Keyboard type for this field
  final TextInputType? keyboardType;

  /// Text input action
  final TextInputAction? textInputAction;

  /// Text capitalization
  final TextCapitalization textCapitalization;

  /// Maximum length of input
  final int? maxLength;

  /// Maximum number of lines (null for single line)
  final int? maxLines;

  /// Minimum number of lines
  final int? minLines;

  /// Whether to obscure the text (for passwords)
  final bool obscureText;

  /// Input formatters for the field
  final List<TextInputFormatter>? inputFormatters;

  /// Callback when value changes
  final ValueChanged<String?>? onChanged;

  /// Value transformer to transform the value before saving
  final ValueTransformer<String?>? valueTransformer;

  /// Callback when field is submitted
  final ValueChanged<String?>? onSubmitted;

  /// Whether to autocorrect text
  final bool autocorrect;

  /// Whether to enable suggestions
  final bool enableSuggestions;

  /// Style for the input text
  final TextStyle? style;

  /// Minimum length validation
  final int? minLength;

  /// Whether to trim whitespace
  final bool trimWhitespace;

  /// Focus node for this field
  final FocusNode? focusNode;

  /// Auto-validate mode
  final AutovalidateMode? autovalidateMode;

  const JetTextField({
    super.key,
    required this.name,
    this.initialValue,
    this.validator,
    this.showPrefixIcon = false,
    this.prefixIcon,
    this.suffixIcon,
    this.autofocus = false,
    this.isRequired = false,
    this.hintText = '',
    this.enabled = true,
    this.readOnly = false,
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
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.obscureText = false,
    this.inputFormatters,
    this.onChanged,
    this.valueTransformer,
    this.onSubmitted,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.style,
    this.minLength,
    this.trimWhitespace = true,
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
      valueTransformer:
          valueTransformer ??
          (trimWhitespace ? (value) => value?.trim() : null),
      onChanged: onChanged,
      validator:
          validator ??
          JetValidators.compose([
            if (isRequired) JetValidators.required(),
            if (minLength != null) JetValidators.minLength(minLength!),
            if (maxLength != null) JetValidators.maxLength(maxLength!),
          ]),
      builder: (FormFieldState<String> field) {
        final state = field as JetFormFieldState<JetFormField<String>, String>;
        return TextField(
          controller: TextEditingController(text: field.value ?? '')
            ..selection = TextSelection.collapsed(
              offset: (field.value ?? '').length,
            ),
          focusNode: state.effectiveFocusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          autofocus: autofocus,
          enabled: enabled && state.enabled,
          readOnly: readOnly,
          maxLength: maxLength,
          maxLines: maxLines,
          minLines: minLines,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          onChanged: field.didChange,
          onSubmitted: onSubmitted,
          autocorrect: autocorrect,
          enableSuggestions: enableSuggestions,
          style: style,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: labelStyle,
            hintText: hintText,
            prefixIcon: showPrefixIcon ? prefixIcon : null,
            suffixIcon: suffixIcon,
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
