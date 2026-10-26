import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/features/daily_question/domain/participant_status.dart';
import 'package:rechivia/features/guided_conversation/data/fake_guided_conversation_repository.dart';
import 'package:rechivia/features/guided_conversation/domain/guided_conversation.dart';
import 'package:rechivia/features/guided_conversation/domain/guided_conversation_exception.dart';

Matcher _throwsFailure(GuidedConversationFailure failure) {
  return throwsA(
    isA<GuidedConversationException>().having(
      (error) => error.failure,
      'failure',
      failure,
    ),
  );
}

void main() {
  late DateTime now;

  setUp(() => now = DateTime(2026, 10, 26, 12));

  FakeGuidedConversationRepository buildRepository({
    Duration? partnerReplyDelay,
  }) {
    return FakeGuidedConversationRepository(
      latency: Duration.zero,
      partnerReplyDelay: partnerReplyDelay,
      clock: () => now,
    );
  }

  Future<GuidedConversation> completeAll(
    FakeGuidedConversationRepository repository,
  ) async {
    var conversation = await repository.getConversation();
    for (final entry in conversation.entries) {
      conversation = await repository.answerStep(
        stepId: entry.step.id,
        text: 'Réponse à ${entry.step.id}',
      );
    }
    return conversation;
  }

  test('démarre avec cinq étapes à traiter', () async {
    final conversation = await buildRepository().getConversation();

    expect(conversation.entries, hasLength(5));
    expect(conversation.currentIndex, 0);
    expect(conversation.phase, GuidedPhase.inProgress);
  });

  test('répondre enregistre le texte nettoyé et avance', () async {
    final conversation = await buildRepository().answerStep(
      stepId: 'step-1',
      text: '  Un sourire  ',
    );

    expect(conversation.entries.first.myAnswer, 'Un sourire');
    expect(conversation.entries.first.myStatus, ParticipantStatus.answered);
    expect(conversation.currentIndex, 1);
  });

  test('passer une étape la marque comme passée', () async {
    final conversation = await buildRepository().passStep(stepId: 'step-1');

    expect(conversation.entries.first.myStatus, ParticipantStatus.passed);
    expect(conversation.entries.first.myAnswer, isNull);
    expect(conversation.currentIndex, 1);
  });

  test('refuse réponse vide, étape inconnue et double traitement', () async {
    final repository = buildRepository();

    await expectLater(
      repository.answerStep(stepId: 'step-1', text: '   '),
      _throwsFailure(GuidedConversationFailure.invalidAnswer),
    );
    await expectLater(
      repository.answerStep(stepId: 'inconnue', text: 'Texte'),
      _throwsFailure(GuidedConversationFailure.unknownStep),
    );

    await repository.passStep(stepId: 'step-1');
    await expectLater(
      repository.answerStep(stepId: 'step-1', text: 'Trop tard'),
      _throwsFailure(GuidedConversationFailure.alreadyResolved),
    );
    await expectLater(
      repository.passStep(stepId: 'step-1'),
      _throwsFailure(GuidedConversationFailure.alreadyResolved),
    );
  });

  test('attend le partenaire après avoir traité toutes les étapes', () async {
    final conversation = await completeAll(buildRepository());

    expect(conversation.phase, GuidedPhase.waitingForPartner);
    expect(
      conversation.entries.every((entry) => entry.partnerAnswer == null),
      isTrue,
    );
  });

  test('dévoile les réponses quand les deux ont terminé', () async {
    final repository = buildRepository();
    await completeAll(repository);
    repository.simulatePartnerCompletion(answers: {'step-1': 'Sa réponse'});

    final conversation = await repository.getConversation();

    expect(conversation.phase, GuidedPhase.revealed);
    expect(conversation.entries.first.partnerAnswer, 'Sa réponse');
    expect(conversation.entries[1].partnerStatus, ParticipantStatus.passed);
  });

  test('ne transmet jamais le détail du partenaire avant la fin', () async {
    final repository = buildRepository();
    repository.simulatePartnerCompletion(answers: {'step-1': 'Sa réponse'});

    var conversation = await repository.getConversation();
    expect(conversation.partnerCompleted, isTrue);
    expect(conversation.entries.first.partnerAnswer, isNull);
    expect(conversation.entries.first.partnerStatus, isNull);

    for (final id in ['step-1', 'step-2', 'step-3', 'step-4']) {
      conversation = await repository.passStep(stepId: id);
    }
    expect(conversation.entries.first.partnerAnswer, isNull);
  });

  test('le faux partenaire termine après son délai', () async {
    final repository = buildRepository(
      partnerReplyDelay: const Duration(seconds: 10),
    );
    await completeAll(repository);

    expect(
      (await repository.getConversation()).phase,
      GuidedPhase.waitingForPartner,
    );
    now = now.add(const Duration(seconds: 11));
    expect((await repository.getConversation()).phase, GuidedPhase.revealed);
  });
}
