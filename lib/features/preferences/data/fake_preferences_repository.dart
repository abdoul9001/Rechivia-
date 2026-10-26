import 'package:rechivia/features/preferences/domain/preferences_repository.dart';
import 'package:rechivia/features/preferences/domain/theme_category.dart';

/// Implémentation factice de [PreferencesRepository], gardée en mémoire.
class FakePreferencesRepository implements PreferencesRepository {
  FakePreferencesRepository({this.latency = const Duration(milliseconds: 400)});

  /// Délai simulé d'un appel réseau (mis à zéro dans les tests).
  final Duration latency;

  Set<ThemeCategory> _savedThemes = {};

  /// Thèmes actuellement enregistrés (lecture seule, utile aux tests).
  Set<ThemeCategory> get savedThemes => Set.unmodifiable(_savedThemes);

  @override
  Future<void> saveSelectedThemes(Set<ThemeCategory> themes) async {
    await Future<void>.delayed(latency);
    _savedThemes = {...themes};
  }
}
