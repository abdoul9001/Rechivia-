import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/features/daily_question/data/fake_daily_question_repository.dart';
import 'package:rechivia/features/guided_conversation/data/fake_guided_conversation_repository.dart';
import 'package:rechivia/features/guided_conversation/presentation/screens/guided_conversation_screen.dart';

import '../../helpers/pump_rechivia.dart';

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _answer(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(TextFormField), text);
  await _tap(tester, find.text('Partager ma réponse'));
}

void main() {
  late FakeGuidedConversationRepository repository;

  setUp(() {
    repository = FakeGuidedConversationRepository(
      latency: Duration.zero,
      partnerReplyDelay: null,
    );
  });

  Future<void> openScreen(WidgetTester tester) {
    return pumpRechivia(
      tester,
      initialLocation: AppRoutes.guidedConversation,
      guidedConversationRepository: repository,
    );
  }

  testWidgets('affiche la première étape', (tester) async {
    final first = (await repository.getConversation()).entries.first.step;
    await openScreen(tester);

    expect(find.text('Conversation guidée'), findsOneWidget);
    expect(find.text('Étape 1 / 5'), findsOneWidget);
    expect(find.text(first.title), findsOneWidget);
  });

  testWidgets('répondre affiche la suivante avec un champ vide', (
    tester,
  ) async {
    final entries = (await repository.getConversation()).entries;
    await openScreen(tester);

    await _answer(tester, 'Un grand sourire');

    expect(find.text('Étape 2 / 5'), findsOneWidget);
    expect(find.text(entries[1].step.title), findsOneWidget);
    expect(find.text('Un grand sourire'), findsNothing);
  });

  testWidgets('refuse une réponse vide', (tester) async {
    await openScreen(tester);
    await _tap(tester, find.text('Partager ma réponse'));

    expect(
      find.text('Écrivez votre réponse avant de la partager.'),
      findsOneWidget,
    );
    expect(find.text('Étape 1 / 5'), findsOneWidget);
  });

  testWidgets('passer une étape avance sans confirmation', (tester) async {
    await openScreen(tester);
    await _tap(tester, find.text('Passer cette étape'));
    expect(find.text('Étape 2 / 5'), findsOneWidget);
  });

  testWidgets('terminer affiche le récapitulatif en attente', (tester) async {
    await openScreen(tester);
    await _answer(tester, 'Réponse 1');
    await _answer(tester, 'Réponse 2');
    await _tap(tester, find.text('Passer cette étape'));
    await _answer(tester, 'Réponse 4');
    await _answer(tester, 'Réponse 5');

    expect(find.text('Bravo, vous avez terminé !'), findsOneWidget);
    expect(find.text('Réponse 1'), findsOneWidget);
    expect(find.text('Étape passée'), findsOneWidget);
    expect(find.text('Actualiser'), findsOneWidget);
  });

  testWidgets('actualiser dévoile les réponses du partenaire', (tester) async {
    await openScreen(tester);
    for (var i = 1; i <= 5; i++) {
      await _answer(tester, 'Ma réponse $i');
    }
    repository.simulatePartnerCompletion(answers: {'step-1': 'Sa réponse 1'});
    await _tap(tester, find.text('Actualiser'));

    expect(find.text('Conversation terminée !'), findsOneWidget);
    expect(find.text('Sa réponse 1'), findsOneWidget);
    expect(find.text('A passé cette étape'), findsWidgets);
  });

  testWidgets('masque le détail du partenaire avant la fin', (tester) async {
    repository.simulatePartnerCompletion(answers: {'step-1': 'Sa réponse 1'});
    await openScreen(tester);
    await _answer(tester, 'Ma réponse 1');

    expect(find.text('Sa réponse 1'), findsNothing);
    expect(find.text('Étape 2 / 5'), findsOneWidget);
  });

  testWidgets('continuer la discussion ouvre le parcours guidé', (
    tester,
  ) async {
    final questions = FakeDailyQuestionRepository(
      latency: Duration.zero,
      partnerReplyDelay: null,
      clock: () => DateTime(2026, 10, 26, 12),
    );
    await questions.submitAnswer(text: 'Ma réponse');
    questions.simulatePartnerAnswer('La sienne');

    await pumpRechivia(
      tester,
      initialLocation: AppRoutes.answer,
      dailyQuestionRepository: questions,
      guidedConversationRepository: repository,
    );
    await _tap(tester, find.text('Continuer la discussion'));

    expect(find.byType(GuidedConversationScreen), findsOneWidget);
    expect(find.text('Étape 1 / 5'), findsOneWidget);
  });
}
