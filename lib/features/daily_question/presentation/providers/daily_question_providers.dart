import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rechivia/features/daily_question/data/fake_daily_question_repository.dart';
import 'package:rechivia/features/daily_question/domain/daily_question.dart';
import 'package:rechivia/features/daily_question/domain/daily_question_repository.dart';
import 'package:rechivia/features/daily_question/domain/daily_session.dart';

/// Fournit le dépôt de la session à l'application.
final dailyQuestionRepositoryProvider = Provider<DailyQuestionRepository>(
  (ref) => FakeDailyQuestionRepository(),
);

/// État partagé de la session, consommé par l'accueil et l'écran de réponse.
final dailySessionProvider = FutureProvider.autoDispose<DailySession>(
  (ref) => ref.watch(dailyQuestionRepositoryProvider).getTodaySession(),
);

/// Question du jour dérivée de la session partagée.
final dailyQuestionProvider = FutureProvider.autoDispose<DailyQuestion>(
  (ref) async => (await ref.watch(dailySessionProvider.future)).question,
);
