import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/features/history/data/fake_history_repository.dart';
import 'package:rechivia/features/history/domain/history_entry.dart';
import 'package:rechivia/features/history/domain/history_exception.dart';

FakeHistoryRepository _buildRepository() {
  return FakeHistoryRepository(
    latency: Duration.zero,
    clock: () => DateTime(2026, 10, 26, 12),
  );
}

void main() {
  test('trie les entrées de la plus récente à la plus ancienne', () async {
    final entries = await _buildRepository().getEntries();
    expect(entries.map((entry) => entry.id), [
      'h-5',
      'h-1',
      'h-2',
      'h-3',
      'h-4',
      'h-6',
      'h-7',
    ]);
    expect(entries.first.date, DateTime(2026, 10, 25));
  });

  test('ne fournit le partenaire que pour les sessions dévoilées', () async {
    final entries = await _buildRepository().getEntries();
    for (final entry in entries) {
      if (entry.status != HistoryStatus.revealed) {
        expect(entry.partnerAnswer, isNull, reason: entry.id);
      }
    }
  });

  test('ajoute puis retire un favori', () async {
    final repository = _buildRepository();
    await repository.setFavorite(entryId: 'h-1', isFavorite: true);
    var entries = await repository.getEntries();
    expect(entries.firstWhere((entry) => entry.id == 'h-1').isFavorite, isTrue);

    await repository.setFavorite(entryId: 'h-1', isFavorite: false);
    entries = await repository.getEntries();
    expect(
      entries.firstWhere((entry) => entry.id == 'h-1').isFavorite,
      isFalse,
    );
  });

  test('refuse un favori sur une entrée inconnue', () async {
    await expectLater(
      _buildRepository().setFavorite(entryId: 'inconnue', isFavorite: true),
      throwsA(
        isA<HistoryException>().having(
          (error) => error.failure,
          'failure',
          HistoryFailure.unknownEntry,
        ),
      ),
    );
  });

  test('accepte un historique vide', () async {
    final repository = FakeHistoryRepository(
      latency: Duration.zero,
      seedEntries: const [],
    );
    expect(await repository.getEntries(), isEmpty);
  });
}
