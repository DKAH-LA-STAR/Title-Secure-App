abstract class DateFormatter {
  static String formatShortDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  static String formatISO(DateTime date) {
    return date.toIso8601String();
  }
}
