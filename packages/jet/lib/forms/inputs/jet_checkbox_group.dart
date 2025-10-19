import 'package:flutter/material.dart';
import 'package:jet/forms/core/jet_form_field_decoration.dart';
import 'package:jet/forms/core/jet_form_option.dart';

/// A field to select multiple values from a list of checkboxes.
///
/// This widget extends [JetFormFieldDecoration] and uses [CheckboxListTile].
///
/// Example:
/// ```dart
/// JetCheckboxGroup<String>(
///   name: 'interests',
///   decoration: InputDecoration(labelText: 'Interests'),
///   options: [
///     JetFormOption(value: 'sports', child: Text('Sports')),
///     JetFormOption(value: 'music', child: Text('Music')),
///     JetFormOption(value: 'reading', child: Text('Reading')),
///   ],
/// )
/// ```
class JetCheckboxGroup<T> extends JetFormFieldDecoration<List<T>> {
  /// The list of options the user can select from.
  final List<JetFormOption<T>> options;

  /// The color to use when a checkbox is selected.
  final Color? activeColor;

  /// The color to use for the check icon.
  final Color? checkColor;

  /// Where to place the checkbox relative to its label.
  final ListTileControlAffinity controlAffinity;

  /// Whether to display options vertically or horizontally in a wrap.
  final Axis direction;

  /// Space between checkboxes when using horizontal direction.
  final double spacing;

  /// Space between rows when using horizontal direction.
  final double runSpacing;

  /// Optional decoration for each checkbox item.
  final BoxDecoration? itemDecoration;

  /// Whether checkboxes can be tristate.
  final bool tristate;

  /// Creates a checkbox group field.
  JetCheckboxGroup({
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
    this.checkColor,
    this.controlAffinity = ListTileControlAffinity.leading,
    this.direction = Axis.vertical,
    this.spacing = 0.0,
    this.runSpacing = 0.0,
    this.itemDecoration,
    this.tristate = false,
  }) : super(
         builder: (FormFieldState<List<T>?> field) {
           final state = field as _JetCheckboxGroupState<T>;
           final currentValue = state.value ?? [];

           final checkboxes = options.map((option) {
             final tile = CheckboxListTile(
               value: currentValue.contains(option.value),
               onChanged: option.enabled && state.enabled
                   ? (bool? checked) {
                       final List<T> updatedValue = List<T>.from(currentValue);
                       if (checked == true) {
                         if (!updatedValue.contains(option.value)) {
                           updatedValue.add(option.value);
                         }
                       } else {
                         updatedValue.remove(option.value);
                       }
                       state.didChange(updatedValue);
                     }
                   : null,
               title: option.child,
               activeColor: activeColor,
               checkColor: checkColor,
               controlAffinity: controlAffinity,
               tristate: tristate,
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
               children: checkboxes,
             );
           } else {
             child = Wrap(
               direction: direction,
               spacing: spacing,
               runSpacing: runSpacing,
               children: checkboxes,
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
  JetFormFieldDecorationState<JetCheckboxGroup<T>, List<T>> createState() =>
      _JetCheckboxGroupState<T>();
}

class _JetCheckboxGroupState<T>
    extends JetFormFieldDecorationState<JetCheckboxGroup<T>, List<T>> {
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
