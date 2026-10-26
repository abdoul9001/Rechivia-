/// Raisons pour lesquelles une opération sur le couple peut échouer.
enum CoupleFailure {
  /// Code inconnu, expiré ou déjà utilisé.
  invalidInvitation,

  /// L'utilisateur a déjà un espace actif.
  alreadyInCouple,

  /// L'utilisateur n'a pas encore d'espace de couple.
  noCouple,

  network,
  unknown,
}

/// Erreur levée par un `CoupleRepository` quand une opération échoue.
class CoupleException implements Exception {
  const CoupleException(this.failure);

  final CoupleFailure failure;

  /// Sans détail : ni code d'invitation ni contact dans les journaux.
  @override
  String toString() => 'CoupleException(${failure.name})';
}
