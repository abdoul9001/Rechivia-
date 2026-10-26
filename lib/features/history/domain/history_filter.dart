import 'package:rechivia/features/history/domain/history_entry.dart';

/// Filtres de l'historique.
enum HistoryFilter {
  all,
  waiting,
  answered,
  favorites;

  bool matches(HistoryEntry entry) {
    return switch (this) {
      HistoryFilter.all => true,
      HistoryFilter.waiting => entry.status == HistoryStatus.waitingForPartner,
      HistoryFilter.answered => entry.status == HistoryStatus.revealed,
      HistoryFilter.favorites => entry.isFavorite,
    };
  }
}

/// Filtres de type dans la liste des favoris.
enum FavoritesFilter {
  all,
  questions,
  conversations;

  bool matches(HistoryEntry entry) {
    return switch (this) {
      FavoritesFilter.all => true,
      FavoritesFilter.questions => entry.kind == HistoryKind.dailyQuestion,
      FavoritesFilter.conversations =>
        entry.kind == HistoryKind.guidedConversation,
    };
  }
}
