/// Raisons pour lesquelles une action sur la session du jour peut échouer.
enum DailySessionFailure {
  invalidAnswer,
  alreadyAnswered,
  alreadyRevealed,
  alreadyPassed,
  network,
  unknown,
}

/// Erreur d'action sans contenu de réponse afin de préserver la vie privée.
class DailySessionException implements Exception {
  const DailySessionException(this.failure);

  final DailySessionFailure failure;

  @override
  String toString() => 'DailySessionException(${failure.name})';
}
