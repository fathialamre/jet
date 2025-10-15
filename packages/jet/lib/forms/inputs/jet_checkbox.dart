import 'package:flutter/material.dart';
import 'package:jet/forms/core/jet_form_field_decoration.dart';

/// A single checkbox field for Jet forms.
///
/// This widget extends [JetFormFieldDecoration] and wraps [CheckboxListTile].
///
/// Example:
/// ```dart
/// JetCheckbox(
///   name: 'accept_terms',
///   title: Text('I accept the terms and conditions'),
///   validator: JetValidators.equal(
///     true,
///     errorText: 'You must accept the terms',
///   ),
/// )
/// ```
class JetCheckbox extends JetFormFieldDecoration<bool> {
  /// The primary content of the CheckboxListTile.
  ///
  /// Typically a [Text] widget.
  final Widget title;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget.
  final Widget? subtitle;

  /// A widget to display on the opposite side of the tile from the checkbox.
  ///
  /// Typically an [Icon] widget.
  final Widget? secondary;

  /// The color to use when this checkbox is checked.
  final Color? activeColor;

  /// The color to use for the check icon when this checkbox is checked.
  final Color? checkColor;

  /// Where to place the control relative to its label.
  final ListTileControlAffinity controlAffinity;

  /// Defines insets surrounding the tile's contents.
  final EdgeInsets contentPadding;

  /// Defines how compact the list tile's layout will be.
  final VisualDensity? visualDensity;

  /// Whether this text field should focus itself if nothing else is already
  /// focused.
  final bool autofocus;

  /// If true the checkbox's value can be true, false, or null.
  ///
  /// When a tri-state checkbox is tapped, its [onChanged] callback will be
  /// applied to true if the current value is false, to null if value is true,
  /// and to false if value is null.
  final bool tristate;

  /// Whether to render icons and text in the [activeColor].
  final bool selected;

  /// The shape of the checkbox.
  final OutlinedBorder? shape;

  /// The color and width of the checkbox's border.
  final BorderSide? side;

  /// Creates a single Checkbox field.
  JetCheckbox({
    super.key,
    required super.name,
    super.validator,
    super.initialValue,
    super.decoration = const InputDecoration(
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
    ),
    super.onChanged,
    super.valueTransformer,
    super.enabled = true,
    super.onSaved,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.onReset,
    super.focusNode,
    super.restorationId,
    super.errorBuilder,
    required this.title,
    this.activeColor,
    this.autofocus = false,
    this.checkColor,
    this.contentPadding = EdgeInsets.zero,
    this.visualDensity,
    this.controlAffinity = ListTileControlAffinity.leading,
    this.secondary,
    this.selected = false,
    this.subtitle,
    this.tristate = false,
    this.shape,
    this.side,
  }) : super(
         builder: (FormFieldState<bool?> field) {
           final state = field as _JetCheckboxState;

           return InputDecorator(
             decoration: state.decoration,
             child: CheckboxListTile(
               dense: true,
               isThreeLine: false,
               focusNode: state.effectiveFocusNode,
               title: title,
               subtitle: subtitle,
               value: tristate ? state.value : (state.value ?? false),
               onChanged: state.enabled
                   ? (value) {
                       state.didChange(value);
                     }
                   : null,
               checkColor: checkColor,
               activeColor: activeColor,
               secondary: secondary,
               controlAffinity: controlAffinity,
               autofocus: autofocus,
               tristate: tristate,
               contentPadding: contentPadding,
               visualDensity: visualDensity,
               selected: selected,
               checkboxShape: shape,
               side: side,
             ),
           );
         },
       );

  @override
  JetFormFieldDecorationState<JetCheckbox, bool> createState() =>
      _JetCheckboxState();
}

class _JetCheckboxState extends JetFormFieldDecorationState<JetCheckbox, bool> {
  void _handleFocusChange() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    effectiveFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    effectiveFocusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  @override
  void didChange(bool? value) {
    focus();
    super.didChange(value);
  }
}
