import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:pinput/pinput.dart';

/// A customizable PIN field widget with built-in validation using Pinput.
///
/// This widget provides:
/// - PIN/OTP input with customizable length
/// - Visual feedback for filled/focused states
/// - Built-in validation
/// - Customizable appearance and behavior
/// - Integrated with Flutter Form Builder
/// - Auto-submit functionality
///
/// Example usage:
/// ```dart
/// JetPinField(
///   name: 'pin',
///   length: 6,
///   onCompleted: (pin) => print('PIN entered: $pin'),
///   onSubmitted: (pin) => submitPin(pin),
/// )
/// ```
class JetPinField extends HookWidget {
  /// The name identifier for this form field
  final String name;

  /// Initial value for the PIN field
  final String? initialValue;

  /// Custom validator function
  final FormFieldValidator<String>? validator;

  /// Whether this field is required
  final bool isRequired;

  /// Length of the PIN (number of digits)
  final int length;

  /// Callback when PIN is completed (all digits entered)
  final ValueChanged<String>? onCompleted;

  /// Callback when PIN is submitted (e.g., via keyboard action)
  final ValueChanged<String>? onSubmitted;

  /// Callback when PIN value changes
  final ValueChanged<String>? onChanged;

  /// Whether to autofocus this field
  final bool autofocus;

  /// Whether the field is enabled
  final bool enabled;

  /// Whether to obscure the text (for passwords)
  final bool obscureText;

  /// Whether to show cursor
  final bool showCursor;

  /// Text to display when PIN box is empty
  final String? hintCharacter;

  /// Whether to allow multiple lines
  final bool readOnly;

  /// Spacing between PIN boxes
  final double spacing;

  /// Width of each PIN box
  final double? boxWidth;

  /// Height of each PIN box
  final double? boxHeight;

  /// Border radius for PIN boxes
  final BorderRadius? borderRadius;

  /// Color for default state
  final Color? defaultBorderColor;

  /// Color for focused state
  final Color? focusedBorderColor;

  /// Color for filled state
  final Color? filledBorderColor;

  /// Color for submitted state
  final Color? submittedBorderColor;

  /// Color for error state
  final Color? errorBorderColor;

  /// Background color for default state
  final Color? defaultFillColor;

  /// Background color for focused state
  final Color? focusedFillColor;

  /// Background color for filled state
  final Color? filledFillColor;

  /// Background color for submitted state
  final Color? submittedFillColor;

  /// Background color for error state
  final Color? errorFillColor;

  /// Border width for all states
  final double borderWidth;

  /// Text style for PIN digits
  final TextStyle? textStyle;

  /// Text style for hint character
  final TextStyle? hintStyle;

  /// Text style for error text
  final TextStyle? errorStyle;

  /// Curve for animations
  final Curve animationCurve;

  /// Duration for animations
  final Duration animationDuration;

  /// Whether to use haptic feedback
  final bool hapticFeedback;

  /// Close keyboard when completed
  final bool closeKeyboardWhenCompleted;

  /// Error text to display (if any)
  final String? errorText;

  /// Helper text to display below the field
  final String? helperText;

  /// Helper text style
  final TextStyle? helperStyle;

  const JetPinField({
    super.key,
    required this.name,
    this.initialValue,
    this.validator,
    this.isRequired = true,
    this.length = 6,
    this.onCompleted,
    this.onSubmitted,
    this.onChanged,
    this.autofocus = false,
    this.enabled = true,
    this.obscureText = false,
    this.showCursor = true,
    this.hintCharacter,
    this.readOnly = false,
    this.spacing = 16.0,
    this.boxWidth,
    this.boxHeight,
    this.borderRadius,
    this.defaultBorderColor,
    this.focusedBorderColor,
    this.filledBorderColor,
    this.submittedBorderColor,
    this.errorBorderColor,
    this.defaultFillColor,
    this.focusedFillColor,
    this.filledFillColor,
    this.submittedFillColor,
    this.errorFillColor,
    this.borderWidth = 2.0,
    this.textStyle,
    this.hintStyle,
    this.errorStyle,
    this.animationCurve = Curves.easeInOut,
    this.animationDuration = const Duration(milliseconds: 200),
    this.hapticFeedback = false,
    this.closeKeyboardWhenCompleted = false,
    this.errorText,
    this.helperText,
    this.helperStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Create default theme based on current theme
    final defaultPinTheme = PinTheme(
      width: boxWidth ?? 56,
      height: boxHeight ?? 56,
      textStyle:
          textStyle ??
          theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: Border.all(
          color: defaultBorderColor ?? colorScheme.outline,
          width: borderWidth,
        ),
        color: defaultFillColor ?? colorScheme.surface,
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: Border.all(
          color: focusedBorderColor ?? colorScheme.primary,
          width: borderWidth,
        ),
        color: focusedFillColor ?? colorScheme.surface,
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: Border.all(
          color: submittedBorderColor ?? colorScheme.primary,
          width: borderWidth,
        ),
        color: submittedFillColor ?? colorScheme.primaryContainer,
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: Border.all(
          color: errorBorderColor ?? colorScheme.error,
          width: borderWidth,
        ),
        color: errorFillColor ?? colorScheme.errorContainer,
      ),
    );

    return FormBuilderField<String>(
      name: name,
      initialValue: initialValue,
      validator:
          validator ??
          FormBuilderValidators.compose([
            if (isRequired) FormBuilderValidators.required(),
            FormBuilderValidators.minLength(length),
            FormBuilderValidators.maxLength(length),
          ]),
      builder: (FormFieldState<String> field) {
        final hasError = field.hasError;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: Pinput(
                length: length,
                defaultPinTheme: hasError ? errorPinTheme : defaultPinTheme,
                focusedPinTheme: hasError ? errorPinTheme : focusedPinTheme,
                submittedPinTheme: hasError ? errorPinTheme : submittedPinTheme,
                errorPinTheme: errorPinTheme,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: showCursor,
                obscureText: obscureText,
                obscuringCharacter: '*',
                obscuringWidget: obscureText
                    ? const Text(
                        '●',
                        style: TextStyle(fontSize: 24),
                      )
                    : null,
                hapticFeedbackType: hapticFeedback
                    ? HapticFeedbackType.lightImpact
                    : HapticFeedbackType.disabled,
                closeKeyboardWhenCompleted: closeKeyboardWhenCompleted,
                animationCurve: animationCurve,
                animationDuration: animationDuration,
                enabled: enabled,
                autofocus: autofocus,
                readOnly: readOnly,
                controller: TextEditingController(text: field.value),
                onChanged: (value) {
                  field.didChange(value);
                  onChanged?.call(value);
                },
                onCompleted: (value) {
                  field.didChange(value);
                  onCompleted?.call(value);
                },
                onSubmitted: (value) {
                  field.didChange(value);
                  onSubmitted?.call(value);
                },
              ),
            ),
            if (field.hasError || helperText != null) ...[
              const SizedBox(height: 8),
              if (field.hasError)
                Text(
                  field.errorText!,
                  style:
                      errorStyle ??
                      theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                      ),
                )
              else if (helperText != null)
                Text(
                  helperText!,
                  style:
                      helperStyle ??
                      theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
            ],
          ],
        );
      },
    );
  }
}
