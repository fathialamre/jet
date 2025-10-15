import 'package:flutter/material.dart';

/// A mixin that provides common decoration parameters for Jet form fields.
///
/// This mixin reduces boilerplate by providing shared decoration properties
/// and a helper method to build InputDecoration consistently across all Jet form fields.
///
/// Usage:
/// ```dart
/// class JetCustomField extends HookWidget with JetFieldDecorationMixin {
///   // ... field-specific parameters
///
///   @override
///   Widget build(BuildContext context) {
///     return FormBuilderTextField(
///       decoration: buildInputDecoration(
///         context: context,
///         hintText: hintText,
///         prefixIcon: prefixIcon,
///       ),
///     );
///   }
/// }
/// ```
mixin JetFieldDecorationMixin {
  /// Label text for the field
  String? get labelText => null;

  /// Label style for the field
  TextStyle? get labelStyle => null;

  /// Whether the field should be filled
  bool get filled => true;

  /// Fill color for the field
  Color? get fillColor => null;

  /// Border for the field
  InputBorder? get border => null;

  /// Border when the field is enabled
  InputBorder? get enabledBorder => null;

  /// Border when the field is focused
  InputBorder? get focusedBorder => null;

  /// Border when the field has an error
  InputBorder? get errorBorder => null;

  /// Border when the field is disabled
  InputBorder? get disabledBorder => null;

  /// Content padding for the field
  EdgeInsetsGeometry? get contentPadding => null;

  /// Error style for validation messages
  TextStyle? get errorStyle => null;

  /// Helper text to display below the field
  String? get helperText => null;

  /// Helper text style
  TextStyle? get helperStyle => null;

  /// Constraints for the input field
  BoxConstraints? get constraints => null;

  /// Builds an InputDecoration with all the mixin properties applied.
  ///
  /// Parameters:
  /// - [context]: BuildContext for theme access
  /// - [hintText]: Optional hint text
  /// - [prefixIcon]: Optional prefix icon widget
  /// - [suffixIcon]: Optional suffix icon widget
  /// - [prefix]: Optional prefix widget
  /// - [suffix]: Optional suffix widget
  InputDecoration buildInputDecoration({
    required BuildContext context,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Widget? prefix,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: labelStyle,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      prefix: prefix,
      suffix: suffix,
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
    );
  }
}
