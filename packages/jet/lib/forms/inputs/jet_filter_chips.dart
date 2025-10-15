import 'package:flutter/material.dart';
import 'package:jet/forms/core/jet_form_field_decoration.dart';
import 'package:jet/forms/core/jet_form_option.dart';

/// A field to select multiple values from a list of filter chips.
///
/// This widget extends [JetFormFieldDecoration] and uses [FilterChip].
///
/// Example:
/// ```dart
/// JetFilterChips<String>(
///   name: 'tags',
///   decoration: InputDecoration(labelText: 'Tags'),
///   options: [
///     JetFormOption(value: 'tech', child: Text('Technology')),
///     JetFormOption(value: 'design', child: Text('Design')),
///     JetFormOption(value: 'business', child: Text('Business')),
///   ],
/// )
/// ```
class JetFilterChips<T> extends JetFormFieldDecoration<List<T>> {
  /// The list of options the user can select from.
  final List<JetFormOption<T>> options;

  /// The color to use when a chip is selected.
  final Color? selectedColor;

  /// The color to use when a chip is disabled.
  final Color? disabledColor;

  /// The background color for unselected chips.
  final Color? backgroundColor;

  /// The color of the checkmark on selected chips.
  final Color? checkmarkColor;

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

  /// Whether to show a checkmark on selected chips.
  final bool showCheckmark;

  /// The alignment of chips within rows.
  final WrapAlignment alignment;

  /// The alignment of rows.
  final WrapAlignment runAlignment;

  /// An optional avatar to display at the beginning of the chip.
  final Widget Function(JetFormOption<T> option)? avatarBuilder;

  /// Creates a filter chips field.
  JetFilterChips({
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
    this.checkmarkColor,
    this.labelPadding,
    this.padding,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.shape,
    this.showCheckmark = true,
    this.alignment = WrapAlignment.start,
    this.runAlignment = WrapAlignment.start,
    this.avatarBuilder,
  }) : super(
         builder: (FormFieldState<List<T>?> field) {
           final state = field as _JetFilterChipsState<T>;
           final currentValue = state.value ?? [];

           final chips = options.map((option) {
             final isSelected = currentValue.contains(option.value);

             return FilterChip(
               label: option.child,
               selected: isSelected,
               onSelected: option.enabled && state.enabled
                   ? (bool selected) {
                       final List<T> updatedValue = List<T>.from(currentValue);
                       if (selected) {
                         if (!updatedValue.contains(option.value)) {
                           updatedValue.add(option.value);
                         }
                       } else {
                         updatedValue.remove(option.value);
                       }
                       state.didChange(updatedValue);
                     }
                   : null,
               selectedColor: selectedColor,
               disabledColor: disabledColor,
               backgroundColor: backgroundColor,
               checkmarkColor: checkmarkColor,
               labelPadding: labelPadding,
               padding: padding,
               shape: shape,
               showCheckmark: showCheckmark,
               avatar: avatarBuilder?.call(option),
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
  JetFormFieldDecorationState<JetFilterChips<T>, List<T>> createState() =>
      _JetFilterChipsState<T>();
}

class _JetFilterChipsState<T>
    extends JetFormFieldDecorationState<JetFilterChips<T>, List<T>> {
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
