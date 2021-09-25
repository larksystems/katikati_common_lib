import 'package:intl/intl.dart';

String dateStringForSeparator(DateTime dateTime) {
  if (dateTime == null) {
    return '';
  }

  final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final differenceDays = today.difference(date).inDays;
  final DateFormat formatter = DateFormat('MMM yyyy');

  if (differenceDays < 1) {
    return "Today";
  } else if (differenceDays == 1) {
    return "Yesterday";
  } else {
    return formatter.format(dateTime);
  }
}
