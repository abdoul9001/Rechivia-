import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rechivia/features/preferences/data/fake_preferences_repository.dart';
import 'package:rechivia/features/preferences/domain/preferences_repository.dart';

/// Fournit le dépôt des préférences à toute l'application.
final preferencesRepositoryProvider = Provider<PreferencesRepository>(
  (ref) => FakePreferencesRepository(),
);
