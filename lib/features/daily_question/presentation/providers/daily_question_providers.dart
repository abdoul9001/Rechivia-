import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rechivia/features/daily_question/data/fake_daily_question_repository.dart';
import 'package:rechivia/features/daily_question/domain/daily_question.dart';
import 'package:rechivia/features/daily_question/domain/daily_question_repository.dart';

/// Fournit le dépôt des questions à l'application.
final dailyQuestionRepositoryProvider = Provider<DailyQuestionRepository>(
  (ref) => FakeDailyQuestionRepository(),
);

/// Question du jour, avec états de chargement et d'erreur.
final dailyQuestionProvider = FutureProvider.autoDispose<DailyQuestion>(
  (ref) => ref.watch(dailyQuestionRepositoryProvider).getTodayQuestion(),
);
