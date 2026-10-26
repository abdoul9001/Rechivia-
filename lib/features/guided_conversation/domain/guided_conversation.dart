import 'package:rechivia/features/daily_question/domain/participant_status.dart';
import 'package:rechivia/features/guided_conversation/domain/guided_step.dart';

enum GuidedPhase { inProgress, waitingForPartner, revealed }

/// Avancement d'un partenaire pour une étape.
class GuidedStepEntry {
  const GuidedStepEntry({
    required this.step,
    required this.myStatus,
    this.myAnswer,
    this.partnerStatus,
    this.partnerAnswer,
  });

  final GuidedStep step;
  final ParticipantStatus myStatus;
  final String? myAnswer;
  final ParticipantStatus? partnerStatus;
  final String? partnerAnswer;
}

/// Suite d'étapes et état de confidentialité de la conversation.
class GuidedConversation {
  GuidedConversation({
    required List<GuidedStepEntry> entries,
    required this.partnerCompleted,
  }) : entries = List.unmodifiable(entries),
       assert(
         _respectsConfidentiality(entries, partnerCompleted),
         'Le détail du partenaire ne doit être transmis que lorsque les deux '
         'ont terminé.',
       );

  final List<GuidedStepEntry> entries;
  final bool partnerCompleted;

  bool get isCompleted =>
      entries.every((entry) => entry.myStatus != ParticipantStatus.pending);

  int? get currentIndex {
    final index = entries.indexWhere(
      (entry) => entry.myStatus == ParticipantStatus.pending,
    );
    return index == -1 ? null : index;
  }

  GuidedPhase get phase {
    if (!isCompleted) return GuidedPhase.inProgress;
    return partnerCompleted
        ? GuidedPhase.revealed
        : GuidedPhase.waitingForPartner;
  }

  static bool _respectsConfidentiality(
    List<GuidedStepEntry> entries,
    bool partnerCompleted,
  ) {
    final mineDone = entries.every(
      (entry) => entry.myStatus != ParticipantStatus.pending,
    );
    final revealed = mineDone && partnerCompleted;

    return entries.every((entry) {
      if (!revealed) {
        return entry.partnerStatus == null && entry.partnerAnswer == null;
      }
      final status = entry.partnerStatus;
      return status != null &&
          status != ParticipantStatus.pending &&
          (status != ParticipantStatus.answered || entry.partnerAnswer != null);
    });
  }
}
