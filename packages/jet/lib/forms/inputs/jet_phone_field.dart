import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
class JetPhoneField extends HookWidget {
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
    this.enabled = true,
    this.minLength = 10,
    this.maxLength = 15,
    this.countryCode,
    this.inputFormatters,
    this.allowInternational = true,
  });

  @override
  Widget build(BuildContext context) {
    // Build input formatters list
    final formatters = <TextInputFormatter>[
      if (!allowInternational)
        FilteringTextInputFormatter.digitsOnly
      else
        FilteringTextInputFormatter.allow(RegExp(r'[\d+\-\(\)\s]')),
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
            if (showPrefixIcon) const Icon(LucideIcons.phone),
            const SizedBox(width: 8),
            Text(
              countryCode!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    } else if (showPrefixIcon || prefixIcon == null) {
      prefixWidget = const Icon(LucideIcons.phone);
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
      decoration: InputDecoration(
        prefixIcon: prefixWidget,
        hintText: hintText,
      ),
      validator:
          validator ??
          FormBuilderValidators.compose([
            if (isRequired) FormBuilderValidators.required(),
            if (!allowInternational) FormBuilderValidators.numeric(),
            FormBuilderValidators.minLength(minLength),
            FormBuilderValidators.maxLength(maxLength),
            // Custom phone validation for international numbers
            if (allowInternational)
              (value) {
                if (value == null || value.isEmpty) return null;
                // Basic international phone validation
                final phoneRegex = RegExp(
                  r'^[\+]?[(]?[0-9]{1,3}[)]?[-\s\.]?[(]?[0-9]{1,4}[)]?[-\s\.]?[0-9]{1,4}[-\s\.]?[0-9]{1,9}$',
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
