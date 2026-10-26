/// Raison pour laquelle une opération sur l'historique a échoué.
enum HistoryFailure { unknownEntry, network, unknown }

/// Erreur sans contenu de réponse afin de protéger la vie privée.
class HistoryException implements Exception {
  const HistoryException(this.failure);

  final HistoryFailure failure;

  @override
  String toString() => 'HistoryException(${failure.name})';
}
