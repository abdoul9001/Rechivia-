/// Raisons pour lesquelles une action guidée peut échouer.
enum GuidedConversationFailure {
  invalidAnswer,
  unknownStep,
  alreadyResolved,
  network,
  unknown,
}

/// Erreur sans contenu de réponse afin de protéger la vie privée.
class GuidedConversationException implements Exception {
  const GuidedConversationException(this.failure);

  final GuidedConversationFailure failure;

  @override
  String toString() => 'GuidedConversationException(${failure.name})';
}
