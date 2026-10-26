import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rechivia/features/preferences/domain/theme_category.dart';
import 'package:rechivia/features/preferences/presentation/providers/preferences_providers.dart';

/// État de l'écran de choix des thèmes.
@immutable
class ThemeSelectionState {
  const ThemeSelectionState({this.selected = const {}, this.isSaving = false});

  /// Thèmes actuellement cochés.
  final Set<ThemeCategory> selected;

  /// Vrai pendant l'enregistrement.
  final bool isSaving;

  /// On ne peut continuer qu'avec au moins un thème, hors enregistrement.
  bool get canContinue => selected.isNotEmpty && !isSaving;

  ThemeSelectionState copyWith({Set<ThemeCategory>? selected, bool? isSaving}) {
    return ThemeSelectionState(
      selected: selected ?? this.selected,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

/// Gère la sélection des thèmes et leur enregistrement.
class ThemeSelectionController extends Notifier<ThemeSelectionState> {
  @override
  ThemeSelectionState build() => const ThemeSelectionState();

  /// Coche la catégorie si elle ne l'est pas, la décoche sinon.
  void toggle(ThemeCategory category) {
    if (state.isSaving) return;

    final updated = {...state.selected};
    if (!updated.add(category)) updated.remove(category);
    state = state.copyWith(selected: updated);
  }

  /// Enregistre la sélection. Retourne `true` en cas de succès.
  Future<bool> save() async {
    if (!state.canContinue) return false;

    state = state.copyWith(isSaving: true);
    try {
      await ref
          .read(preferencesRepositoryProvider)
          .saveSelectedThemes(state.selected);
      return true;
    } on Object {
      return false;
    } finally {
      if (ref.mounted) state = state.copyWith(isSaving: false);
    }
  }
}

/// `autoDispose` : la sélection repart de zéro quand l'écran est quitté.
final themeSelectionControllerProvider =
    NotifierProvider.autoDispose<ThemeSelectionController, ThemeSelectionState>(
      ThemeSelectionController.new,
    );
