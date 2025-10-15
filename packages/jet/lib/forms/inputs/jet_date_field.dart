import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';
import 'package:intl/intl.dart';

/// A customizable date field widget with built-in date picker.
///
/// This widget provides:
/// - Native date picker integration
/// - Customizable date format
/// - Min/max date constraints
/// - Calendar icon with tap gesture
/// - Integrated with Flutter Form Builder
///
/// Example usage:
/// ```dart
/// JetDateField(
///   name: 'birthdate',
///   hintText: 'Select your birthdate',
///   labelText: 'Date of Birth',
///   firstDate: DateTime(1900),
///   lastDate: DateTime.now(),
/// )
/// ```
class JetDateField extends StatelessWidget {
  /// The name identifier for this form field
  final String name;

  /// Initial value for the date field
  final DateTime? initialValue;

  /// Custom validator function
  final FormFieldValidator<DateTime>? validator;

  /// Custom prefix icon widget
  final Widget? prefixIcon;

  /// Whether to show the default calendar icon
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

  /// Date format for display (default: 'yyyy-MM-dd')
  final DateFormat? format;

  /// First selectable date
  final DateTime? firstDate;

  /// Last selectable date
  final DateTime? lastDate;

  /// Input type for the date picker
  final InputType inputType;

  /// Callback when date is selected
  final ValueChanged<DateTime?>? onChanged;

  const JetDateField({
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
    this.format,
    this.firstDate,
    this.lastDate,
    this.inputType = InputType.date,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderDateTimePicker(
      name: name,
      initialValue: initialValue,
      enabled: enabled,
      inputType: inputType,
      format: format ?? DateFormat('yyyy-MM-dd'),
      firstDate: firstDate,
      lastDate: lastDate,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: labelStyle,
        hintText: hintText,
        prefixIcon: showPrefixIcon
            ? Icon(PhosphorIcons.calendar())
            : prefixIcon,
        suffixIcon: Icon(PhosphorIcons.caretDown()),
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
          FormBuilderValidators.compose([
            if (isRequired) FormBuilderValidators.required(),
          ]),
    );
  }
}
