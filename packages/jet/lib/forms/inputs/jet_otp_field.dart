import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A custom OTP (One-Time Password) field built from scratch for Flutter Form Builder.
///
/// This field creates individual input boxes for each digit of the OTP, with automatic
/// focus management, paste support, and full integration with Form Builder validation.
///
/// ## Features:
/// - Individual input boxes for each OTP digit
/// - Automatic focus movement between fields
/// - Paste support (tap or long press to paste complete OTP)
/// - Form Builder integration with validation
/// - **Uses app's default theme borders** for consistent styling
/// - **Smart field distribution** with MainAxisAlignment (spaceAround/spaceEvenly)
/// - Override theme properties only when needed
/// - Support for obscured text (like passwords)
/// - Keyboard navigation with backspace support
/// - Responsive design with configurable sizing
///
/// ## Basic Usage:
/// ```dart
/// JetOtpField(
///   name: 'otp',
///   length: 6,
///   onCompleted: (otp) => print('OTP entered: $otp'),
///   // Fields are automatically distributed with MainAxisAlignment.spaceAround
/// )
/// ```
///
/// ## Advanced Usage with Theme Overrides:
/// ```dart
/// JetOtpField(
///   name: 'secure_otp',
///   length: 4,
///   obscureText: true,
///   fieldWidth: 60.0,
///   fieldHeight: 60.0,
///   // spacing parameter is deprecated - fields use MainAxisAlignment instead
///   // Uses theme's default borders unless overridden
///   borderRadius: 8.0,                    // Custom radius
///   focusedBorderColor: Colors.blue,      // Override focused color only
///   onCompleted: (otp) => handleOtpSubmission(otp),
///   validator: (value) {
///     if (value?.length != 4) return 'Please enter all 4 digits';
///     return null;
///   },
/// )
/// ```
///
/// ## Form Builder Integration:
/// ```dart
/// FormBuilder(
///   child: Column(
///     children: [
///       JetOtpField(
///         name: 'verification_code',
///         length: 6,
///         validator: FormBuilderValidators.required(),
///       ),
///       ElevatedButton(
///         onPressed: () {
///           if (_formKey.currentState?.validate() == true) {
///             final otp = _formKey.currentState?.value['verification_code'];
///             // Process OTP
///           }
///         },
///         child: Text('Verify'),
///       ),
///     ],
///   ),
/// )
/// ```
class JetOtpField extends HookWidget {
  /// The form field name for integration with FormBuilder
  final String name;

  /// Number of OTP digits (default is 6)
  final int length;

  /// Initial value for the OTP
  final String? initialValue;

  /// Callback when OTP is completed
  final ValueChanged<String>? onCompleted;

  /// Callback when OTP value changes
  final ValueChanged<String>? onChanged;

  /// Form field validator
  final FormFieldValidator<String>? validator;

  /// Whether the field is enabled
  final bool enabled;

  /// Whether the field is readonly
  final bool readOnly;

  /// Whether to autofocus the first field
  final bool autofocus;

  /// Text style for the OTP digits
  final TextStyle? textStyle;

  /// Width of each OTP box
  final double fieldWidth;

  /// Height of each OTP box
  final double fieldHeight;

  /// Spacing between OTP boxes (deprecated - uses MainAxisAlignment instead)
  final double spacing;

  /// Border radius for the OTP boxes
  final double borderRadius;

  /// Whether to obscure the text (like password)
  final bool obscureText;

  /// Character to use when obscuring text
  final String obscuringCharacter;

  /// Keyboard type for the input
  final TextInputType keyboardType;

  /// Custom decoration for each field
  final InputDecoration? decoration;

  /// Override background color for the boxes (uses theme default if null)
  final Color? fillColor;

  /// Override border color for normal state (uses theme default if null)
  final Color? borderColor;

  /// Override border color for focused state (uses theme default if null)
  final Color? focusedBorderColor;

  /// Override border color for error state (uses theme default if null)
  final Color? errorBorderColor;

  /// Override border width (uses theme default if 2.0)
  final double borderWidth;

  const JetOtpField({
    super.key,
    required this.name,
    this.length = 6,
    this.initialValue,
    this.onCompleted,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = true,
    this.textStyle,
    this.fieldWidth = 56.0,
    this.fieldHeight = 56.0,
    this.spacing = 8.0,
    this.borderRadius = 12.0,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.keyboardType = TextInputType.number,
    this.decoration,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.borderWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final inputTheme = theme.inputDecorationTheme;

    // Create controllers and focus nodes for each field
    final controllers = useMemoized(
      () => List.generate(length, (index) => TextEditingController()),
      [length],
    );

    final focusNodes = useMemoized(
      () => List.generate(length, (index) => FocusNode()),
      [length],
    );

    // Track the current OTP value
    final otpValue = useState<String>('');

    // Initialize with initial value if provided
    useEffect(() {
      if (initialValue != null && initialValue!.isNotEmpty) {
        final digits = initialValue!.split('');
        for (int i = 0; i < length && i < digits.length; i++) {
          controllers[i].text = digits[i];
        }
        otpValue.value = initialValue!;
      }
      return null;
    }, [initialValue]);

    // Clean up controllers and focus nodes
    useEffect(() {
      return () {
        for (final controller in controllers) {
          controller.dispose();
        }
        for (final focusNode in focusNodes) {
          focusNode.dispose();
        }
      };
    }, []);

    // Helper function to get current OTP value
    String getCurrentOtp() {
      return controllers.map((controller) => controller.text).join();
    }

    // Helper function to update OTP value
    void updateOtpValue() {
      final newValue = getCurrentOtp();
      otpValue.value = newValue;
      onChanged?.call(newValue);

      if (newValue.length == length) {
        onCompleted?.call(newValue);
      }
    }

    // Handle paste operation
    void handlePaste(String pastedText) {
      final digits = pastedText.replaceAll(RegExp(r'[^\d]'), '');
      if (digits.isNotEmpty) {
        for (int i = 0; i < length; i++) {
          if (i < digits.length) {
            controllers[i].text = digits[i];
          } else {
            controllers[i].clear();
          }
        }

        // Focus the next empty field or the last field if all are filled
        final nextEmptyIndex = controllers.indexWhere((c) => c.text.isEmpty);
        final focusIndex = nextEmptyIndex == -1 ? length - 1 : nextEmptyIndex;
        if (focusIndex < length) {
          focusNodes[focusIndex].requestFocus();
        }

        updateOtpValue();
      }
    }

    // Build individual OTP field
    Widget buildOtpField(int index) {
      return SizedBox(
        width: fieldWidth,
        height: fieldHeight,
        child: TextFormField(
          controller: controllers[index],
          focusNode: focusNodes[index],
          enabled: enabled && !readOnly,
          autofocus: autofocus && index == 0,
          keyboardType: keyboardType,
          textAlign: TextAlign.center,
          maxLength: 1,
          obscureText: obscureText,
          obscuringCharacter: obscuringCharacter,
          style:
              textStyle ??
              theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: enabled
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withOpacity(0.38),
              ),
          decoration:
              decoration ?? _buildDecoration(theme, colorScheme, inputTheme),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          onChanged: (value) {
            if (value.isNotEmpty) {
              // Move to next field
              if (index < length - 1) {
                focusNodes[index + 1].requestFocus();
              } else {
                focusNodes[index].unfocus();
              }
            } else {
              // Move to previous field on backspace
              if (index > 0) {
                focusNodes[index - 1].requestFocus();
              }
            }
            updateOtpValue();
          },
          onTap: () {
            // Handle paste on tap
            Clipboard.getData('text/plain').then((clipboardData) {
              final text = clipboardData?.text;
              if (text != null && text.length >= length) {
                handlePaste(text);
              }
            });
          },
        ),
      );
    }

    return FormBuilderField<String>(
      name: name,
      validator: validator,
      initialValue: initialValue,
      enabled: enabled,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                // Calculate optimal sizing based on available width (no manual spacing)
                final availableWidth = constraints.maxWidth;
                final requiredWidth = length * fieldWidth;

                // If content fits, use spaceAround alignment (no manual spacing)
                if (requiredWidth <= availableWidth) {
                  return GestureDetector(
                    onLongPress: () async {
                      final clipboardData = await Clipboard.getData(
                        'text/plain',
                      );
                      final text = clipboardData?.text;
                      if (text != null) {
                        handlePaste(text);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (int i = 0; i < length; i++) buildOtpField(i),
                      ],
                    ),
                  );
                }

                // If content doesn't fit, use scrollable container with spaceEvenly
                return GestureDetector(
                  onLongPress: () async {
                    final clipboardData = await Clipboard.getData('text/plain');
                    final text = clipboardData?.text;
                    if (text != null) {
                      handlePaste(text);
                    }
                  },
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int i = 0; i < length; i++) buildOtpField(i),
                      ],
                    ),
                  ),
                );
              },
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  field.errorText!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  InputDecoration _buildDecoration(
    ThemeData theme,
    ColorScheme colorScheme,
    InputDecorationTheme inputTheme,
  ) {
    // Use theme's existing borders as base, only customize specific aspects
    final themeBorder = inputTheme.border;
    final themeEnabledBorder = inputTheme.enabledBorder ?? themeBorder;
    final themeFocusedBorder = inputTheme.focusedBorder ?? themeBorder;
    final themeErrorBorder = inputTheme.errorBorder ?? themeBorder;
    final themeFocusedErrorBorder =
        inputTheme.focusedErrorBorder ?? themeErrorBorder;
    final themeDisabledBorder = inputTheme.disabledBorder ?? themeBorder;

    // Helper function to adapt existing border with custom properties if needed
    InputBorder? adaptBorder(InputBorder? border, {Color? color}) {
      if (border == null) return null;

      // If we have custom properties, apply them to the theme border
      if (border is OutlineInputBorder) {
        return border.copyWith(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: border.borderSide.copyWith(
            color: color ?? border.borderSide.color,
            width: borderWidth != 2.0 ? borderWidth : border.borderSide.width,
          ),
        );
      }

      return border;
    }

    return InputDecoration(
      filled: inputTheme.filled,
      fillColor: fillColor ?? inputTheme.fillColor,
      counterText: '', // Hide character counter
      contentPadding: EdgeInsets.zero,

      // Use theme borders with optional customization
      border: adaptBorder(themeBorder),
      enabledBorder: adaptBorder(themeEnabledBorder, color: borderColor),
      focusedBorder: adaptBorder(themeFocusedBorder, color: focusedBorderColor),
      errorBorder: adaptBorder(themeErrorBorder, color: errorBorderColor),
      focusedErrorBorder: adaptBorder(
        themeFocusedErrorBorder,
        color: errorBorderColor,
      ),
      disabledBorder: adaptBorder(themeDisabledBorder),
    );
  }
}
