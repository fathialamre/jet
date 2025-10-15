import 'package:flutter/material.dart';
import '../core/jet_form_field.dart';
import 'package:pinput/pinput.dart';
import 'package:jet/forms/validators/jet_validators.dart';

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
class JetPinField extends StatefulWidget {
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
  State<JetPinField> createState() => _JetPinFieldState();
}

class _JetPinFieldState extends State<JetPinField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void didUpdateWidget(JetPinField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _controller.text = widget.initialValue ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Create default theme based on current theme
    final defaultPinTheme = PinTheme(
      width: widget.boxWidth ?? 56,
      height: widget.boxHeight ?? 56,
      textStyle:
          widget.textStyle ??
          theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
        border: Border.all(
          color: widget.defaultBorderColor ?? colorScheme.outline,
          width: widget.borderWidth,
        ),
        color: widget.defaultFillColor ?? colorScheme.surface,
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
        border: Border.all(
          color: widget.focusedBorderColor ?? colorScheme.primary,
          width: widget.borderWidth,
        ),
        color: widget.focusedFillColor ?? colorScheme.surface,
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
        border: Border.all(
          color: widget.submittedBorderColor ?? colorScheme.primary,
          width: widget.borderWidth,
        ),
        color: widget.submittedFillColor ?? colorScheme.primaryContainer,
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
        border: Border.all(
          color: widget.errorBorderColor ?? colorScheme.error,
          width: widget.borderWidth,
        ),
        color: widget.errorFillColor ?? colorScheme.errorContainer,
      ),
    );

    return FormBuilderField<String>(
      name: widget.name,
      initialValue: widget.initialValue,
      validator:
          widget.validator ??
          JetValidators.compose([
            if (widget.isRequired) JetValidators.required(),
            JetValidators.minLength(widget.length),
            JetValidators.maxLength(widget.length),
          ]),
      builder: (FormFieldState<String> field) {
        final hasError = field.hasError;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: Pinput(
                length: widget.length,
                defaultPinTheme: hasError ? errorPinTheme : defaultPinTheme,
                focusedPinTheme: hasError ? errorPinTheme : focusedPinTheme,
                submittedPinTheme: hasError ? errorPinTheme : submittedPinTheme,
                errorPinTheme: errorPinTheme,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: widget.showCursor,
                obscureText: widget.obscureText,
                obscuringCharacter: '*',
                obscuringWidget: widget.obscureText
                    ? const Text(
                        '●',
                        style: TextStyle(fontSize: 18),
                      )
                    : null,
                hapticFeedbackType: widget.hapticFeedback
                    ? HapticFeedbackType.lightImpact
                    : HapticFeedbackType.disabled,
                closeKeyboardWhenCompleted: widget.closeKeyboardWhenCompleted,
                animationCurve: widget.animationCurve,
                animationDuration: widget.animationDuration,
                enabled: widget.enabled,
                autofocus: widget.autofocus,
                readOnly: widget.readOnly,
                controller: _controller,
                onChanged: (value) {
                  field.didChange(value);
                  _controller.text = value;
                  widget.onChanged?.call(value);
                },
                onCompleted: (value) {
                  field.didChange(value);
                  _controller.text = value;
                  widget.onCompleted?.call(value);
                },
                onSubmitted: (value) {
                  field.didChange(value);
                  _controller.text = value;
                  widget.onSubmitted?.call(value);
                },
              ),
            ),
            if (field.hasError || widget.helperText != null) ...[
              const SizedBox(height: 8),
              if (field.hasError)
                Text(
                  field.errorText!,
                  style:
                      widget.errorStyle ??
                      theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                        fontSize: 16,
                      ),
                )
              else if (widget.helperText != null)
                Text(
                  widget.helperText!,
                  style:
                      widget.helperStyle ??
                      theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 18,
                      ),
                ),
            ],
          ],
        );
      },
    );
  }
}
