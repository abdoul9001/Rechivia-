import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/features/history/domain/history_entry.dart';
import 'package:rechivia/features/history/domain/history_filter.dart';

HistoryEntry _entry({
  HistoryKind kind = HistoryKind.dailyQuestion,
  HistoryStatus status = HistoryStatus.waitingForPartner,
  String? myAnswer = 'Ma réponse',
  String? partnerAnswer,
  bool isFavorite = false,
}) {
  return HistoryEntry(
    id: 'e1',
    kind: kind,
    date: DateTime(2026, 10, 1),
    questionText: 'Question ?',
    status: status,
    myAnswer: myAnswer,
    partnerAnswer: partnerAnswer,
    isFavorite: isFavorite,
  );
}

void main() {
  group('HistoryEntry', () {
    test('refuse la réponse partenaire si la session n’est pas dévoilée', () {
      expect(
        () => _entry(partnerAnswer: 'Réponse privée'),
        throwsAssertionError,
      );
    });

    test('refuse une session dévoilée sans réponse de l’utilisateur', () {
      expect(
        () => _entry(status: HistoryStatus.revealed, myAnswer: null),
        throwsAssertionError,
      );
    });

    test('accepte une session dévoilée avec les deux réponses', () {
      final entry = _entry(
        status: HistoryStatus.revealed,
        partnerAnswer: 'La sienne',
      );
      expect(entry.partnerAnswer, 'La sienne');
    });

    test('copyWith ne change que le favori', () {
      final entry = _entry();
      final favorite = entry.copyWith(isFavorite: true);
      expect(favorite.isFavorite, isTrue);
      expect(favorite.id, entry.id);
      expect(favorite.myAnswer, entry.myAnswer);
    });
  });

  group('HistoryFilter', () {
    test('En attente sélectionne uniquement les sessions en attente', () {
      expect(HistoryFilter.waiting.matches(_entry()), isTrue);
      expect(
        HistoryFilter.waiting.matches(
          _entry(status: HistoryStatus.passed, myAnswer: null),
        ),
        isFalse,
      );
    });

    test('Répondues sélectionne uniquement les sessions dévoilées', () {
      final revealed = _entry(
        status: HistoryStatus.revealed,
        partnerAnswer: 'La sienne',
      );
      expect(HistoryFilter.answered.matches(revealed), isTrue);
      expect(HistoryFilter.answered.matches(_entry()), isFalse);
    });

    test('Favoris sélectionne uniquement les favoris', () {
      expect(HistoryFilter.favorites.matches(_entry(isFavorite: true)), isTrue);
      expect(HistoryFilter.favorites.matches(_entry()), isFalse);
    });
  });

  test('FavoritesFilter sépare les questions des conversations guidées', () {
    final question = _entry();
    final conversation = _entry(kind: HistoryKind.guidedConversation);
    expect(FavoritesFilter.questions.matches(question), isTrue);
    expect(FavoritesFilter.questions.matches(conversation), isFalse);
    expect(FavoritesFilter.conversations.matches(conversation), isTrue);
    expect(FavoritesFilter.conversations.matches(question), isFalse);
    expect(FavoritesFilter.all.matches(question), isTrue);
  });
}
