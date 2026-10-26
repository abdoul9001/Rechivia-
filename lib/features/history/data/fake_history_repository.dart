import 'package:rechivia/core/data/simulated_latency.dart';
import 'package:rechivia/features/history/domain/history_entry.dart';
import 'package:rechivia/features/history/domain/history_exception.dart';
import 'package:rechivia/features/history/domain/history_repository.dart';

/// Historique d'exemple en mémoire, indépendant des autres dépôts factices.
class FakeHistoryRepository implements HistoryRepository {
  FakeHistoryRepository({
    this.latency = const Duration(milliseconds: 400),
    List<HistoryEntry>? seedEntries,
    DateTime Function()? clock,
  }) : _entries = List.of(
         seedEntries ?? _defaultEntries((clock ?? DateTime.now)()),
       );

  final Duration latency;
  final List<HistoryEntry> _entries;

  @override
  Future<List<HistoryEntry>> getEntries() async {
    await simulateLatency(latency);
    final sorted = [..._entries]..sort((a, b) => b.date.compareTo(a.date));
    return List.unmodifiable(sorted);
  }

  @override
  Future<void> setFavorite({
    required String entryId,
    required bool isFavorite,
  }) async {
    await simulateLatency(latency);
    final index = _entries.indexWhere((entry) => entry.id == entryId);
    if (index == -1) {
      throw const HistoryException(HistoryFailure.unknownEntry);
    }
    _entries[index] = _entries[index].copyWith(isFavorite: isFavorite);
  }

  static List<HistoryEntry> _defaultEntries(DateTime now) {
    DateTime daysAgo(int days) => DateTime(now.year, now.month, now.day - days);

    return [
      HistoryEntry(
        id: 'h-5',
        kind: HistoryKind.dailyQuestion,
        date: daysAgo(1),
        questionText: 'Qu\'est-ce qui te rend heureux(se) au quotidien ?',
        status: HistoryStatus.waitingForPartner,
        myAnswer: 'Les petites attentions, même les plus simples.',
      ),
      HistoryEntry(
        id: 'h-1',
        kind: HistoryKind.dailyQuestion,
        date: daysAgo(2),
        questionText:
            'Quelle est la chose la plus folle que tu aimerais '
            'faire ensemble ?',
        status: HistoryStatus.revealed,
        myAnswer:
            'J\'aimerais faire un voyage en montagne, prendre un petit '
            'chalet et juste profiter de la nature, toi et moi.',
        partnerAnswer:
            'Oh oui ! J\'ai toujours rêvé de découvrir la Norvège. '
            'Voir les aurores boréales ensemble serait magique.',
      ),
      HistoryEntry(
        id: 'h-2',
        kind: HistoryKind.guidedConversation,
        date: daysAgo(4),
        questionText: 'Qu\'est-ce qui t\'a fait sourire aujourd\'hui ?',
        status: HistoryStatus.revealed,
        myAnswer: 'Ton message ce matin, ça m\'a fait une belle surprise.',
        partnerAnswer: 'Notre petite balade d\'hier soir.',
        isFavorite: true,
      ),
      HistoryEntry(
        id: 'h-3',
        kind: HistoryKind.dailyQuestion,
        date: daysAgo(6),
        questionText: 'Quel est ton plus grand rêve ?',
        status: HistoryStatus.revealed,
        myAnswer: 'Construire notre maison et fonder une famille.',
        partnerAnswer: 'Voyager avec toi autour du monde.',
        isFavorite: true,
      ),
      HistoryEntry(
        id: 'h-4',
        kind: HistoryKind.guidedConversation,
        date: daysAgo(8),
        questionText: 'Comment gères-tu le stress ?',
        status: HistoryStatus.revealed,
        myAnswer: 'Je respire, je me recentre et je pense à toi.',
        partnerAnswer: 'Je marche un peu pour me vider la tête.',
        isFavorite: true,
      ),
      HistoryEntry(
        id: 'h-6',
        kind: HistoryKind.dailyQuestion,
        date: daysAgo(10),
        questionText: 'Quel voyage rêves-tu de faire à deux ?',
        status: HistoryStatus.passed,
      ),
      HistoryEntry(
        id: 'h-7',
        kind: HistoryKind.dailyQuestion,
        date: daysAgo(12),
        questionText: 'Quel est ton plus beau souvenir de nous ?',
        status: HistoryStatus.expired,
      ),
    ];
  }
}
