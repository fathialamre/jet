import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jet/jet_framework.dart';

/// A customizable checkbox/switch field widget with built-in validation.
///
/// This widget provides:
/// - Checkbox or switch variant
/// - Label/title positioning
/// - Custom active/inactive colors
/// - Integrated with Flutter Form Builder
///
/// Example usage:
/// ```dart
/// JetCheckboxField(
///   name: 'terms',
///   title: 'I agree to the terms and conditions',
/// )
///
/// // Switch variant
/// JetCheckboxField(
///   name: 'notifications',
///   title: 'Enable notifications',
///   useSwitch: true,
/// )
/// ```
class JetCheckboxField extends HookWidget {
  /// The name identifier for this form field
  final String name;

  /// Initial value for the checkbox field
  final bool? initialValue;

  /// Custom validator function
  final FormFieldValidator<bool>? validator;

  /// Whether this field is required to be true
  final bool isRequired;

  /// Title text to display next to the checkbox
  final String title;

  /// Subtitle text to display below the title
  final String? subtitle;

  /// Whether to autofocus this field
  final bool autofocus;

  /// Whether the field is enabled
  final bool enabled;

  /// Active color for checkbox/switch
  final Color? activeColor;

  /// Inactive color for checkbox/switch
  final Color? inactiveColor;

  /// Check color (color of the check mark)
  final Color? checkColor;

  /// Whether to use a switch instead of checkbox
  final bool useSwitch;

  /// Callback when value changes
  final ValueChanged<bool?>? onChanged;

  /// Control how the checkbox is positioned relative to the text
  final ListTileControlAffinity controlAffinity;

  /// Whether to apply dense vertical spacing
  final bool dense;

  /// Content padding
  final EdgeInsets? contentPadding;

  /// Whether to show border
  final bool selected;

  /// Shape of the checkbox tile
  final OutlinedBorder? shape;

  /// Title text style
  final TextStyle? titleTextStyle;

  /// Subtitle text style
  final TextStyle? subtitleTextStyle;

  /// Error style for validation messages
  final TextStyle? errorStyle;

  const JetCheckboxField({
    super.key,
    required this.name,
    required this.title,
    this.initialValue,
    this.validator,
    this.isRequired = false,
    this.subtitle,
    this.autofocus = false,
    this.enabled = true,
    this.activeColor,
    this.inactiveColor,
    this.checkColor,
    this.useSwitch = false,
    this.onChanged,
    this.controlAffinity = ListTileControlAffinity.leading,
    this.dense = false,
    this.contentPadding,
    this.selected = false,
    this.shape,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.errorStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (useSwitch) {
      return FormBuilderSwitch(
        name: name,
        initialValue: initialValue ?? false,
        enabled: enabled,
        activeColor: activeColor,
        inactiveThumbColor: inactiveColor,
        onChanged: onChanged,
        controlAffinity: controlAffinity,
        contentPadding: contentPadding ?? EdgeInsets.zero,
        title: Text(
          title,
          style: titleTextStyle,
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: subtitleTextStyle,
              )
            : null,
        validator:
            validator ??
            (isRequired
                ? FormBuilderValidators.equal(
                    true,
                    errorText: 'This field must be checked',
                  )
                : null),
      );
    }

    return FormBuilderCheckbox(
      name: name,
      initialValue: initialValue ?? false,
      enabled: enabled,
      activeColor: activeColor,
      checkColor: checkColor,
      onChanged: onChanged,
      controlAffinity: controlAffinity,
      contentPadding: contentPadding ?? EdgeInsets.zero,
      shape: shape,
      title: Text(
        title,
        style: titleTextStyle,
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: subtitleTextStyle,
            )
          : null,
      validator:
          validator ??
          (isRequired
              ? FormBuilderValidators.equal(
                  true,
                  errorText: 'This field must be checked',
                )
              : null),
    );
  }
}
