import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/core/widgets/app_bottom_nav_bar.dart';
import 'package:rechivia/features/history/data/fake_history_repository.dart';
import 'package:rechivia/features/history/presentation/widgets/favorite_entry_card.dart';

import '../../helpers/pump_rechivia.dart';

const _waitingQuestion = 'Qu\'est-ce qui te rend heureux(se) au quotidien ?';
const _crazyQuestion =
    'Quelle est la chose la plus folle que tu aimerais faire ensemble ?';
const _smileQuestion = 'Qu\'est-ce qui t\'a fait sourire aujourd\'hui ?';
const _dreamQuestion = 'Quel est ton plus grand rêve ?';
const _stressQuestion = 'Comment gères-tu le stress ?';
const _passedQuestion = 'Quel voyage rêves-tu de faire à deux ?';
const _partnerAnswer =
    'Oh oui ! J\'ai toujours rêvé de découvrir la Norvège. '
    'Voir les aurores boréales ensemble serait magique.';

Finder _chip(String label) => find.byKey(Key('filter-chip-$label'));

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

FakeHistoryRepository _buildRepository() => FakeHistoryRepository(
  latency: Duration.zero,
  clock: () => DateTime(2026, 10, 26, 12),
);

void main() {
  group('Historique', () {
    Future<void> openHistory(WidgetTester tester, FakeHistoryRepository repo) {
      return pumpRechivia(
        tester,
        initialLocation: AppRoutes.history,
        historyRepository: repo,
      );
    }

    testWidgets('affiche les entrées, la plus récente en premier', (
      tester,
    ) async {
      await openHistory(tester, _buildRepository());
      expect(find.text('Historique des questions'), findsOneWidget);
      expect(find.text(_waitingQuestion), findsOneWidget);
      expect(find.text(_crazyQuestion), findsOneWidget);
    });

    testWidgets('filtre les sessions en attente', (tester) async {
      await openHistory(tester, _buildRepository());
      await _tap(tester, _chip('En attente'));
      expect(find.text(_waitingQuestion), findsOneWidget);
      expect(find.text(_dreamQuestion), findsNothing);
    });

    testWidgets('filtre les sessions répondues et exclut les passées', (
      tester,
    ) async {
      await openHistory(tester, _buildRepository());
      await _tap(tester, _chip('Répondues'));
      expect(find.text(_dreamQuestion), findsOneWidget);
      expect(find.text(_waitingQuestion), findsNothing);
      expect(find.text(_passedQuestion), findsNothing);
    });

    testWidgets('filtre les favoris', (tester) async {
      await openHistory(tester, _buildRepository());
      await _tap(tester, _chip('Favoris'));
      expect(find.text(_smileQuestion), findsOneWidget);
      expect(find.text(_dreamQuestion), findsOneWidget);
      expect(find.text(_stressQuestion), findsOneWidget);
      expect(find.text(_crazyQuestion), findsNothing);
    });

    testWidgets('déplie la réponse partenaire uniquement si dévoilée', (
      tester,
    ) async {
      await openHistory(tester, _buildRepository());
      expect(find.text(_partnerAnswer), findsNothing);
      await _tap(tester, find.text(_crazyQuestion));
      expect(find.text(_partnerAnswer), findsOneWidget);
    });

    testWidgets('l’étoile ajoute l’entrée aux favoris', (tester) async {
      final repository = _buildRepository();
      await openHistory(tester, repository);
      await _tap(tester, find.byTooltip('Ajouter aux favoris').first);
      final entries = await repository.getEntries();
      expect(
        entries.firstWhere((entry) => entry.id == 'h-5').isFavorite,
        isTrue,
      );
    });

    testWidgets('affiche un état vide quand l’historique est vide', (
      tester,
    ) async {
      await openHistory(
        tester,
        FakeHistoryRepository(latency: Duration.zero, seedEntries: const []),
      );
      expect(find.text('Aucune question pour le moment'), findsOneWidget);
    });
  });

  group('Favoris', () {
    Future<void> openFavorites(
      WidgetTester tester,
      FakeHistoryRepository repo,
    ) {
      return pumpRechivia(
        tester,
        initialLocation: AppRoutes.favorites,
        historyRepository: repo,
      );
    }

    testWidgets('affiche uniquement les favoris', (tester) async {
      await openFavorites(tester, _buildRepository());
      expect(find.text('Mes favoris'), findsOneWidget);
      expect(find.byType(FavoriteEntryCard), findsNWidgets(3));
      expect(find.text(_smileQuestion), findsOneWidget);
      expect(find.text(_crazyQuestion), findsNothing);
    });

    testWidgets('filtre les conversations guidées', (tester) async {
      await openFavorites(tester, _buildRepository());
      await _tap(tester, _chip('Conversations'));
      expect(find.text(_smileQuestion), findsOneWidget);
      expect(find.text(_stressQuestion), findsOneWidget);
      expect(find.text(_dreamQuestion), findsNothing);
    });

    testWidgets('le signet retire une entrée des favoris', (tester) async {
      await openFavorites(tester, _buildRepository());
      await _tap(tester, find.byTooltip('Retirer des favoris').first);
      expect(find.byType(FavoriteEntryCard), findsNWidgets(2));
      expect(find.text(_smileQuestion), findsNothing);
    });

    testWidgets('affiche un état vide sans favoris', (tester) async {
      await openFavorites(
        tester,
        FakeHistoryRepository(latency: Duration.zero, seedEntries: const []),
      );
      expect(find.text('Pas encore de favoris'), findsOneWidget);
    });

    testWidgets('un favori ajouté dans l’historique apparaît dans Favoris', (
      tester,
    ) async {
      final repository = _buildRepository();
      await pumpRechivia(
        tester,
        initialLocation: AppRoutes.history,
        historyRepository: repository,
      );
      await _tap(tester, find.byTooltip('Ajouter aux favoris').first);
      await _tap(
        tester,
        find.descendant(
          of: find.byType(AppBottomNavBar),
          matching: find.text('Favoris'),
        ),
      );
      expect(find.byType(FavoriteEntryCard), findsNWidgets(3));
    });
  });
}
