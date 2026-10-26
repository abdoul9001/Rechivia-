import 'package:rechivia/features/preferences/domain/theme_category.dart';

/// Contrat de gestion des préférences de l'utilisateur.
abstract interface class PreferencesRepository {
  /// Enregistre les thèmes choisis, en remplaçant les précédents.
  Future<void> saveSelectedThemes(Set<ThemeCategory> themes);
}
