import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pinput/pinput.dart';

typedef JetPinTheme = PinTheme;

class JetPinField extends StatelessWidget {
  final String name;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;
  final ValueTransformer<String?>? valueTransformer;
  final bool enabled;
  final FormFieldSetter<String>? onSaved;
  final bool readOnly;
  final TextStyle? textStyle;
  final int length;
  final FormFieldValidator<String>? validator;
  final InputDecoration? decoration;
  final double borderRadius;
  final JetPinTheme? defaultPinTheme;
  final JetPinTheme? focusedPinTheme;
  final JetPinTheme? errorPinTheme;
  final JetPinTheme? submittedPinTheme;
  final bool autofocus;
  final String? initialValue;

  const JetPinField({
    super.key,
    required this.name,
    this.onCompleted,
    this.onChanged,
    this.valueTransformer,
    this.enabled = true,
    this.onSaved,
    this.readOnly = false,
    this.textStyle,
    this.length = 6,
    this.validator,
    this.decoration,
    this.borderRadius = 10,
    this.defaultPinTheme,
    this.focusedPinTheme,
    this.errorPinTheme,
    this.submittedPinTheme,
    this.autofocus = false,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultTheme = _getDefaultPinTheme(theme);
    final borderRadius = BorderRadius.circular(this.borderRadius);

    return FormBuilderField<String>(
      name: name,
      validator: validator,
      initialValue: initialValue,
      enabled: enabled,
      onSaved: onSaved,
      valueTransformer: valueTransformer,
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: Pinput(
                  length: length,
                  defaultPinTheme: defaultTheme,
                  focusedPinTheme:
                      _getFocusedPinTheme(theme, defaultTheme, borderRadius),
                  errorPinTheme:
                      _getErrorPinTheme(theme, defaultTheme, borderRadius),
                  submittedPinTheme: _getSubmittedPinTheme(theme, defaultTheme),
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  cursor: Icon(
                    LucideIcons.textCursor,
                    color: theme.colorScheme.primary,
                    size: 18,
                  ),
                  autofocus: autofocus,
                  readOnly: readOnly,
                  onChanged: (value) {
                    field.didChange(value);
                    onChanged?.call(value);
                  },
                  onCompleted: (pin) {
                    field.didChange(pin);
                    onCompleted?.call(pin);
                  },
                ),
              ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    field.errorText!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  JetPinTheme _getDefaultPinTheme(ThemeData theme) {
    final inputTheme = theme.inputDecorationTheme;
    final colorScheme = theme.colorScheme;

    return defaultPinTheme ??
        PinTheme(
          width: 56,
          height: 56,
          textStyle: textStyle ??
              theme.textTheme.titleMedium?.copyWith(
                color:
                    theme.textTheme.titleMedium?.color ?? colorScheme.onSurface,
              ),
          decoration: BoxDecoration(
            color: inputTheme.fillColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        );
  }

  JetPinTheme _getFocusedPinTheme(
    ThemeData theme,
    JetPinTheme defaultTheme,
    BorderRadius borderRadius,
  ) {
    final inputTheme = theme.inputDecorationTheme;
    final colorScheme = theme.colorScheme;

    return focusedPinTheme ??
        defaultTheme.copyDecorationWith(
          border: Border.all(
            width: inputTheme.focusedBorder?.borderSide.width ?? 2,
            color: inputTheme.focusedBorder?.borderSide.color ??
                colorScheme.primary,
          ),
          borderRadius: borderRadius,
        );
  }

  JetPinTheme _getErrorPinTheme(
    ThemeData theme,
    JetPinTheme defaultTheme,
    BorderRadius borderRadius,
  ) {
    final inputTheme = theme.inputDecorationTheme;
    final colorScheme = theme.colorScheme;

    return errorPinTheme ??
        defaultTheme.copyDecorationWith(
          border: Border.all(
            color:
                inputTheme.errorBorder?.borderSide.color ?? colorScheme.error,
          ),
          borderRadius: borderRadius,
        );
  }

  JetPinTheme _getSubmittedPinTheme(ThemeData theme, JetPinTheme defaultTheme) {
    final inputTheme = theme.inputDecorationTheme;

    return submittedPinTheme ??
        defaultTheme.copyWith(
          decoration: defaultTheme.decoration?.copyWith(
            color: inputTheme.filled ? inputTheme.fillColor : null,
          ),
        );
  }
}
