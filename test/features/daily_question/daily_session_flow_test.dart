import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/features/daily_question/data/fake_daily_question_repository.dart';
import 'package:rechivia/features/daily_question/domain/participant_status.dart';

import '../../helpers/pump_rechivia.dart';

void main() {
  FakeDailyQuestionRepository buildRepository() {
    return FakeDailyQuestionRepository(
      latency: Duration.zero,
      partnerReplyDelay: null,
      clock: () => DateTime(2026, 10, 26, 9),
    );
  }

  test(
    'masque la réponse partenaire jusqu’à la réponse des deux partenaires',
    () async {
      final repository = buildRepository();
      repository.simulatePartnerAnswer('Réponse privée du partenaire');

      final beforeSubmission = await repository.getTodaySession();
      expect(beforeSubmission.partnerStatus, ParticipantStatus.answered);
      expect(beforeSubmission.partnerAnswer, isNull);

      final afterSubmission = await repository.submitAnswer(
        text: 'Ma réponse personnelle',
      );
      expect(
        afterSubmission.partnerAnswer?.text,
        'Réponse privée du partenaire',
      );
    },
  );

  testWidgets('dévoile les réponses uniquement après l’envoi de la mienne', (
    tester,
  ) async {
    final repository = buildRepository();
    repository.simulatePartnerAnswer('Réponse privée du partenaire');

    await pumpRechivia(
      tester,
      initialLocation: AppRoutes.answer,
      dailyQuestionRepository: repository,
    );

    expect(find.text('Réponse privée du partenaire'), findsNothing);
    await tester.enterText(find.byType(EditableText), 'Ma réponse personnelle');
    await tester.tap(find.text('Envoyer ma réponse'));
    await tester.pumpAndSettle();

    expect(find.text('Découverte des réponses'), findsOneWidget);
    expect(find.text('Réponse privée du partenaire'), findsOneWidget);
  });

  testWidgets('permet de modifier sa réponse tant que le partenaire attend', (
    tester,
  ) async {
    final repository = buildRepository();
    await repository.submitAnswer(text: 'Première réponse');

    await pumpRechivia(
      tester,
      initialLocation: AppRoutes.answer,
      dailyQuestionRepository: repository,
    );

    expect(find.text('Modifier ma réponse'), findsOneWidget);
    await tester.tap(find.text('Modifier ma réponse'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText), 'Réponse modifiée');
    await tester.tap(find.text('Enregistrer la modification'));
    await tester.pumpAndSettle();

    final session = await repository.getTodaySession();
    expect(session.myAnswer?.text, 'Réponse modifiée');
    expect(session.myAnswer?.submittedAt, DateTime(2026, 10, 26, 9));
  });

  testWidgets('demande confirmation avant de passer la question', (
    tester,
  ) async {
    final repository = buildRepository();
    await pumpRechivia(
      tester,
      initialLocation: AppRoutes.answer,
      dailyQuestionRepository: repository,
    );

    await tester.tap(find.text('Passer cette question'));
    await tester.pumpAndSettle();
    expect(find.text('Passer cette question ?'), findsOneWidget);

    await tester.tap(find.text('Passer').last);
    await tester.pumpAndSettle();

    expect(find.text('Question passée'), findsOneWidget);
  });
}
