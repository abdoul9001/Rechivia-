/// Utilisateur connecté à Rechivia.
///
/// Classe immuable (tous les champs sont `final`) : pour "modifier" un
/// utilisateur on en crée un nouveau, ce qui évite les changements surprise.
class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.username,
  });

  /// Identifiant unique fourni par le serveur.
  final String id;

  final String email;

  /// Nom affiché à l'autre partenaire.
  final String username;
}
