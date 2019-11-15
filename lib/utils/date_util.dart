import 'package:intl/intl.dart';

class DateUtil {
  static DateTime milliToDate(int millisecondsSinceEpoch) {
    return DateTime.fromMicrosecondsSinceEpoch(millisecondsSinceEpoch * 1000);
  }

  static String dateToString(DateTime date, String format) {
    return DateFormat(format).format(date);
  }

  static String milliToString(int millisecondsSinceEpoch, String format) {
    return DateFormat(format)
        .format(DateUtil.milliToDate(millisecondsSinceEpoch));
  }

  static DateTime date(
      {int year,
      int month,
      int day,
      int hour = 0,
      int minute = 0,
      int second = 0}) {
    final date = DateTime(year, month, day, hour, minute, second);
    return date.add(date.timeZoneOffset).toUtc();
  }

  static DateTime dateOfFirstDay(int year, int month) {
    final date = DateTime(year, month, 1);
    return date.add(date.timeZoneOffset).toUtc();
  }

  static DateTime dateOfLastDay(int year, int month) {
    final date = DateTime(year, month + 1, 0);
    return date.add(date.timeZoneOffset).toUtc();
  }

  static DateTime dateOfNowStartTime() {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day, 0);
    return date.add(date.timeZoneOffset).toUtc();
  }

  static DateTime dateOfNowEndTime() {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day + 1, 0);
    return date.add(date.timeZoneOffset).toUtc();
  }
}
