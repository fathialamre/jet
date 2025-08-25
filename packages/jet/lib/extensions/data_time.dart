import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String formattedDate({String format = 'dd/MM/yyyy'}) {
    return DateFormat(format).format(this);
  }

  String formattedTime({String format = 'HH:mm'}) {
    return DateFormat(format).format(this);
  }

  String formattedDateTime({String format = 'dd/MM/yyyy HH:mm'}) {
    return DateFormat(format).format(this);
  }
}
