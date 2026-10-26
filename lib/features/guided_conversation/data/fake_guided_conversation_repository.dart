import 'package:rechivia/core/data/simulated_latency.dart';
import 'package:rechivia/features/daily_question/domain/answer_validators.dart';
import 'package:rechivia/features/daily_question/domain/participant_status.dart';
import 'package:rechivia/features/guided_conversation/domain/guided_conversation.dart';
import 'package:rechivia/features/guided_conversation/domain/guided_conversation_exception.dart';
import 'package:rechivia/features/guided_conversation/domain/guided_conversation_repository.dart';
import 'package:rechivia/features/guided_conversation/domain/guided_step.dart';
import 'package:rechivia/features/preferences/domain/theme_category.dart';

/// Dépôt factice en mémoire, avec simulation d'un partenaire.
class FakeGuidedConversationRepository implements GuidedConversationRepository {
  FakeGuidedConversationRepository({
    this.latency = const Duration(milliseconds: 400),
    this.partnerReplyDelay = const Duration(seconds: 10),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final Duration latency;
  final Duration? partnerReplyDelay;
  final DateTime Function() _clock;

  static const List<GuidedStep> _steps = [
    GuidedStep(
      id: 'step-1',
      title: 'Qu\'est-ce qui t\'a fait sourire aujourd\'hui ?',
      description:
          'Parle-moi d\'un petit moment, d\'une personne ou d\'une situation '
          'qui a illuminé ta journée.',
      category: ThemeCategory.loveRomance,
    ),
    GuidedStep(
      id: 'step-2',
      title: 'Quel petit geste de ma part te touche le plus ?',
      description:
          'Pense à une attention, même minuscule, qui compte pour toi.',
      category: ThemeCategory.loveRomance,
    ),
    GuidedStep(
      id: 'step-3',
      title: 'De quoi es-tu le plus fier(ère) en ce moment ?',
      description: 'Un projet, un effort, une petite victoire : tout compte.',
      category: ThemeCategory.personalityDiscovery,
    ),
    GuidedStep(
      id: 'step-4',
      title: 'Qu\'est-ce qui te détend le mieux après une journée chargée ?',
      description: 'Dis-moi ce qui t\'aide à souffler, seul(e) ou avec moi.',
      category: ThemeCategory.wellbeingBalance,
    ),
    GuidedStep(
      id: 'step-5',
      title: 'Qu\'aimerais-tu que nous essayions ensemble ce mois-ci ?',
      description: 'Une sortie, un jeu, un défi : lance une idée !',
      category: ThemeCategory.gamesChallenges,
    ),
  ];

  static const String _defaultPartnerAnswer =
      'Une réponse de test de votre partenaire.';

  final Map<String, _MyResponse> _mine = {};
  Map<String, String?>? _partner;
  DateTime? _completedAt;

  @override
  Future<GuidedConversation> getConversation() async {
    await simulateLatency(latency);
    return _snapshot();
  }

  @override
  Future<GuidedConversation> answerStep({
    required String stepId,
    required String text,
  }) async {
    await simulateLatency(latency);
    _requireStep(stepId);
    final trimmed = text.trim();
    if (AnswerValidators.answer(trimmed) != null) {
      throw const GuidedConversationException(
        GuidedConversationFailure.invalidAnswer,
      );
    }
    _requirePending(stepId);

    _mine[stepId] = _MyResponse(answer: trimmed);
    _markCompletionIfDone();
    return _snapshot();
  }

  @override
  Future<GuidedConversation> passStep({required String stepId}) async {
    await simulateLatency(latency);
    _requireStep(stepId);
    _requirePending(stepId);

    _mine[stepId] = const _MyResponse(answer: null);
    _markCompletionIfDone();
    return _snapshot();
  }

  /// Marque la conversation du faux partenaire comme terminée.
  void simulatePartnerCompletion({Map<String, String> answers = const {}}) {
    _partner = {for (final step in _steps) step.id: answers[step.id]};
  }

  void _requireStep(String stepId) {
    if (_steps.every((step) => step.id != stepId)) {
      throw const GuidedConversationException(
        GuidedConversationFailure.unknownStep,
      );
    }
  }

  void _requirePending(String stepId) {
    if (_mine.containsKey(stepId)) {
      throw const GuidedConversationException(
        GuidedConversationFailure.alreadyResolved,
      );
    }
  }

  void _markCompletionIfDone() {
    if (_mine.length == _steps.length) _completedAt ??= _clock();
  }

  void _applyPartnerReply() {
    final delay = partnerReplyDelay;
    final completedAt = _completedAt;
    if (delay == null || completedAt == null || _partner != null) return;
    if (!_clock().isBefore(completedAt.add(delay))) {
      _partner = {for (final step in _steps) step.id: _defaultPartnerAnswer};
    }
  }

  /// Ne transmet le détail du partenaire qu'après les deux complétions.
  GuidedConversation _snapshot() {
    _applyPartnerReply();
    final mineDone = _mine.length == _steps.length;
    final revealedPartner = mineDone ? _partner : null;

    return GuidedConversation(
      entries: [for (final step in _steps) _entryFor(step, revealedPartner)],
      partnerCompleted: _partner != null,
    );
  }

  GuidedStepEntry _entryFor(
    GuidedStep step,
    Map<String, String?>? revealedPartner,
  ) {
    final mine = _mine[step.id];
    final myStatus = switch (mine) {
      null => ParticipantStatus.pending,
      _MyResponse(answer: null) => ParticipantStatus.passed,
      _ => ParticipantStatus.answered,
    };

    String? partnerAnswer;
    ParticipantStatus? partnerStatus;
    if (revealedPartner != null) {
      partnerAnswer = revealedPartner[step.id];
      partnerStatus = partnerAnswer == null
          ? ParticipantStatus.passed
          : ParticipantStatus.answered;
    }

    return GuidedStepEntry(
      step: step,
      myStatus: myStatus,
      myAnswer: mine?.answer,
      partnerStatus: partnerStatus,
      partnerAnswer: partnerAnswer,
    );
  }
}

class _MyResponse {
  const _MyResponse({required this.answer});

  final String? answer;
}
