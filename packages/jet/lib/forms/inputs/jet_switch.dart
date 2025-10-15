import 'package:flutter/material.dart';
import 'package:jet/forms/core/jet_form_field_decoration.dart';

/// An on/off switch field for Jet forms.
///
/// This widget extends [JetFormFieldDecoration] and wraps [SwitchListTile].
///
/// Example:
/// ```dart
/// JetSwitch(
///   name: 'notifications',
///   title: Text('Enable notifications'),
///   initialValue: true,
/// )
/// ```
class JetSwitch extends JetFormFieldDecoration<bool> {
  /// The primary content of the list tile.
  ///
  /// Typically a [Text] widget.
  final Widget title;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget.
  final Widget? subtitle;

  /// A widget to display on the opposite side of the tile from the switch.
  ///
  /// Typically an [Icon] widget.
  final Widget? secondary;

  /// The color to use when this switch is on.
  final Color? activeColor;

  /// The color to use on the track when this switch is on.
  final Color? activeTrackColor;

  /// The color to use on the thumb when this switch is off.
  final Color? inactiveThumbColor;

  /// The color to use on the track when this switch is off.
  final Color? inactiveTrackColor;

  /// An image to use on the thumb of this switch when the switch is on.
  final ImageProvider? activeThumbImage;

  /// An image to use on the thumb of this switch when the switch is off.
  final ImageProvider? inactiveThumbImage;

  /// The tile's internal padding.
  final EdgeInsets contentPadding;

  /// Where to place the control relative to the label.
  final ListTileControlAffinity controlAffinity;

  /// Whether to render icons and text in the [activeColor].
  final bool selected;

  /// Whether this text field should focus itself if nothing else is already
  /// focused.
  final bool autofocus;

  /// Creates an on/off switch field.
  JetSwitch({
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
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.activeThumbImage,
    this.inactiveThumbImage,
    this.subtitle,
    this.secondary,
    this.controlAffinity = ListTileControlAffinity.trailing,
    this.contentPadding = EdgeInsets.zero,
    this.autofocus = false,
    this.selected = false,
  }) : super(
         builder: (FormFieldState<bool?> field) {
           final state = field as _JetSwitchState;

           return InputDecorator(
             decoration: state.decoration,
             child: SwitchListTile(
               focusNode: state.effectiveFocusNode,
               dense: true,
               isThreeLine: false,
               contentPadding: contentPadding,
               title: title,
               value: state.value ?? false,
               onChanged: state.enabled
                   ? (value) {
                       state.didChange(value);
                     }
                   : null,
               activeThumbColor: activeColor,
               activeThumbImage: activeThumbImage,
               activeTrackColor: activeTrackColor,
               inactiveThumbColor: inactiveThumbColor,
               inactiveThumbImage: inactiveThumbImage,
               inactiveTrackColor: inactiveTrackColor,
               secondary: secondary,
               subtitle: subtitle,
               autofocus: autofocus,
               selected: selected,
               controlAffinity: controlAffinity,
             ),
           );
         },
       );

  @override
  JetFormFieldDecorationState<JetSwitch, bool> createState() =>
      _JetSwitchState();
}

class _JetSwitchState extends JetFormFieldDecorationState<JetSwitch, bool> {
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
}
