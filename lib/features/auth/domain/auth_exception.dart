/// Raisons pour lesquelles une opération d'authentification peut échouer.
///
/// On décrit l'échec par un code (et non par un texte) : c'est l'écran qui
/// choisit le message à afficher. Ainsi la couche "domain" reste indépendante
/// de l'interface et de la langue.
enum AuthFailure {
  /// E-mail ou mot de passe incorrect.
  invalidCredentials,

  /// Un compte existe déjà avec cet e-mail.
  emailAlreadyUsed,

  /// Problème de connexion au serveur.
  network,

  /// Toute autre erreur.
  unknown,
}

/// Erreur levée par un [AuthRepository] quand une opération échoue.
class AuthException implements Exception {
  const AuthException(this.failure);

  final AuthFailure failure;

  /// Volontairement sans détail : un message d'erreur ne doit jamais
  /// contenir d'e-mail ni de mot de passe (ils finiraient dans les journaux).
  @override
  String toString() => 'AuthException(${failure.name})';
}
