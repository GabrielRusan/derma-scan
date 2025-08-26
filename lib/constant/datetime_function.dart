import 'package:intl/intl.dart';

String customDateTimeFormatter(DateTime dateTime) {
  // Format hari dalam Bahasa Indonesia
  String dayName = DateFormat.EEEE('id_ID').format(dateTime); // Senin
  String datePart = DateFormat(
    'd MMMM yyyy',
    'id_ID',
  ).format(dateTime); // 24 Januari 2025
  String timePart = DateFormat('HH.mm', 'id_ID').format(dateTime); // 15.00

  String zona = getIndonesianTimeZone(dateTime);

  String finalText = '$dayName, $datePart | $timePart $zona';

  return finalText;
}

String getIndonesianTimeZone(DateTime dateTime) {
  final offset = dateTime.timeZoneOffset;

  if (offset == Duration(hours: 7)) {
    return 'WIB';
  } else if (offset == Duration(hours: 8)) {
    return 'WITA';
  } else if (offset == Duration(hours: 9)) {
    return 'WIT';
  } else {
    return 'Luar Indonesia';
  }
}
