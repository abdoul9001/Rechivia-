import 'package:rechivia/features/daily_question/domain/answer.dart';
import 'package:rechivia/features/daily_question/domain/daily_question.dart';
import 'package:rechivia/features/daily_question/domain/participant_status.dart';

/// Étape de la session du jour du point de vue de l'utilisateur.
enum SessionPhase {
  toAnswer,
  waitingForPartner,
  revealed,
  iPassed,
  partnerPassed,
}

/// Session du jour et état public de chacun des partenaires.
///
/// La réponse du partenaire n'est fournie qu'après les deux réponses.
class DailySession {
  const DailySession({
    required this.question,
    required this.expiresAt,
    required this.myStatus,
    required this.partnerStatus,
    this.myAnswer,
    this.partnerAnswer,
  }) : assert(
         myStatus != ParticipantStatus.answered || myAnswer != null,
         'Une réponse envoyée doit être fournie.',
       ),
       assert(
         partnerAnswer == null ||
             (myStatus == ParticipantStatus.answered &&
                 partnerStatus == ParticipantStatus.answered),
         'La réponse partenaire ne se transmet qu’après les deux réponses.',
       ),
       assert(
         !(myStatus == ParticipantStatus.answered &&
                 partnerStatus == ParticipantStatus.answered) ||
             partnerAnswer != null,
         'Les deux réponses sont présentes quand la session est révélée.',
       );

  final DailyQuestion question;
  final DateTime expiresAt;
  final ParticipantStatus myStatus;
  final ParticipantStatus partnerStatus;
  final Answer? myAnswer;
  final Answer? partnerAnswer;

  SessionPhase get phase {
    if (myStatus == ParticipantStatus.passed) return SessionPhase.iPassed;
    if (myStatus == ParticipantStatus.pending) return SessionPhase.toAnswer;

    return switch (partnerStatus) {
      ParticipantStatus.answered => SessionPhase.revealed,
      ParticipantStatus.passed => SessionPhase.partnerPassed,
      ParticipantStatus.pending => SessionPhase.waitingForPartner,
    };
  }
}
