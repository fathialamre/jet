import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jet/jet_framework.dart';

/// A customizable textarea field widget for multi-line text input.
///
/// This widget provides:
/// - Multi-line text input
/// - Character counter (optional)
/// - Min/max lines configuration
/// - Max length validation
/// - Integrated with Flutter Form Builder
///
/// Example usage:
/// ```dart
/// JetTextAreaField(
///   name: 'description',
///   hintText: 'Enter a description',
///   labelText: 'Description',
///   minLines: 3,
///   maxLines: 6,
///   maxLength: 500,
///   showCharacterCounter: true,
/// )
/// ```
class JetTextAreaField extends StatelessWidget {
  /// The name identifier for this form field
  final String name;

  /// Initial value for the textarea field
  final String? initialValue;

  /// Custom validator function
  final FormFieldValidator<String>? validator;

  /// Custom prefix icon widget
  final Widget? prefixIcon;

  /// Whether to show a prefix icon
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

  /// Minimum number of lines
  final int minLines;

  /// Maximum number of lines (null for unlimited)
  final int? maxLines;

  /// Maximum length of input
  final int? maxLength;

  /// Whether to show character counter
  final bool showCharacterCounter;

  /// Text input action
  final TextInputAction? textInputAction;

  /// Text capitalization
  final TextCapitalization textCapitalization;

  /// Callback when value changes
  final ValueChanged<String?>? onChanged;

  const JetTextAreaField({
    super.key,
    required this.name,
    this.initialValue,
    this.validator,
    this.showPrefixIcon = false,
    this.prefixIcon,
    this.autofocus = false,
    this.isRequired = false,
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
    this.minLines = 3,
    this.maxLines = 6,
    this.maxLength,
    this.showCharacterCounter = false,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.sentences,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      initialValue: initialValue,
      keyboardType: TextInputType.multiline,
      textInputAction: textInputAction ?? TextInputAction.newline,
      textCapitalization: textCapitalization,
      autofocus: autofocus,
      enabled: enabled,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: onChanged,
      inputFormatters: maxLength != null
          ? [LengthLimitingTextInputFormatter(maxLength)]
          : null,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: labelStyle,
        hintText: hintText,
        prefixIcon: showPrefixIcon ? prefixIcon : null,
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
        counterText: showCharacterCounter ? null : '',
      ),
      validator:
          validator ??
          JetValidators.compose([
            if (isRequired) JetValidators.required(),
            if (maxLength != null)
              JetValidators.maxLength(
                maxLength!,
                errorText: 'Maximum length is $maxLength characters',
              ),
          ]),
    );
  }
}
