import 'package:rechivia/core/data/simulated_latency.dart';
import 'package:rechivia/features/daily_question/domain/answer.dart';
import 'package:rechivia/features/daily_question/domain/answer_validators.dart';
import 'package:rechivia/features/daily_question/domain/daily_question.dart';
import 'package:rechivia/features/daily_question/domain/daily_question_repository.dart';
import 'package:rechivia/features/daily_question/domain/daily_session.dart';
import 'package:rechivia/features/daily_question/domain/daily_session_exception.dart';
import 'package:rechivia/features/daily_question/domain/participant_status.dart';
import 'package:rechivia/features/preferences/domain/theme_category.dart';

/// Faux serveur et faux partenaire, uniquement pour le développement.
class FakeDailyQuestionRepository implements DailyQuestionRepository {
  FakeDailyQuestionRepository({
    this.latency = const Duration(milliseconds: 400),
    this.partnerReplyDelay = const Duration(seconds: 10),
    this.sessionValidity = const Duration(hours: 48),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final Duration latency;
  final Duration? partnerReplyDelay;
  final Duration sessionValidity;
  final DateTime Function() _clock;

  static const String _defaultPartnerAnswer =
      'J’aimerais faire un voyage en montagne, prendre un petit chalet et '
      'juste profiter de la nature, toi et moi.';

  static const List<_QuestionTemplate> _catalog = [
    _QuestionTemplate(
      id: 'q-1',
      text:
          'Quelle est la chose la plus folle que tu aimerais faire ensemble ?',
      category: ThemeCategory.gamesChallenges,
    ),
    _QuestionTemplate(
      id: 'q-2',
      text: 'Qu\'est-ce qui te fait te sentir aimé(e) ?',
      category: ThemeCategory.loveRomance,
    ),
    _QuestionTemplate(
      id: 'q-3',
      text: 'Quel est ton plus grand rêve ?',
      category: ThemeCategory.futureProjects,
    ),
    _QuestionTemplate(
      id: 'q-4',
      text: 'Qu\'est-ce qui te rend heureux(se) au quotidien ?',
      category: ThemeCategory.wellbeingBalance,
    ),
    _QuestionTemplate(
      id: 'q-5',
      text: 'Comment gères-tu le stress ?',
      category: ThemeCategory.wellbeingBalance,
    ),
    _QuestionTemplate(
      id: 'q-6',
      text: 'Qu\'est-ce qui t\'a fait sourire aujourd\'hui ?',
      category: ThemeCategory.personalityDiscovery,
    ),
    _QuestionTemplate(
      id: 'q-7',
      text: 'Quel voyage rêves-tu de faire à deux ?',
      category: ThemeCategory.travelAdventure,
    ),
    _QuestionTemplate(
      id: 'q-8',
      text: 'Quel est ton plus beau souvenir de nous ?',
      category: ThemeCategory.loveRomance,
    ),
  ];

  _SessionRecord? _record;

  @override
  Future<DailySession> getTodaySession() async {
    await simulateLatency(latency);
    return _snapshot(_currentRecord());
  }

  @override
  Future<DailySession> submitAnswer({required String text}) async {
    await simulateLatency(latency);

    final record = _currentRecord();
    _applyPartnerReply(record);
    final trimmed = text.trim();
    if (AnswerValidators.answer(trimmed) != null) {
      throw const DailySessionException(DailySessionFailure.invalidAnswer);
    }
    if (record.iPassed) {
      throw const DailySessionException(DailySessionFailure.alreadyPassed);
    }
    if (_isRevealed(record)) {
      throw const DailySessionException(DailySessionFailure.alreadyRevealed);
    }

    record.myAnswer = Answer(
      text: trimmed,
      submittedAt: record.myAnswer?.submittedAt ?? _clock(),
    );
    return _snapshot(record);
  }

  @override
  Future<DailySession> passToday() async {
    await simulateLatency(latency);
    final record = _currentRecord();
    if (record.myAnswer != null) {
      throw const DailySessionException(DailySessionFailure.alreadyAnswered);
    }
    record.iPassed = true;
    return _snapshot(record);
  }

  /// Fait répondre le faux partenaire immédiatement (outil de test).
  void simulatePartnerAnswer(String text) {
    final record = _currentRecord();
    record.partnerAnswer = Answer(text: text.trim(), submittedAt: _clock());
    record.partnerPassed = false;
  }

  /// Fait passer la question au faux partenaire (outil de test).
  void simulatePartnerPass() {
    final record = _currentRecord();
    if (record.partnerAnswer == null) record.partnerPassed = true;
  }

  _SessionRecord _currentRecord() {
    final now = _clock();
    final today = DateTime(now.year, now.month, now.day);
    final existing = _record;
    if (existing != null && existing.question.date == today) return existing;

    final template = _catalog[_daysSinceEpoch(today) % _catalog.length];
    final record = _SessionRecord(
      question: DailyQuestion(
        id: template.id,
        text: template.text,
        category: template.category,
        date: today,
      ),
      createdAt: now,
    );
    _record = record;
    return record;
  }

  void _applyPartnerReply(_SessionRecord record) {
    final delay = partnerReplyDelay;
    final myAnsweredAt = record.myAnswer?.submittedAt;
    if (delay == null || myAnsweredAt == null) return;
    if (record.partnerAnswer != null || record.partnerPassed) return;

    final replyAt = myAnsweredAt.add(delay);
    if (!_clock().isBefore(replyAt)) {
      record.partnerAnswer = Answer(
        text: _defaultPartnerAnswer,
        submittedAt: replyAt,
      );
    }
  }

  bool _isRevealed(_SessionRecord record) {
    return record.myAnswer != null && record.partnerAnswer != null;
  }

  DailySession _snapshot(_SessionRecord record) {
    _applyPartnerReply(record);

    final myStatus = record.iPassed
        ? ParticipantStatus.passed
        : record.myAnswer != null
        ? ParticipantStatus.answered
        : ParticipantStatus.pending;
    final partnerStatus = record.partnerAnswer != null
        ? ParticipantStatus.answered
        : record.partnerPassed
        ? ParticipantStatus.passed
        : ParticipantStatus.pending;

    return DailySession(
      question: record.question,
      expiresAt: record.createdAt.add(sessionValidity),
      myStatus: myStatus,
      partnerStatus: partnerStatus,
      myAnswer: record.myAnswer,
      partnerAnswer: _isRevealed(record) ? record.partnerAnswer : null,
    );
  }

  static int _daysSinceEpoch(DateTime day) {
    return DateTime.utc(
      day.year,
      day.month,
      day.day,
    ).difference(DateTime.utc(1970)).inDays;
  }
}

class _SessionRecord {
  _SessionRecord({required this.question, required this.createdAt});

  final DailyQuestion question;
  final DateTime createdAt;
  Answer? myAnswer;
  bool iPassed = false;
  Answer? partnerAnswer;
  bool partnerPassed = false;
}

class _QuestionTemplate {
  const _QuestionTemplate({
    required this.id,
    required this.text,
    required this.category,
  });

  final String id;
  final String text;
  final ThemeCategory category;
}
