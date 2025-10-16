import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jet/jet_framework.dart';
import 'package:pinput/pinput.dart';

/// A PIN/OTP input field for Jet forms using the Pinput package.
///
/// This widget wraps the [Pinput] package and provides a beautiful PIN/OTP
/// input experience with individual boxes for each digit.
///
/// Example:
/// ```dart
/// JetPinField(
///   name: 'otp',
///   length: 6,
///   decoration: const InputDecoration(
///     labelText: 'Enter OTP',
///   ),
///   onCompleted: (pin) {
///     print('PIN entered: $pin');
///   },
///   validator: JetValidators.compose([
///     JetValidators.required(),
///     JetValidators.exactLength(6),
///   ]),
/// )
/// ```
class JetPinField extends JetFormField<String> {
  /// Number of PIN digits.
  final int length;

  /// Whether to obscure the entered digits.
  final bool obscureText;

  /// Character to use for obscuring text.
  final String obscuringCharacter;

  /// Character to show when obscuring text with a widget.
  final Widget? obscuringWidget;

  /// Whether to show cursor.
  final bool showCursor;

  /// Whether to enable haptic feedback.
  final bool hapticFeedback;

  /// Called when all PIN digits are entered.
  final ValueChanged<String>? onCompleted;

  /// Called when user submits the PIN.
  final VoidCallback? onSubmitted;

  /// Called when user taps on the PIN field.
  final VoidCallback? onTap;

  /// The style to use for the PIN text.
  final TextStyle? textStyle;

  /// Whether to close keyboard when PIN is completed.
  final bool closeKeyboardWhenCompleted;

  /// Default theme for the PIN boxes.
  final PinTheme? defaultPinTheme;

  /// Theme for focused PIN box.
  final PinTheme? focusedPinTheme;

  /// Theme for submitted PIN box.
  final PinTheme? submittedPinTheme;

  /// Theme for PIN box following the focused box.
  final PinTheme? followingPinTheme;

  /// Theme for disabled PIN box.
  final PinTheme? disabledPinTheme;

  /// Theme for PIN box with error.
  final PinTheme? errorPinTheme;

  /// Cursor widget to show.
  final Widget? cursor;

  /// Pre-fill PIN text.
  final String? preFilledWidget;

  /// Separator builder between PIN boxes.
  final Widget Function(int index)? separatorBuilder;

  /// Custom error widget builder for displaying validation errors below the PIN field.
  final Widget Function(String? errorText)? customErrorBuilder;

  /// Error text style.
  final TextStyle? errorTextStyle;

  /// Pinput error builder.
  final PinputErrorBuilder? pinputErrorBuilder;

  /// Controller for the Pinput widget.
  final TextEditingController? controller;

  /// Whether to enable IME personalized learning.
  final bool enableIMEPersonalizedLearning;

  /// Keyboard appearance.
  final Brightness? keyboardAppearance;

  /// List of input formatters.
  final List<TextInputFormatter> inputFormatters;

  /// Whether to enable interactivity.
  final bool enableInteractiveSelection;

  /// List of autofill hints.
  final Iterable<String>? autofillHints;

  /// The decoration for the field container.
  final InputDecoration? decoration;

  /// Keyboard type for the input.
  final TextInputType keyboardType;

  /// Text input action.
  final TextInputAction? textInputAction;

  /// Whether to autofocus the field.
  final bool autofocus;

  /// Force error state.
  final bool forceErrorState;

  /// Creates a PIN/OTP input field.
  JetPinField({
    super.key,
    required super.name,
    super.validator,
    super.onSaved,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.enabled = true,
    super.onChanged,
    super.valueTransformer,
    super.focusNode,
    super.restorationId,
    super.onReset,
    String? initialValue,
    this.length = 6,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.obscuringWidget,
    this.showCursor = true,
    this.hapticFeedback = false,
    this.onCompleted,
    this.onSubmitted,
    this.onTap,
    this.textStyle,
    this.closeKeyboardWhenCompleted = false,
    this.defaultPinTheme,
    this.focusedPinTheme,
    this.submittedPinTheme,
    this.followingPinTheme,
    this.disabledPinTheme,
    this.errorPinTheme,
    this.cursor,
    this.preFilledWidget,
    this.separatorBuilder,
    this.customErrorBuilder,
    this.errorTextStyle,
    this.pinputErrorBuilder,
    this.controller,
    this.enableIMEPersonalizedLearning = true,
    this.keyboardAppearance,
    this.inputFormatters = const [],
    this.enableInteractiveSelection = true,
    this.autofillHints,
    this.decoration,
    this.keyboardType = TextInputType.number,
    this.textInputAction,
    this.autofocus = false,
    this.forceErrorState = false,
  }) : assert(length > 0, 'Length must be greater than 0'),
       assert(initialValue == null || controller == null),
       super(
         initialValue: controller != null ? controller.text : initialValue,
         builder: (FormFieldState<String?> field) {
           final state = field as _JetPinFieldState;

           return _JetPinFieldWidget(
             state: state,
             externalController: controller,
             length: length,
             obscureText: obscureText,
             obscuringCharacter: obscuringCharacter,
             obscuringWidget: obscuringWidget,
             showCursor: showCursor,
             hapticFeedback: hapticFeedback,
             onCompleted: onCompleted,
             closeKeyboardWhenCompleted: closeKeyboardWhenCompleted,
             onSubmitted: onSubmitted,
             onTap: onTap,
             defaultPinTheme: defaultPinTheme,
             focusedPinTheme: focusedPinTheme,
             submittedPinTheme: submittedPinTheme,
             followingPinTheme: followingPinTheme,
             disabledPinTheme: disabledPinTheme,
             errorPinTheme: errorPinTheme,
             cursor: cursor,
             preFilledWidget: preFilledWidget,
             separatorBuilder: separatorBuilder,
             pinputErrorBuilder: pinputErrorBuilder,
             forceErrorState: forceErrorState,
             enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
             keyboardAppearance: keyboardAppearance,
             inputFormatters: inputFormatters,
             enableInteractiveSelection: enableInteractiveSelection,
             autofillHints: autofillHints,
             keyboardType: keyboardType,
             textInputAction: textInputAction,
             autofocus: autofocus,
             decoration: decoration,
             textStyle: textStyle,
             customErrorBuilder: customErrorBuilder,
             errorTextStyle: errorTextStyle,
           );
         },
       );

  @override
  JetFormFieldState<JetPinField, String> createState() => _JetPinFieldState();
}

class _JetPinFieldState extends JetFormFieldState<JetPinField, String> {}

/// Internal widget that uses hooks for controller management.
class _JetPinFieldWidget extends HookWidget {
  const _JetPinFieldWidget({
    required this.state,
    required this.externalController,
    required this.length,
    required this.obscureText,
    required this.obscuringCharacter,
    required this.obscuringWidget,
    required this.showCursor,
    required this.hapticFeedback,
    required this.onCompleted,
    required this.closeKeyboardWhenCompleted,
    required this.onSubmitted,
    required this.onTap,
    required this.defaultPinTheme,
    required this.focusedPinTheme,
    required this.submittedPinTheme,
    required this.followingPinTheme,
    required this.disabledPinTheme,
    required this.errorPinTheme,
    required this.cursor,
    required this.preFilledWidget,
    required this.separatorBuilder,
    required this.pinputErrorBuilder,
    required this.forceErrorState,
    required this.enableIMEPersonalizedLearning,
    required this.keyboardAppearance,
    required this.inputFormatters,
    required this.enableInteractiveSelection,
    required this.autofillHints,
    required this.keyboardType,
    required this.textInputAction,
    required this.autofocus,
    required this.decoration,
    required this.textStyle,
    required this.customErrorBuilder,
    required this.errorTextStyle,
  });

  final _JetPinFieldState state;
  final TextEditingController? externalController;
  final int length;
  final bool obscureText;
  final String obscuringCharacter;
  final Widget? obscuringWidget;
  final bool showCursor;
  final bool hapticFeedback;
  final ValueChanged<String>? onCompleted;
  final bool closeKeyboardWhenCompleted;
  final VoidCallback? onSubmitted;
  final VoidCallback? onTap;
  final PinTheme? defaultPinTheme;
  final PinTheme? focusedPinTheme;
  final PinTheme? submittedPinTheme;
  final PinTheme? followingPinTheme;
  final PinTheme? disabledPinTheme;
  final PinTheme? errorPinTheme;
  final Widget? cursor;
  final String? preFilledWidget;
  final Widget Function(int index)? separatorBuilder;
  final PinputErrorBuilder? pinputErrorBuilder;
  final bool forceErrorState;
  final bool enableIMEPersonalizedLearning;
  final Brightness? keyboardAppearance;
  final List<TextInputFormatter> inputFormatters;
  final bool enableInteractiveSelection;
  final Iterable<String>? autofillHints;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final InputDecoration? decoration;
  final TextStyle? textStyle;
  final Widget Function(String? errorText)? customErrorBuilder;
  final TextStyle? errorTextStyle;

  @override
  Widget build(BuildContext context) {
    // Use hook for controller management - creates and disposes automatically
    final controller = useTextEditingController(
      text: externalController?.text ?? state.initialValue ?? '',
    );

    // Use the external controller if provided, otherwise use the hook-managed one
    final effectiveController = externalController ?? controller;

    // Sync controller changes with form state
    useEffect(
      () {
        void listener() {
          if (effectiveController.text != state.value) {
            state.didChange(effectiveController.text);
          }
        }

        effectiveController.addListener(listener);
        return () => effectiveController.removeListener(listener);
      },
      [effectiveController],
    );

    // Sync form state changes back to controller
    useEffect(
      () {
        if (effectiveController.text != (state.value ?? '')) {
          effectiveController.text = state.value ?? '';
        }
        return null;
      },
      [state.value],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (decoration?.labelText != null) ...[
          Text(
            decoration!.labelText!,
            style:
                decoration!.labelStyle ??
                const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 8),
        ],
        Pinput(
          controller: effectiveController,
          focusNode: state.effectiveFocusNode,
          length: length,
          obscureText: obscureText,
          obscuringCharacter: obscuringCharacter,
          obscuringWidget: obscuringWidget,
          showCursor: showCursor,
          hapticFeedbackType: hapticFeedback
              ? HapticFeedbackType.lightImpact
              : HapticFeedbackType.disabled,
          onCompleted: (pin) {
            state.didChange(pin);
            if (onCompleted != null) {
              onCompleted!(pin);
            }
            if (closeKeyboardWhenCompleted) {
              state.effectiveFocusNode.unfocus();
            }
          },
          onSubmitted: onSubmitted != null ? (_) => onSubmitted!() : null,
          onTap: onTap,
          onChanged: (pin) {
            state.didChange(pin);
          },
          defaultPinTheme:
              defaultPinTheme ??
              PinTheme(
                width: 56,
                height: 56,
                textStyle:
                    textStyle ??
                    const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
          focusedPinTheme: focusedPinTheme,
          submittedPinTheme: submittedPinTheme,
          followingPinTheme: followingPinTheme,
          disabledPinTheme: disabledPinTheme,
          errorPinTheme:
              errorPinTheme ??
              (state.hasError
                  ? PinTheme(
                      width: 56,
                      height: 56,
                      textStyle:
                          textStyle ??
                          const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    )
                  : null),
          cursor: cursor,
          preFilledWidget: preFilledWidget != null
              ? Text(preFilledWidget!)
              : null,
          separatorBuilder: separatorBuilder,
          errorBuilder: pinputErrorBuilder,
          enabled: state.enabled,
          forceErrorState: forceErrorState || state.hasError,
          enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
          keyboardAppearance: keyboardAppearance,
          inputFormatters: inputFormatters,
          enableInteractiveSelection: enableInteractiveSelection,
          autofillHints: autofillHints,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autofocus: autofocus,
        ),
        if (state.hasError && state.errorText != null) ...[
          const SizedBox(height: 8),
          if (customErrorBuilder != null)
            customErrorBuilder!(state.errorText)
          else
            Text(
              state.errorText ?? '',
              style:
                  errorTextStyle ??
                  TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 12,
                  ),
            ),
        ],
        if (decoration?.helperText != null && !state.hasError) ...[
          const SizedBox(height: 8),
          Text(
            decoration!.helperText!,
            style:
                decoration!.helperStyle ??
                TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
          ),
        ],
      ],
    );
  }
}
