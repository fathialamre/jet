import 'package:flutter/material.dart';
import 'package:jet/forms/core/jet_form_field_decoration.dart';
import 'package:jet/forms/core/jet_form_option.dart';

/// A field to select one value from a list of radio buttons.
///
/// This widget extends [JetFormFieldDecoration] and uses [RadioListTile].
///
/// Example:
/// ```dart
/// JetRadioGroup<String>(
///   name: 'gender',
///   decoration: InputDecoration(labelText: 'Gender'),
///   options: [
///     JetFormOption(value: 'male', child: Text('Male')),
///     JetFormOption(value: 'female', child: Text('Female')),
///     JetFormOption(value: 'other', child: Text('Other')),
///   ],
/// )
/// ```
class JetRadioGroup<T> extends JetFormFieldDecoration<T> {
  /// The list of options the user can select from.
  final List<JetFormOption<T>> options;

  /// The color to use when a radio button is selected.
  final Color? activeColor;

  /// The color for the Material when it has the input focus.
  final Color? focusColor;

  /// Where to place the radio button relative to its label.
  final ListTileControlAffinity controlAffinity;

  /// Whether to display options vertically or horizontally in a wrap.
  final Axis direction;

  /// Space between radio buttons when using horizontal direction.
  final double spacing;

  /// Space between rows when using horizontal direction.
  final double runSpacing;

  /// Optional decoration for each radio item.
  final BoxDecoration? itemDecoration;

  /// Creates a radio group field.
  JetRadioGroup({
    super.key,
    required super.name,
    super.validator,
    super.initialValue,
    super.decoration = const InputDecoration(),
    super.onChanged,
    super.valueTransformer,
    super.enabled = true,
    super.onSaved,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.onReset,
    super.focusNode,
    super.restorationId,
    super.errorBuilder,
    required this.options,
    this.activeColor,
    this.focusColor,
    this.controlAffinity = ListTileControlAffinity.leading,
    this.direction = Axis.vertical,
    this.spacing = 0.0,
    this.runSpacing = 0.0,
    this.itemDecoration,
  }) : super(
         builder: (FormFieldState<T?> field) {
           final state = field as _JetRadioGroupState<T>;

           final radioButtons = options.map((option) {
             final tile = RadioListTile<T>(
               value: option.value,
               groupValue: state.value,
               onChanged: option.enabled && state.enabled
                   ? (T? value) {
                       state.didChange(value);
                     }
                   : null,
               title: option.child,
               activeColor: activeColor,
               controlAffinity: controlAffinity,
               dense: true,
             );

             if (itemDecoration != null) {
               return Container(
                 decoration: itemDecoration,
                 child: tile,
               );
             }
             return tile;
           }).toList();

           Widget child;
           if (direction == Axis.vertical) {
             child = Column(
               mainAxisSize: MainAxisSize.min,
               children: radioButtons,
             );
           } else {
             child = Wrap(
               direction: direction,
               spacing: spacing,
               runSpacing: runSpacing,
               children: radioButtons,
             );
           }

           return Focus(
             focusNode: state.effectiveFocusNode,
             skipTraversal: true,
             canRequestFocus: state.enabled,
             child: InputDecorator(
               decoration: state.decoration,
               child: child,
             ),
           );
         },
       );

  @override
  JetFormFieldDecorationState<JetRadioGroup<T>, T> createState() =>
      _JetRadioGroupState<T>();
}

class _JetRadioGroupState<T>
    extends JetFormFieldDecorationState<JetRadioGroup<T>, T> {
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
