/// Réponse d'un partenaire à la question du jour.
class Answer {
  const Answer({required this.text, required this.submittedAt});

  final String text;

  /// Premier envoi ; modifier la réponse ne change pas cette date.
  final DateTime submittedAt;
}
