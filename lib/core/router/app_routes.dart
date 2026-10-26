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

  // --- Les 4 onglets de la barre de navigation ------------------------------
  static const String home = '/home';
  static const String history = '/history';
  static const String favorites = '/favorites';
  static const String profile = '/profile';

  // --- Écrans plein écran (sans barre de navigation) ------------------------

  /// Répondre à la question du jour (bouton "+" au centre de la barre).
  static const String answer = '/answer';
}
