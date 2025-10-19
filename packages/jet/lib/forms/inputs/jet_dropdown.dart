import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jet/forms/core/jet_form_field_decoration.dart';
import 'package:jet/forms/core/jet_form_option.dart';

/// A dropdown field for Jet forms.
///
/// This widget extends [JetFormFieldDecoration] and wraps [DropdownButton].
///
/// Example:
/// ```dart
/// JetDropdown<String>(
///   name: 'country',
///   decoration: InputDecoration(labelText: 'Country'),
///   options: [
///     JetFormOption(value: 'us', child: Text('United States')),
///     JetFormOption(value: 'uk', child: Text('United Kingdom')),
///     JetFormOption(value: 'ca', child: Text('Canada')),
///   ],
/// )
/// ```
class JetDropdown<T> extends JetFormFieldDecoration<T> {
  /// The list of options the user can select from.
  final List<JetFormOption<T>> options;

  /// A message to show when the dropdown is disabled.
  final Widget? disabledHint;

  /// Called when the dropdown button is tapped.
  final VoidCallback? onTap;

  /// A builder to customize the dropdown buttons corresponding to the options.
  final DropdownButtonBuilder? selectedItemBuilder;

  /// The z-coordinate at which to place the menu when open.
  final int elevation;

  /// The text style to use for text in the dropdown button and menu.
  final TextStyle? style;

  /// The widget to use for the drop-down button's icon.
  final Widget? icon;

  /// The color of the icon if this button is disabled.
  final Color? iconDisabledColor;

  /// The color of the icon if this button is enabled.
  final Color? iconEnabledColor;

  /// The size to use for the drop-down button's down arrow icon button.
  final double iconSize;

  /// Reduce the button's height.
  final bool isDense;

  /// Set the dropdown's inner contents to horizontally fill its parent.
  final bool isExpanded;

  /// Whether this text field should focus itself if nothing else is already
  /// focused.
  final bool autofocus;

  /// The background color of the dropdown.
  final Color? dropdownColor;

  /// The color for the button's [Material] when it has the input focus.
  final Color? focusColor;

  /// Defines the default menu item's height.
  final double? itemHeight;

  /// The maximum height of the menu.
  final double? menuMaxHeight;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  final bool? enableFeedback;

  /// Defines how the hint or the selected item is positioned within the button.
  final AlignmentGeometry alignment;

  /// Defines the corner radii of the menu's rounded rectangle shape.
  final BorderRadius? borderRadius;

  /// A placeholder widget that is displayed by the dropdown button.
  final Widget? hint;

  /// The widget to use for drawing the drop-down button's underline.
  final Widget? underline;

  /// The inner padding of the dropdown button.
  final EdgeInsetsGeometry? padding;

  /// Defines the menu's width.
  final double? menuWidth;

  /// Creates a dropdown field.
  JetDropdown({
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
    this.isExpanded = true,
    this.isDense = true,
    this.elevation = 8,
    this.iconSize = 24.0,
    this.style,
    this.disabledHint,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.onTap,
    this.autofocus = false,
    this.dropdownColor,
    this.focusColor,
    this.itemHeight,
    this.selectedItemBuilder,
    this.menuMaxHeight,
    this.enableFeedback,
    this.borderRadius,
    this.alignment = AlignmentDirectional.centerStart,
    this.hint,
    this.underline = const SizedBox.shrink(),
    this.padding,
    this.menuWidth,
  }) : super(
         builder: (FormFieldState<T?> field) {
           final state = field as _JetDropdownState<T>;

           // Convert options to DropdownMenuItem
           final items = options
               .map(
                 (option) => DropdownMenuItem<T>(
                   value: option.value,
                   enabled: option.enabled,
                   child: option.child,
                 ),
               )
               .toList();

           final hasValue = options.map((e) => e.value).contains(field.value);

           return InputDecorator(
             decoration: state.decoration,
             isEmpty: !hasValue,
             child: DropdownButton<T>(
               menuWidth: menuWidth,
               padding: padding,
               underline: underline,
               isExpanded: isExpanded,
               items: items,
               value: hasValue ? field.value : null,
               style: style,
               isDense: isDense,
               disabledHint: hasValue
                   ? items
                         .firstWhere(
                           (dropDownItem) => dropDownItem.value == field.value,
                         )
                         .child
                   : disabledHint,
               elevation: elevation,
               iconSize: iconSize,
               icon: icon,
               iconDisabledColor: iconDisabledColor,
               iconEnabledColor: iconEnabledColor,
               onChanged: state.enabled
                   ? (T? value) {
                       field.didChange(value);
                     }
                   : null,
               onTap: onTap,
               focusNode: state.effectiveFocusNode,
               autofocus: autofocus,
               dropdownColor: dropdownColor,
               focusColor: focusColor,
               itemHeight: itemHeight,
               selectedItemBuilder: selectedItemBuilder,
               menuMaxHeight: menuMaxHeight,
               borderRadius: borderRadius,
               enableFeedback: enableFeedback,
               alignment: alignment,
               hint: hint,
             ),
           );
         },
       );

  @override
  JetFormFieldDecorationState<JetDropdown<T>, T> createState() =>
      _JetDropdownState<T>();
}

class _JetDropdownState<T>
    extends JetFormFieldDecorationState<JetDropdown<T>, T> {
  @override
  void didUpdateWidget(covariant JetDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only perform expensive comparisons if list length changed or object identity changed
    // This is much faster than toString() conversion and listEquals()
    if (oldWidget.options.length != widget.options.length ||
        !identical(oldWidget.options, widget.options)) {
      // Extract current values once (avoid repeated map operations)
      final currentValues = widget.options.map((e) => e.value).toSet();

      // Reset value if initialValue is not in the current options
      if (initialValue != null && !currentValues.contains(initialValue)) {
        setValue(null);
        return;
      }

      // Only compare values if we need to update (initial value is still valid)
      if (currentValues.contains(initialValue) || initialValue == null) {
        // Extract old values once and cache for comparison
        final oldValues = oldWidget.options.map((e) => e.value).toSet();

        // Only update if options actually changed
        // Use Set operations which are O(n) instead of O(n²)
        if (oldValues.length != currentValues.length ||
            !_setsEqual(oldValues, currentValues)) {
          setValue(initialValue);
        }
      }
    }
  }

  /// Efficiently compare two sets for equality
  /// Uses Set.difference which is optimized for set operations
  bool _setsEqual(Set<T> a, Set<T> b) {
    if (a.length != b.length) return false;
    return a.difference(b).isEmpty;
  }
}
