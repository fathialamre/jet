import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jet/forms/core/jet_form_field_decoration.dart';
import 'package:jet/forms/validation/jet_validators.dart';

/// A Material Design phone number field input for Jet forms.
///
/// This widget extends [JetFormFieldDecoration] and wraps Flutter's [TextField]
/// with automatic phone number formatting and validation.
///
/// Example:
/// ```dart
/// JetPhoneField(
///   name: 'phone',
///   decoration: InputDecoration(
///     labelText: 'Phone Number',
///     hintText: 'Enter your phone number',
///   ),
///   isRequired: true,
/// )
/// ```
class JetPhoneField extends JetFormFieldDecoration<String> {
  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  /// The type of keyboard to use for editing the text.
  /// Defaults to [TextInputType.phone].
  final TextInputType? keyboardType;

  /// The type of action button to use for the keyboard.
  final TextInputAction? textInputAction;

  /// The style to use for the text being edited.
  final TextStyle? style;

  /// The strut style to use.
  final StrutStyle? strutStyle;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// The alignment of the text vertically within the input field.
  final TextAlignVertical? textAlignVertical;

  /// The directionality of the text.
  final TextDirection? textDirection;

  /// Whether this text field should focus itself if nothing else is already
  /// focused.
  final bool autofocus;

  /// Whether to enable autocorrection.
  final bool autocorrect;

  /// The type of smart dashes to use.
  final SmartDashesType? smartDashesType;

  /// The type of smart quotes to use.
  final SmartQuotesType? smartQuotesType;

  /// Whether to show input suggestions as the user types.
  final bool enableSuggestions;

  /// Whether the text field is read-only.
  final bool readOnly;

  /// Whether to show cursor.
  final bool? showCursor;

  /// The maximum number of characters (Unicode grapheme clusters) to allow.
  final int? maxLength;

  /// Determines how the [maxLength] limit should be enforced.
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// Called when the user initiates a change to the TextField's value.
  final VoidCallback? onEditingComplete;

  /// Called when the user indicates that they are done editing the text.
  final ValueChanged<String>? onSubmitted;

  /// Optional input validation and formatting overrides.
  ///
  /// By default, only digits are allowed. If you provide custom formatters,
  /// they will be added after the digits-only formatter.
  final List<TextInputFormatter>? inputFormatters;

  /// How thick the cursor will be.
  final double cursorWidth;

  /// How tall the cursor will be.
  final double? cursorHeight;

  /// How rounded the corners of the cursor should be.
  final Radius? cursorRadius;

  /// The color to use when painting the cursor.
  final Color? cursorColor;

  /// The appearance of the keyboard.
  final Brightness? keyboardAppearance;

  /// The amount of space by which to inset the child.
  final EdgeInsets scrollPadding;

  /// Whether to enable user interface affordances for changing the text
  /// selection.
  final bool enableInteractiveSelection;

  /// Builds a counter widget below the text field.
  final InputCounterWidgetBuilder? buildCounter;

  /// Determines the way that drag start behavior is handled.
  final DragStartBehavior dragStartBehavior;

  /// The [ScrollController] to use when scrolling.
  final ScrollController? scrollController;

  /// The [ScrollPhysics] to use when scrolling.
  final ScrollPhysics? scrollPhysics;

  /// Defines how the selection highlight should be painted.
  final ui.BoxHeightStyle selectionHeightStyle;

  /// Defines how wide the selection highlight should be painted.
  final ui.BoxWidthStyle selectionWidthStyle;

  /// A list of strings that helps the autofill service identify the type of
  /// this text input.
  final Iterable<String>? autofillHints;

  /// Called when the user taps on this text field.
  final GestureTapCallback? onTap;

  /// Called when the user taps outside this text field.
  final TapRegionCallback? onTapOutside;

  /// The cursor for a mouse pointer when it enters or hovers over the widget.
  final MouseCursor? mouseCursor;

  /// Builds the text selection toolbar when requested by the user.
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// Configuration of handler for [SpellCheckService] results.
  final SpellCheckConfiguration? spellCheckConfiguration;

  /// The color of the cursor when the input is showing an error.
  final Color? cursorErrorColor;

  /// Whether this field is required.
  ///
  /// When true, automatically adds a required validator to the field.
  final bool isRequired;

  /// Minimum length for the phone number.
  ///
  /// Defaults to 7 if not specified.
  final int? minLength;

  /// Maximum length for the phone number.
  ///
  /// If not specified, no maximum length validation is applied.
  final int? maxPhoneLength;

  /// Creates a Material Design phone field input.
  JetPhoneField({
    super.key,
    required super.name,
    FormFieldValidator<String>? validator,
    super.decoration = const InputDecoration(),
    super.onChanged,
    super.valueTransformer,
    super.enabled = true,
    super.onSaved,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.onReset,
    super.focusNode,
    super.restorationId,
    String? initialValue,
    super.errorBuilder,
    this.controller,
    this.readOnly = false,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.maxLengthEnforcement,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.autocorrect = false,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.keyboardType,
    this.style,
    this.textInputAction,
    this.strutStyle,
    this.textDirection,
    this.maxLength,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.buildCounter,
    this.showCursor,
    this.onTap,
    this.onTapOutside,
    this.enableSuggestions = false,
    this.textAlignVertical,
    this.dragStartBehavior = DragStartBehavior.start,
    this.scrollController,
    this.scrollPhysics,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.smartDashesType,
    this.smartQuotesType,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.autofillHints = const [AutofillHints.telephoneNumber],
    this.mouseCursor,
    this.contextMenuBuilder,
    this.spellCheckConfiguration,
    this.cursorErrorColor,
    this.isRequired = false,
    this.minLength,
    this.maxPhoneLength,
  }) : assert(initialValue == null || controller == null),
       assert(maxLength == null || maxLength > 0),
       super(
         initialValue: controller != null ? controller.text : initialValue,
         validator: (value) {
           // Build validator chain based on isRequired and other parameters
           final validators = <FormFieldValidator<String>>[];

           // Add required validator if needed
           if (isRequired) {
             validators.add(JetValidators.required<String>());
           }

           // Add numeric validator to ensure only numbers
           validators.add(JetValidators.numeric());

           // Add min length validator if specified
           if (minLength != null) {
             validators.add(JetValidators.minLength(minLength));
           }

           // Add max length validator if specified
           if (maxPhoneLength != null) {
             validators.add(JetValidators.maxLength(maxPhoneLength));
           }

           // Add custom validator if provided
           if (validator != null) {
             validators.add(validator);
           }

           // If no validators, return null
           if (validators.isEmpty) {
             return null;
           }

           // Compose all validators
           return JetValidators.compose(validators)(value);
         },
         builder: (FormFieldState<String?> field) {
           final state = field as _JetPhoneFieldState;

           return _JetPhoneFieldWidget(
             state: state,
             externalController: controller,
             restorationId: restorationId,
             keyboardType: keyboardType ?? TextInputType.phone,
             textInputAction: textInputAction,
             style: style,
             strutStyle: strutStyle,
             textAlign: textAlign,
             textAlignVertical: textAlignVertical,
             textDirection: textDirection,
             autofocus: autofocus,
             readOnly: readOnly,
             showCursor: showCursor,
             autocorrect: autocorrect,
             enableSuggestions: enableSuggestions,
             maxLengthEnforcement: maxLengthEnforcement,
             maxLength: maxLength,
             onTap: onTap,
             onTapOutside: onTapOutside,
             onEditingComplete: onEditingComplete,
             onSubmitted: onSubmitted,
             inputFormatters: inputFormatters,
             cursorWidth: cursorWidth,
             cursorHeight: cursorHeight,
             cursorRadius: cursorRadius,
             cursorColor: cursorColor,
             scrollPadding: scrollPadding,
             keyboardAppearance: keyboardAppearance,
             enableInteractiveSelection: enableInteractiveSelection,
             buildCounter: buildCounter,
             dragStartBehavior: dragStartBehavior,
             scrollController: scrollController,
             scrollPhysics: scrollPhysics,
             selectionHeightStyle: selectionHeightStyle,
             selectionWidthStyle: selectionWidthStyle,
             smartDashesType: smartDashesType,
             smartQuotesType: smartQuotesType,
             mouseCursor: mouseCursor,
             contextMenuBuilder: contextMenuBuilder,
             autofillHints: autofillHints,
             spellCheckConfiguration: spellCheckConfiguration,
             cursorErrorColor: cursorErrorColor,
           );
         },
       );

  @override
  JetFormFieldDecorationState<JetPhoneField, String> createState() =>
      _JetPhoneFieldState();
}

class _JetPhoneFieldState
    extends JetFormFieldDecorationState<JetPhoneField, String> {}

/// Internal widget that uses hooks for controller management.
class _JetPhoneFieldWidget extends HookWidget {
  const _JetPhoneFieldWidget({
    required this.state,
    required this.externalController,
    required this.restorationId,
    required this.keyboardType,
    required this.textInputAction,
    required this.style,
    required this.strutStyle,
    required this.textAlign,
    required this.textAlignVertical,
    required this.textDirection,
    required this.autofocus,
    required this.readOnly,
    required this.showCursor,
    required this.autocorrect,
    required this.enableSuggestions,
    required this.maxLengthEnforcement,
    required this.maxLength,
    required this.onTap,
    required this.onTapOutside,
    required this.onEditingComplete,
    required this.onSubmitted,
    required this.inputFormatters,
    required this.cursorWidth,
    required this.cursorHeight,
    required this.cursorRadius,
    required this.cursorColor,
    required this.scrollPadding,
    required this.keyboardAppearance,
    required this.enableInteractiveSelection,
    required this.buildCounter,
    required this.dragStartBehavior,
    required this.scrollController,
    required this.scrollPhysics,
    required this.selectionHeightStyle,
    required this.selectionWidthStyle,
    required this.smartDashesType,
    required this.smartQuotesType,
    required this.mouseCursor,
    required this.contextMenuBuilder,
    required this.autofillHints,
    required this.spellCheckConfiguration,
    required this.cursorErrorColor,
  });

  final _JetPhoneFieldState state;
  final TextEditingController? externalController;
  final String? restorationId;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool autofocus;
  final bool readOnly;
  final bool? showCursor;
  final bool autocorrect;
  final bool enableSuggestions;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int? maxLength;
  final GestureTapCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final EdgeInsets scrollPadding;
  final Brightness? keyboardAppearance;
  final bool enableInteractiveSelection;
  final InputCounterWidgetBuilder? buildCounter;
  final DragStartBehavior dragStartBehavior;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;
  final ui.BoxHeightStyle selectionHeightStyle;
  final ui.BoxWidthStyle selectionWidthStyle;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final MouseCursor? mouseCursor;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final Iterable<String>? autofillHints;
  final SpellCheckConfiguration? spellCheckConfiguration;
  final Color? cursorErrorColor;

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

    // Build effective input formatters with digits-only restriction
    final effectiveInputFormatters = <TextInputFormatter>[
      FilteringTextInputFormatter.digitsOnly,
      if (inputFormatters != null) ...inputFormatters!,
    ];

    return TextField(
      restorationId: restorationId,
      controller: effectiveController,
      focusNode: state.effectiveFocusNode,
      decoration: state.decoration,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      textDirection: textDirection,
      autofocus: autofocus,
      readOnly: readOnly,
      showCursor: showCursor,
      autocorrect: autocorrect,
      enableSuggestions: enableSuggestions,
      maxLengthEnforcement: maxLengthEnforcement,
      maxLength: maxLength,
      onTap: onTap,
      onTapOutside: onTapOutside,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      inputFormatters: effectiveInputFormatters,
      enabled: state.enabled,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      scrollPadding: scrollPadding,
      keyboardAppearance: keyboardAppearance,
      enableInteractiveSelection: enableInteractiveSelection,
      buildCounter: buildCounter,
      dragStartBehavior: dragStartBehavior,
      scrollController: scrollController,
      scrollPhysics: scrollPhysics,
      selectionHeightStyle: selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      mouseCursor: mouseCursor,
      contextMenuBuilder: contextMenuBuilder,
      autofillHints: autofillHints,
      spellCheckConfiguration: spellCheckConfiguration,
      cursorErrorColor: cursorErrorColor,
    );
  }
}
