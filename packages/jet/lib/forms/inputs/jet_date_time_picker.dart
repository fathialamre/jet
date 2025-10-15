import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jet/forms/core/jet_form_field_decoration.dart';

/// The type of date/time input for the picker.
enum DateTimePickerInputType {
  /// Show only date picker
  date,

  /// Show only time picker
  time,

  /// Show both date and time pickers
  both,
}

/// A date and/or time picker field.
///
/// This widget extends [JetFormFieldDecoration] and uses Material date/time pickers.
///
/// Example:
/// ```dart
/// JetDateTimePicker(
///   name: 'birthdate',
///   decoration: InputDecoration(labelText: 'Birth Date'),
///   inputType: DateTimePickerInputType.date,
///   firstDate: DateTime(1900),
///   lastDate: DateTime.now(),
/// )
/// ```
class JetDateTimePicker extends JetFormFieldDecoration<DateTime> {
  /// The type of input (date, time, or both).
  final DateTimePickerInputType inputType;

  /// The earliest selectable date.
  final DateTime? firstDate;

  /// The latest selectable date.
  final DateTime? lastDate;

  /// The format to use for displaying the date/time.
  final DateFormat? format;

  /// The locale to use for the picker.
  final Locale? locale;

  /// The initial entry mode for the date picker.
  final DatePickerEntryMode datePickerEntryMode;

  /// The initial entry mode for the time picker.
  final TimePickerEntryMode timePickerEntryMode;

  /// Text displayed when no date/time is selected.
  final String? hintText;

  /// Icon to display for the picker.
  final Widget? icon;

  /// Called when the picker is opened.
  final VoidCallback? onTap;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Creates a date/time picker field.
  JetDateTimePicker({
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
    this.inputType = DateTimePickerInputType.both,
    this.firstDate,
    this.lastDate,
    this.format,
    this.locale,
    this.datePickerEntryMode = DatePickerEntryMode.calendar,
    this.timePickerEntryMode = TimePickerEntryMode.dial,
    this.hintText,
    this.icon,
    this.onTap,
    this.readOnly = false,
  }) : super(
         builder: (FormFieldState<DateTime?> field) {
           final state = field as _JetDateTimePickerState;

           final DateFormat effectiveFormat =
               format ??
               (inputType == DateTimePickerInputType.date
                   ? DateFormat.yMd()
                   : inputType == DateTimePickerInputType.time
                   ? DateFormat.jm()
                   : DateFormat.yMd().add_jm());

           final String displayText = field.value != null
               ? effectiveFormat.format(field.value!)
               : (hintText ?? 'Select date/time');

           return InputDecorator(
             decoration: state.decoration,
             child: InkWell(
               onTap: state.enabled && !readOnly
                   ? () async {
                       onTap?.call();
                       DateTime? selectedDate = field.value;

                       if (inputType == DateTimePickerInputType.time) {
                         // Time only
                         final TimeOfDay? time = await showTimePicker(
                           context: state.context,
                           initialTime: field.value != null
                               ? TimeOfDay.fromDateTime(field.value!)
                               : TimeOfDay.now(),
                           initialEntryMode: timePickerEntryMode,
                         );
                         if (time != null) {
                           final now = DateTime.now();
                           selectedDate = DateTime(
                             now.year,
                             now.month,
                             now.day,
                             time.hour,
                             time.minute,
                           );
                         }
                       } else {
                         // Date or Date+Time
                         final DateTime? date = await showDatePicker(
                           context: state.context,
                           initialDate: field.value ?? DateTime.now(),
                           firstDate: firstDate ?? DateTime(1900),
                           lastDate: lastDate ?? DateTime(2100),
                           initialEntryMode: datePickerEntryMode,
                           locale: locale,
                         );

                         if (date != null) {
                           if (inputType == DateTimePickerInputType.both) {
                             final TimeOfDay? time = await showTimePicker(
                               context: state.context,
                               initialTime: field.value != null
                                   ? TimeOfDay.fromDateTime(field.value!)
                                   : TimeOfDay.now(),
                               initialEntryMode: timePickerEntryMode,
                             );
                             if (time != null) {
                               selectedDate = DateTime(
                                 date.year,
                                 date.month,
                                 date.day,
                                 time.hour,
                                 time.minute,
                               );
                             } else {
                               selectedDate = date;
                             }
                           } else {
                             selectedDate = date;
                           }
                         }
                       }

                       if (selectedDate != null) {
                         field.didChange(selectedDate);
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
                       Icon(
                         inputType == DateTimePickerInputType.time
                             ? Icons.access_time
                             : Icons.calendar_today,
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
  JetFormFieldDecorationState<JetDateTimePicker, DateTime> createState() =>
      _JetDateTimePickerState();
}

class _JetDateTimePickerState
    extends JetFormFieldDecorationState<JetDateTimePicker, DateTime> {}
