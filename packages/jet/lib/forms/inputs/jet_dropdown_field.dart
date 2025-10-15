import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';

/// A customizable dropdown field widget with built-in validation.
///
/// This widget provides:
/// - Type-safe dropdown selection
/// - Customizable options list
/// - Search functionality (optional)
/// - Hint text and validation
/// - Integrated with Flutter Form Builder
///
/// Example usage:
/// ```dart
/// JetDropdownField<String>(
///   name: 'country',
///   hintText: 'Select your country',
///   items: [
///     DropdownMenuItem(value: 'us', child: Text('United States')),
///     DropdownMenuItem(value: 'uk', child: Text('United Kingdom')),
///     DropdownMenuItem(value: 'ca', child: Text('Canada')),
///   ],
/// )
/// ```
class JetDropdownField<T> extends StatelessWidget {
  /// The name identifier for this form field
  final String name;

  /// Initial value for the dropdown field
  final T? initialValue;

  /// Custom validator function
  final FormFieldValidator<T>? validator;

  /// Custom prefix icon widget
  final Widget? prefixIcon;

  /// Whether to show the default dropdown icon
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

  /// List of dropdown items
  final List<DropdownMenuItem<T>> items;

  /// Callback when value changes
  final ValueChanged<T?>? onChanged;

  /// Whether dropdown is expanded to full width
  final bool isExpanded;

  /// Custom dropdown icon
  final Widget? icon;

  /// Style for the selected item
  final TextStyle? style;

  /// Alignment for the dropdown hint and selected item
  final AlignmentGeometry? alignment;

  const JetDropdownField({
    super.key,
    required this.name,
    required this.items,
    this.initialValue,
    this.validator,
    this.showPrefixIcon = false,
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
    this.onChanged,
    this.isExpanded = true,
    this.icon,
    this.style,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown<T>(
      name: name,
      initialValue: initialValue,
      items: items,
      enabled: enabled,
      onChanged: onChanged,
      isExpanded: isExpanded,
      icon: icon,
      style: style,
      alignment: alignment ?? AlignmentDirectional.centerStart,
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
      ),
      validator:
          validator ??
          JetValidators.compose([
            if (isRequired) JetValidators.required(),
          ]),
    );
  }
}
