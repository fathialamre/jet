import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jet/forms/core/jet_form_field_decoration.dart';
import 'package:jet/forms/inputs/jet_slider.dart';

/// A range slider field for selecting a range of numerical values.
///
/// This widget extends [JetFormFieldDecoration] and wraps [RangeSlider].
///
/// Example:
/// ```dart
/// JetRangeSlider(
///   name: 'price_range',
///   decoration: InputDecoration(labelText: 'Price Range'),
///   initialValue: RangeValues(20.0, 80.0),
///   min: 0.0,
///   max: 100.0,
///   divisions: 100,
/// )
/// ```
class JetRangeSlider extends JetFormFieldDecoration<RangeValues> {
  /// Called when the user starts selecting new values for the slider.
  final ValueChanged<RangeValues>? onChangeStart;

  /// Called when the user is done selecting new values for the slider.
  final ValueChanged<RangeValues>? onChangeEnd;

  /// The minimum value the user can select.
  final double min;

  /// The maximum value the user can select.
  final double max;

  /// The number of discrete divisions.
  final int? divisions;

  /// Labels to show above the slider when the slider is active.
  final RangeLabels? labels;

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

  /// An alternative widget to display the current start value.
  final Widget Function(String value)? startValueWidget;

  /// An alternative widget to display the current end value.
  final Widget Function(String value)? endValueWidget;

  /// An alternative widget to display the maximum value.
  final Widget Function(String max)? maxValueWidget;

  /// Number format for displaying values.
  final NumberFormat? numberFormat;

  /// Controls which values are displayed below the slider.
  final SliderDisplayValues displayValues;

  /// Creates a range slider field.
  JetRangeSlider({
    super.key,
    required super.name,
    super.validator,
    required RangeValues super.initialValue,
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
    this.labels,
    this.semanticFormatterCallback,
    this.numberFormat,
    this.displayValues = SliderDisplayValues.all,
    this.autofocus = false,
    this.mouseCursor,
    this.maxValueWidget,
    this.minValueWidget,
    this.startValueWidget,
    this.endValueWidget,
  }) : super(
         builder: (FormFieldState<RangeValues?> field) {
           final state = field as _JetRangeSliderState;
           final effectiveNumberFormat = numberFormat ?? NumberFormat.compact();

           return Focus(
             focusNode: state.effectiveFocusNode,
             child: InputDecorator(
               decoration: state.decoration,
               child: Container(
                 padding: const EdgeInsets.only(top: 10.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     RangeSlider(
                       values: field.value!,
                       min: min,
                       max: max,
                       divisions: divisions,
                       activeColor: activeColor,
                       inactiveColor: inactiveColor,
                       onChangeEnd: onChangeEnd,
                       onChangeStart: onChangeStart,
                       labels: labels,
                       onChanged: state.enabled
                           ? (value) {
                               field.didChange(value);
                             }
                           : null,
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
                           startValueWidget?.call(
                                 effectiveNumberFormat.format(
                                   field.value!.start,
                                 ),
                               ) ??
                               Text(
                                 effectiveNumberFormat.format(
                                   field.value!.start,
                                 ),
                               ),
                         const SizedBox(width: 8),
                         if (displayValues != SliderDisplayValues.none &&
                             displayValues != SliderDisplayValues.minMax)
                           endValueWidget?.call(
                                 effectiveNumberFormat.format(field.value!.end),
                               ) ??
                               Text(
                                 effectiveNumberFormat.format(field.value!.end),
                               ),
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
             ),
           );
         },
       );

  @override
  JetFormFieldDecorationState<JetRangeSlider, RangeValues> createState() =>
      _JetRangeSliderState();
}

class _JetRangeSliderState
    extends JetFormFieldDecorationState<JetRangeSlider, RangeValues> {}
