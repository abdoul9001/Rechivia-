/// Invitation temporaire et à usage unique envoyée à un partenaire.
class Invitation {
  const Invitation({required this.code, required this.expiresAt});

  /// Code de six caractères à communiquer au partenaire.
  final String code;

  /// Date limite d'utilisation.
  final DateTime expiresAt;
}
