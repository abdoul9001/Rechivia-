import 'package:rechivia/features/preferences/domain/theme_category.dart';

/// Étape d'une conversation guidée : question et contexte associé.
class GuidedStep {
  const GuidedStep({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
  });

  final String id;
  final String title;
  final String description;
  final ThemeCategory category;
}
