import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jet/forms/core/jet_form_field_decoration.dart';

/// Enum to control which values are displayed for the slider
enum SliderDisplayValues {
  /// Display all values (min, current, max)
  all,

  /// Display only current value
  current,

  /// Display only min and max values
  minMax,

  /// Display no values
  none,
}

/// A slider field for numerical value selection.
///
/// This widget extends [JetFormFieldDecoration] and wraps [Slider].
///
/// Example:
/// ```dart
/// JetSlider(
///   name: 'volume',
///   decoration: InputDecoration(labelText: 'Volume'),
///   initialValue: 50.0,
///   min: 0.0,
///   max: 100.0,
///   divisions: 100,
/// )
/// ```
class JetSlider extends JetFormFieldDecoration<double> {
  /// Called when the user starts selecting a new value for the slider.
  final ValueChanged<double>? onChangeStart;

  /// Called when the user is done selecting a new value for the slider.
  final ValueChanged<double>? onChangeEnd;

  /// The minimum value the user can select.
  final double min;

  /// The maximum value the user can select.
  final double max;

  /// The number of discrete divisions.
  final int? divisions;

  /// A label to show above the slider when the slider is active.
  final String? label;

  /// The color to use for the portion of the slider track that is active.
  final Color? activeColor;

  /// The color for the inactive portion of the slider track.
  final Color? inactiveColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// widget.
  final MouseCursor? mouseCursor;

  /// The callback used to create a semantic value from a slider value.
  final SemanticFormatterCallback? semanticFormatterCallback;

  /// Whether this text field should focus itself if nothing else is already
  /// focused.
  final bool autofocus;

  /// An alternative widget to display the minimum value.
  final Widget Function(String min)? minValueWidget;

  /// An alternative widget to display the current value.
  final Widget Function(String value)? valueWidget;

  /// An alternative widget to display the maximum value.
  final Widget Function(String max)? maxValueWidget;

  /// Number format for displaying values.
  final NumberFormat? numberFormat;

  /// Controls which values are displayed below the slider.
  final SliderDisplayValues displayValues;

  /// Creates a slider field for numerical value selection.
  JetSlider({
    super.key,
    required super.name,
    super.validator,
    required double super.initialValue,
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
    required this.min,
    required this.max,
    this.divisions,
    this.activeColor,
    this.inactiveColor,
    this.onChangeStart,
    this.onChangeEnd,
    this.label,
    this.semanticFormatterCallback,
    this.numberFormat,
    this.displayValues = SliderDisplayValues.all,
    this.autofocus = false,
    this.mouseCursor,
    this.maxValueWidget,
    this.minValueWidget,
    this.valueWidget,
  }) : super(
         builder: (FormFieldState<double?> field) {
           final state = field as _JetSliderState;
           final effectiveNumberFormat = numberFormat ?? NumberFormat.compact();

           return InputDecorator(
             decoration: state.decoration,
             child: Container(
               padding: const EdgeInsets.only(top: 10.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Slider(
                     value: field.value!,
                     min: min,
                     max: max,
                     divisions: divisions,
                     activeColor: activeColor,
                     inactiveColor: inactiveColor,
                     onChangeEnd: onChangeEnd,
                     onChangeStart: onChangeStart,
                     label: label,
                     semanticFormatterCallback: semanticFormatterCallback,
                     onChanged: state.enabled
                         ? (value) {
                             field.didChange(value);
                           }
                         : null,
                     autofocus: autofocus,
                     mouseCursor: mouseCursor,
                     focusNode: state.effectiveFocusNode,
                   ),
                   Row(
                     children: <Widget>[
                       if (displayValues != SliderDisplayValues.none &&
                           displayValues != SliderDisplayValues.current)
                         minValueWidget?.call(
                               effectiveNumberFormat.format(min),
                             ) ??
                             Text(effectiveNumberFormat.format(min)),
                       const Spacer(),
                       if (displayValues != SliderDisplayValues.none &&
                           displayValues != SliderDisplayValues.minMax)
                         valueWidget?.call(
                               effectiveNumberFormat.format(field.value),
                             ) ??
                             Text(effectiveNumberFormat.format(field.value)),
                       const Spacer(),
                       if (displayValues != SliderDisplayValues.none &&
                           displayValues != SliderDisplayValues.current)
                         maxValueWidget?.call(
                               effectiveNumberFormat.format(max),
                             ) ??
                             Text(effectiveNumberFormat.format(max)),
                     ],
                   ),
                 ],
               ),
             ),
           );
         },
       );

  @override
  JetFormFieldDecorationState<JetSlider, double> createState() =>
      _JetSliderState();
}

class _JetSliderState extends JetFormFieldDecorationState<JetSlider, double> {}
