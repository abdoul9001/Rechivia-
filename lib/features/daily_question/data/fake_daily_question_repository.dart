import 'package:rechivia/core/data/simulated_latency.dart';
import 'package:rechivia/features/daily_question/domain/daily_question.dart';
import 'package:rechivia/features/daily_question/domain/daily_question_repository.dart';
import 'package:rechivia/features/preferences/domain/theme_category.dart';

/// Implémentation factice avec huit questions déterminées par la date.
class FakeDailyQuestionRepository implements DailyQuestionRepository {
  FakeDailyQuestionRepository({
    this.latency = const Duration(milliseconds: 400),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final Duration latency;
  final DateTime Function() _clock;

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

  @override
  Future<DailyQuestion> getTodayQuestion() async {
    await simulateLatency(latency);

    final now = _clock();
    final today = DateTime(now.year, now.month, now.day);
    final template = _catalog[_daysSinceEpoch(today) % _catalog.length];

    return DailyQuestion(
      id: template.id,
      text: template.text,
      category: template.category,
      date: today,
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
