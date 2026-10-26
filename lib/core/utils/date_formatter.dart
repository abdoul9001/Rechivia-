/// Mise en forme des dates en français, sans dépendance externe.
abstract final class DateFormatter {
  static const List<String> _months = [
    'janv.',
    'févr.',
    'mars',
    'avr.',
    'mai',
    'juin',
    'juil.',
    'août',
    'sept.',
    'oct.',
    'nov.',
    'déc.',
  ];

  /// Date courte, par exemple « 26 oct. 2026 ».
  static String shortDate(DateTime date) {
    final local = date.toLocal();
    return '${local.day} ${_months[local.month - 1]} ${local.year}';
  }

  /// Heure au format 24 h.
  static String time(DateTime date) {
    final local = date.toLocal();
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${twoDigits(local.hour)}:${twoDigits(local.minute)}';
  }

  /// Date et heure, par exemple « 26 oct. 2026 à 09:05 ».
  static String shortDateTime(DateTime date) {
    return '${shortDate(date)} à ${time(date)}';
  }
}
