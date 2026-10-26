/// Chemins de toutes les routes de l'application.
///
/// Centraliser les chemins ici évite les fautes de frappe : on écrit
/// `AppRoutes.home` plutôt que la chaîne '/home' dans plusieurs fichiers.
abstract final class AppRoutes {
  // --- Avant la connexion ---------------------------------------------------

  /// Carrousel d'introduction (3 diapositives).
  static const String onboarding = '/onboarding';

  /// Écran de bienvenue : créer un compte ou se connecter.
  static const String welcome = '/welcome';

  static const String register = '/register';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';

  /// Choix des thèmes, juste après l'inscription.
  static const String themes = '/themes';

  /// Création de l'espace privé du couple.
  static const String createCouple = '/couple/create';

  /// Invitation du partenaire.
  static const String invitePartner = '/couple/invite';

  /// Rejoindre un espace avec un code d'invitation.
  static const String joinCouple = '/couple/join';

  // --- Les 4 onglets de la barre de navigation ------------------------------
  static const String home = '/home';
  static const String history = '/history';
  static const String favorites = '/favorites';
  static const String profile = '/profile';

  // --- Écrans plein écran (sans barre de navigation) ------------------------

  /// Répondre à la question du jour (bouton "+" au centre de la barre).
  static const String answer = '/answer';

  /// Conversation guidée (en 5 étapes), après la question du jour.
  static const String guidedConversation = '/guided';
}
