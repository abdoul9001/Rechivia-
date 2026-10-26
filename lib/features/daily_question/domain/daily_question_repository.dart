import 'package:rechivia/features/daily_question/domain/daily_session.dart';

/// Contrat d'accès à la session du jour et à ses actions.
abstract interface class DailyQuestionRepository {
  Future<DailySession> getTodaySession();

  /// Envoie la réponse, ou la modifie avant le dévoilement.
  Future<DailySession> submitAnswer({required String text});

  /// Passe la question sans pénalité.
  Future<DailySession> passToday();
}
