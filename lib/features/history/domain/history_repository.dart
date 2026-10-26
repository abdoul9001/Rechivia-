import 'package:rechivia/features/history/domain/history_entry.dart';

/// Contrat de lecture de l'historique et de gestion des favoris.
abstract interface class HistoryRepository {
  Future<List<HistoryEntry>> getEntries();

  Future<void> setFavorite({required String entryId, required bool isFavorite});
}
