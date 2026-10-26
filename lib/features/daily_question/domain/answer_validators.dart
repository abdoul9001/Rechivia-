/// Règles de validation d'une réponse à la question du jour.
abstract final class AnswerValidators {
  static const int maxLength = 500;

  static String? answer(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Écrivez votre réponse avant de la partager.';
    if (text.length > maxLength) return '$maxLength caractères maximum.';
    return null;
  }
}
