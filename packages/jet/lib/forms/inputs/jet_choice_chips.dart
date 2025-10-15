import 'package:flutter/material.dart';
import 'package:jet/forms/core/jet_form_field_decoration.dart';
import 'package:jet/forms/core/jet_form_option.dart';

/// A field to select one or more values from a list of choice chips.
///
/// This widget extends [JetFormFieldDecoration] and uses [ChoiceChip].
///
/// Example:
/// ```dart
/// JetChoiceChips<String>(
///   name: 'size',
///   decoration: InputDecoration(labelText: 'Size'),
///   options: [
///     JetFormOption(value: 's', child: Text('Small')),
///     JetFormOption(value: 'm', child: Text('Medium')),
///     JetFormOption(value: 'l', child: Text('Large')),
///   ],
/// )
/// ```
class JetChoiceChips<T> extends JetFormFieldDecoration<dynamic> {
  /// The list of options the user can select from.
  final List<JetFormOption<T>> options;

  /// The color to use when a chip is selected.
  final Color? selectedColor;

  /// The color to use when a chip is disabled.
  final Color? disabledColor;

  /// The background color for unselected chips.
  final Color? backgroundColor;

  /// The padding around the chip's label.
  final EdgeInsets? labelPadding;

  /// The padding inside the chip.
  final EdgeInsets? padding;

  /// Horizontal space between chips.
  final double spacing;

  /// Vertical space between rows of chips.
  final double runSpacing;

  /// The shape of the chips.
  final OutlinedBorder? shape;

  /// Whether to allow multiple selection.
  final bool multipleSelection;

  /// Whether to show a checkmark on selected chips.
  final bool showCheckmark;

  /// The alignment of chips within rows.
  final WrapAlignment alignment;

  /// The alignment of rows.
  final WrapAlignment runAlignment;

  /// Creates a choice chips field.
  JetChoiceChips({
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
    this.selectedColor,
    this.disabledColor,
    this.backgroundColor,
    this.labelPadding,
    this.padding,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.shape,
    this.multipleSelection = false,
    this.showCheckmark = true,
    this.alignment = WrapAlignment.start,
    this.runAlignment = WrapAlignment.start,
  }) : super(
         builder: (FormFieldState<dynamic> field) {
           final state = field as _JetChoiceChipsState<T>;

           // Handle both single and multiple selection
           final List<T> selectedValues = multipleSelection
               ? (state.value as List<T>? ?? [])
               : (state.value != null ? [state.value as T] : []);

           final chips = options.map((option) {
             final isSelected = selectedValues.contains(option.value);

             return ChoiceChip(
               label: option.child,
               selected: isSelected,
               onSelected: option.enabled && state.enabled
                   ? (bool selected) {
                       if (multipleSelection) {
                         final List<T> updatedValue = List<T>.from(
                           selectedValues,
                         );
                         if (selected) {
                           if (!updatedValue.contains(option.value)) {
                             updatedValue.add(option.value);
                           }
                         } else {
                           updatedValue.remove(option.value);
                         }
                         state.didChange(updatedValue);
                       } else {
                         state.didChange(selected ? option.value : null);
                       }
                     }
                   : null,
               selectedColor: selectedColor,
               disabledColor: disabledColor,
               backgroundColor: backgroundColor,
               labelPadding: labelPadding,
               padding: padding,
               shape: shape,
               showCheckmark: showCheckmark,
             );
           }).toList();

           return Focus(
             focusNode: state.effectiveFocusNode,
             skipTraversal: true,
             canRequestFocus: state.enabled,
             child: InputDecorator(
               decoration: state.decoration,
               child: Wrap(
                 spacing: spacing,
                 runSpacing: runSpacing,
                 alignment: alignment,
                 runAlignment: runAlignment,
                 children: chips,
               ),
             ),
           );
         },
       );

  @override
  JetFormFieldDecorationState<JetChoiceChips<T>, dynamic> createState() =>
      _JetChoiceChipsState<T>();
}

class _JetChoiceChipsState<T>
    extends JetFormFieldDecorationState<JetChoiceChips<T>, dynamic> {
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
