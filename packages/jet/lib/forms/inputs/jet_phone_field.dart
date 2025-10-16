import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jet/jet_framework.dart';

/// A customizable phone number field widget with built-in validation.
///
/// This widget provides:
/// - Phone number-specific keyboard
/// - Customizable validation rules
/// - International phone number support
/// - Input formatting options
/// - Integrated with Flutter Form Builder
///
/// Example usage:
/// ```dart
/// JetPhoneField(
///   name: 'phone',
///   hintText: 'Enter phone number',
///   countryCode: '+1', // Optional country code
///   minLength: 10,
///   maxLength: 15,
/// )
/// ```
class JetPhoneField extends StatelessWidget {
  /// The name identifier for this form field
  final String name;

  /// Initial value for the phone field
  final String? initialValue;

  /// Custom validator function
  final FormFieldValidator<String>? validator;

  /// Custom prefix icon widget
  final Widget? prefixIcon;

  /// Whether to show the default phone icon
  final bool showPrefixIcon;

  /// Whether this field is required
  final bool isRequired;

  /// Hint text to display when field is empty
  final String hintText;

  /// Hint text style
  final TextStyle? hintStyle;

  /// Whether to autofocus this field
  final bool autofocus;

  /// Whether the field is enabled
  final bool enabled;

  /// Minimum length for phone number (default: 10)
  final int minLength;

  /// Maximum length for phone number (default: 15)
  final int maxLength;

  /// Country code prefix (e.g., '+1', '+44')
  final String? countryCode;

  /// Input formatters for the field
  final List<TextInputFormatter>? inputFormatters;

  /// Whether to allow international format
  final bool allowInternational;

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

  final void Function(String?)? onChanged;

  /// Helper text style
  final TextStyle? helperStyle;

  /// Constraints for the input field
  final BoxConstraints? constraints;

  /// Value transformer to transform the value before saving
  final ValueTransformer<String?>? valueTransformer;

  const JetPhoneField({
    super.key,
    required this.name,
    this.initialValue,
    this.validator,
    this.showPrefixIcon = true,
    this.prefixIcon,
    this.autofocus = false,
    this.isRequired = true,
    this.hintText = '',
    this.hintStyle = const TextStyle(color: Color(0xFF7A7A7A)),
    this.enabled = true,
    this.minLength = 10,
    this.maxLength = 15,
    this.countryCode,
    this.inputFormatters,
    this.allowInternational = true,
    this.labelText,
    this.labelStyle,
    this.onChanged,
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
    this.valueTransformer,
  });

  @override
  Widget build(BuildContext context) {
    // Build input formatters list
    final formatters = <TextInputFormatter>[
      if (!allowInternational)
        FilteringTextInputFormatter.digitsOnly
      else
        FilteringTextInputFormatter.allow(RegExp(r'[\d+\-()\s]')),
      LengthLimitingTextInputFormatter(
        allowInternational
            ? maxLength + 5
            : maxLength, // Extra chars for formatting
      ),
      ...?inputFormatters,
    ];

    // Build prefix widget with country code if provided
    Widget? prefixWidget;
    if (countryCode != null) {
      prefixWidget = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showPrefixIcon) Icon(PhosphorIcons.phone()),
            const SizedBox(width: 8),
            Text(
              countryCode!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    } else if (showPrefixIcon || prefixIcon == null) {
      prefixWidget = Icon(PhosphorIcons.phone());
    } else {
      prefixWidget = prefixIcon;
    }

    return FormBuilderTextField(
      name: name,
      initialValue: initialValue,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      autofocus: autofocus,
      enabled: enabled,
      inputFormatters: formatters,
      onChanged: onChanged,
      valueTransformer: valueTransformer ?? (value) => value?.trim(),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: labelStyle,
        hintText: hintText,
        prefixIcon: prefixWidget,
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
            if (!allowInternational) JetValidators.numeric(),
            JetValidators.minLength(minLength),
            JetValidators.maxLength(maxLength),
            // Custom phone validation for international numbers
            if (allowInternational)
              (value) {
                if (value == null || value.isEmpty) return null;
                // Basic international phone validation
                final phoneRegex = RegExp(
                  r'^[+]?[(]?[0-9]{1,3}[)]?[-\s.]?[(]?[0-9]{1,4}[)]?[-\s.]?[0-9]{1,4}[-\s.]?[0-9]{1,9}$',
                );
                if (!phoneRegex.hasMatch(value)) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
          ]),
    );
  }
}
