import 'package:rechivia/features/preferences/domain/theme_category.dart';

/// Question proposée au couple pour une journée donnée.
class DailyQuestion {
  const DailyQuestion({
    required this.id,
    required this.text,
    required this.category,
    required this.date,
  });

  /// Identifiant stable dans la bibliothèque de questions.
  final String id;

  final String text;

  final ThemeCategory category;

  /// Jour concerné, sans heure.
  final DateTime date;
}
