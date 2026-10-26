import 'package:rechivia/features/daily_question/domain/daily_question.dart';

/// Contrat d'accès à la question du jour.
abstract interface class DailyQuestionRepository {
  /// Question du jour du couple de l'utilisateur.
  Future<DailyQuestion> getTodayQuestion();
}
