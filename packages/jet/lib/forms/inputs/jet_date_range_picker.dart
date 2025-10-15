import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jet/forms/core/jet_form_field_decoration.dart';

/// A date range picker field.
///
/// This widget extends [JetFormFieldDecoration] and uses Material date range picker.
///
/// Example:
/// ```dart
/// JetDateRangePicker(
///   name: 'trip_dates',
///   decoration: InputDecoration(labelText: 'Trip Dates'),
///   firstDate: DateTime.now(),
///   lastDate: DateTime.now().add(Duration(days: 365)),
/// )
/// ```
class JetDateRangePicker extends JetFormFieldDecoration<DateTimeRange> {
  /// The earliest selectable date.
  final DateTime firstDate;

  /// The latest selectable date.
  final DateTime lastDate;

  /// The format to use for displaying dates.
  final DateFormat? format;

  /// The locale to use for the picker.
  final Locale? locale;

  /// The initial entry mode for the date picker.
  final DatePickerEntryMode datePickerEntryMode;

  /// Text displayed when no date range is selected.
  final String? hintText;

  /// Icon to display for the picker.
  final Widget? icon;

  /// Called when the picker is opened.
  final VoidCallback? onTap;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Text to display between start and end dates.
  final String separator;

  /// The help text displayed at the top of the dialog.
  final String? helpText;

  /// The label for the start date field.
  final String? fieldStartLabelText;

  /// The label for the end date field.
  final String? fieldEndLabelText;

  /// Creates a date range picker field.
  JetDateRangePicker({
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
    required this.firstDate,
    required this.lastDate,
    this.format,
    this.locale,
    this.datePickerEntryMode = DatePickerEntryMode.calendar,
    this.hintText,
    this.icon,
    this.onTap,
    this.readOnly = false,
    this.separator = ' - ',
    this.helpText,
    this.fieldStartLabelText,
    this.fieldEndLabelText,
  }) : super(
         builder: (FormFieldState<DateTimeRange?> field) {
           final state = field as _JetDateRangePickerState;

           final DateFormat effectiveFormat = format ?? DateFormat.yMd();

           final String displayText = field.value != null
               ? '${effectiveFormat.format(field.value!.start)}$separator${effectiveFormat.format(field.value!.end)}'
               : (hintText ?? 'Select date range');

           return InputDecorator(
             decoration: state.decoration,
             child: InkWell(
               onTap: state.enabled && !readOnly
                   ? () async {
                       onTap?.call();

                       final DateTimeRange? selectedRange =
                           await showDateRangePicker(
                             context: state.context,
                             firstDate: firstDate,
                             lastDate: lastDate,
                             initialDateRange: field.value,
                             initialEntryMode: datePickerEntryMode,
                             locale: locale,
                             helpText: helpText,
                             fieldStartLabelText: fieldStartLabelText,
                             fieldEndLabelText: fieldEndLabelText,
                           );

                       if (selectedRange != null) {
                         field.didChange(selectedRange);
                       }
                     }
                   : null,
               child: InputDecorator(
                 decoration: const InputDecoration(
                   border: InputBorder.none,
                   contentPadding: EdgeInsets.zero,
                 ),
                 child: Row(
                   children: [
                     Expanded(
                       child: Text(
                         displayText,
                         style: field.value != null
                             ? null
                             : TextStyle(
                                 color: Theme.of(state.context).hintColor,
                               ),
                       ),
                     ),
                     if (icon != null)
                       icon!
                     else
                       const Icon(
                         Icons.date_range,
                         size: 20,
                       ),
                   ],
                 ),
               ),
             ),
           );
         },
       );

  @override
  JetFormFieldDecorationState<JetDateRangePicker, DateTimeRange>
  createState() => _JetDateRangePickerState();
}

class _JetDateRangePickerState
    extends JetFormFieldDecorationState<JetDateRangePicker, DateTimeRange> {}
