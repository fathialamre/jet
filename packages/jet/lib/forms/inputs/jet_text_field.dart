import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jet/forms/core/jet_form_field_decoration.dart';
import 'package:jet/forms/inputs/mixins/controller_sync_mixin.dart';

/// A Material Design text field input for Jet forms.
///
/// This widget extends [JetFormFieldDecoration] and wraps Flutter's [TextField].
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'username',
///   decoration: InputDecoration(
///     labelText: 'Username',
///     hintText: 'Enter your username',
///   ),
///   validator: JetValidators.compose([
///     JetValidators.required(),
///     JetValidators.minLength(3),
///   ]),
/// )
/// ```
class JetTextField extends JetFormFieldDecoration<String> {
  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  /// The type of keyboard to use for editing the text.
  final TextInputType? keyboardType;

  /// The type of action button to use for the keyboard.
  final TextInputAction? textInputAction;

  /// Configures how the platform keyboard will select an uppercase or
  /// lowercase keyboard.
  final TextCapitalization textCapitalization;

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

  /// The character to use for obscuring text if [obscureText] is true.
  final String obscuringCharacter;

  /// Whether to hide the text being edited.
  final bool obscureText;

  /// Whether to enable autocorrection.
  final bool autocorrect;

  /// The type of smart dashes to use.
  final SmartDashesType? smartDashesType;

  /// The type of smart quotes to use.
  final SmartQuotesType? smartQuotesType;

  /// Whether to show input suggestions as the user types.
  final bool enableSuggestions;

  /// The maximum number of lines for the text to span.
  final int? maxLines;

  /// The minimum number of lines to occupy when the content spans fewer lines.
  final int? minLines;

  /// Whether this widget's height will be sized to fill its parent.
  final bool expands;

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

  /// Creates a Material Design text field input.
  JetTextField({
    super.key,
    required super.name,
    super.validator,
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
    this.maxLines = 1,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.maxLengthEnforcement,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.autocorrect = true,
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
    this.expands = false,
    this.minLines,
    this.showCursor,
    this.onTap,
    this.onTapOutside,
    this.enableSuggestions = true,
    this.textAlignVertical,
    this.dragStartBehavior = DragStartBehavior.start,
    this.scrollController,
    this.scrollPhysics,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.smartDashesType,
    this.smartQuotesType,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.autofillHints,
    this.obscuringCharacter = '•',
    this.mouseCursor,
    this.contextMenuBuilder,
    this.spellCheckConfiguration,
    this.cursorErrorColor,
  }) : assert(initialValue == null || controller == null),
       assert(minLines == null || minLines > 0),
       assert(maxLines == null || maxLines > 0),
       assert(
         (minLines == null) || (maxLines == null) || (maxLines >= minLines),
         'minLines can\'t be greater than maxLines',
       ),
       assert(
         !expands || (minLines == null && maxLines == null),
         'minLines and maxLines must be null when expands is true.',
       ),
       assert(
         !obscureText || maxLines == 1,
         'Obscured fields cannot be multiline.',
       ),
       assert(maxLength == null || maxLength > 0),
       super(
         initialValue: controller != null ? controller.text : initialValue,
         builder: (FormFieldState<String?> field) {
           final state = field as _JetTextFieldState;

           return _JetTextFieldWidget(
             state: state,
             externalController: controller,
             restorationId: restorationId,
             keyboardType: keyboardType,
             textInputAction: textInputAction,
             style: style,
             strutStyle: strutStyle,
             textAlign: textAlign,
             textAlignVertical: textAlignVertical,
             textDirection: textDirection,
             textCapitalization: textCapitalization,
             autofocus: autofocus,
             readOnly: readOnly,
             showCursor: showCursor,
             obscureText: obscureText,
             autocorrect: autocorrect,
             enableSuggestions: enableSuggestions,
             maxLengthEnforcement: maxLengthEnforcement,
             maxLines: maxLines,
             minLines: minLines,
             expands: expands,
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
             obscuringCharacter: obscuringCharacter,
             autofillHints: autofillHints,
             spellCheckConfiguration: spellCheckConfiguration,
             cursorErrorColor: cursorErrorColor,
           );
         },
       );

  @override
  JetFormFieldDecorationState<JetTextField, String> createState() =>
      _JetTextFieldState();
}

class _JetTextFieldState
    extends JetFormFieldDecorationState<JetTextField, String> {}

/// Internal widget that uses hooks for controller management.
class _JetTextFieldWidget extends HookWidget {
  const _JetTextFieldWidget({
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
    required this.textCapitalization,
    required this.autofocus,
    required this.readOnly,
    required this.showCursor,
    required this.obscureText,
    required this.autocorrect,
    required this.enableSuggestions,
    required this.maxLengthEnforcement,
    required this.maxLines,
    required this.minLines,
    required this.expands,
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
    required this.obscuringCharacter,
    required this.autofillHints,
    required this.spellCheckConfiguration,
    required this.cursorErrorColor,
  });

  final _JetTextFieldState state;
  final TextEditingController? externalController;
  final String? restorationId;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final TextCapitalization textCapitalization;
  final bool autofocus;
  final bool readOnly;
  final bool? showCursor;
  final bool obscureText;
  final bool autocorrect;
  final bool enableSuggestions;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int? maxLines;
  final int? minLines;
  final bool expands;
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
  final String obscuringCharacter;
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

    // Set up bidirectional sync between controller and form state with circular update protection
    useControllerSync(effectiveController, state);

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
      textCapitalization: textCapitalization,
      autofocus: autofocus,
      readOnly: readOnly,
      showCursor: showCursor,
      obscureText: obscureText,
      autocorrect: autocorrect,
      enableSuggestions: enableSuggestions,
      maxLengthEnforcement: maxLengthEnforcement,
      maxLines: maxLines,
      minLines: minLines,
      expands: expands,
      maxLength: maxLength,
      onTap: onTap,
      onTapOutside: onTapOutside,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      inputFormatters: inputFormatters,
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
      obscuringCharacter: obscuringCharacter,
      autofillHints: autofillHints,
      spellCheckConfiguration: spellCheckConfiguration,
      cursorErrorColor: cursorErrorColor,
    );
  }
}
