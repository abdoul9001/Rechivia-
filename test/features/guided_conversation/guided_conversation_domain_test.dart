import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/features/daily_question/domain/participant_status.dart';
import 'package:rechivia/features/guided_conversation/domain/guided_conversation.dart';
import 'package:rechivia/features/guided_conversation/domain/guided_step.dart';
import 'package:rechivia/features/preferences/domain/theme_category.dart';

const _step = GuidedStep(
  id: 's1',
  title: 'Titre',
  description: 'Description',
  category: ThemeCategory.other,
);

void main() {
  test('la première étape en attente est l’étape courante', () {
    final conversation = GuidedConversation(
      entries: const [
        GuidedStepEntry(step: _step, myStatus: ParticipantStatus.passed),
        GuidedStepEntry(step: _step, myStatus: ParticipantStatus.pending),
      ],
      partnerCompleted: false,
    );

    expect(conversation.currentIndex, 1);
    expect(conversation.phase, GuidedPhase.inProgress);
  });

  test('attend le partenaire quand seul l’utilisateur a terminé', () {
    final conversation = GuidedConversation(
      entries: const [
        GuidedStepEntry(
          step: _step,
          myStatus: ParticipantStatus.answered,
          myAnswer: 'Ma réponse',
        ),
      ],
      partnerCompleted: false,
    );

    expect(conversation.currentIndex, isNull);
    expect(conversation.phase, GuidedPhase.waitingForPartner);
  });

  test('refuse le détail du partenaire avant la fin de l’utilisateur', () {
    expect(
      () => GuidedConversation(
        entries: const [
          GuidedStepEntry(
            step: _step,
            myStatus: ParticipantStatus.pending,
            partnerStatus: ParticipantStatus.answered,
            partnerAnswer: 'Réponse privée',
          ),
        ],
        partnerCompleted: true,
      ),
      throwsAssertionError,
    );
  });

  test('refuse le détail du partenaire s’il n’a pas terminé', () {
    expect(
      () => GuidedConversation(
        entries: const [
          GuidedStepEntry(
            step: _step,
            myStatus: ParticipantStatus.answered,
            myAnswer: 'Ma réponse',
            partnerStatus: ParticipantStatus.answered,
            partnerAnswer: 'Réponse privée',
          ),
        ],
        partnerCompleted: false,
      ),
      throwsAssertionError,
    );
  });
}
