import 'package:intl/intl.dart';

String getTime(int minutes) {
  int hours = minutes ~/ 60;
  int remainingMinutes = minutes % 60;
  return DateFormat('HH:mm').format(DateTime(0, 1, 1, hours, remainingMinutes));
}
