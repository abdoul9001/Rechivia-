import 'package:rechivia/features/auth/domain/app_user.dart';

/// Contrat de l'authentification : ce que l'application sait faire, sans
/// dire comment.
///
/// Les écrans ne connaissent que cette interface. L'implémentation réelle
/// (Supabase) ou factice (tests, développement) se choisit à un seul endroit :
/// `authRepositoryProvider`.
///
/// Toutes les méthodes lèvent une `AuthException` en cas d'échec.
abstract interface class AuthRepository {
  /// Crée un compte et connecte l'utilisateur.
  Future<AppUser> signUp({
    required String email,
    required String username,
    required String password,
  });

  /// Connecte un utilisateur existant.
  Future<AppUser> signIn({required String email, required String password});

  /// Envoie un e-mail de réinitialisation du mot de passe.
  ///
  /// Réussit toujours, que l'e-mail soit connu ou non : sinon on révélerait
  /// quelles adresses ont un compte.
  Future<void> sendPasswordResetEmail({required String email});

  /// Utilisateur actuellement connecté, ou `null` si personne ne l'est.
  Future<AppUser?> getCurrentUser();

  /// Déconnecte l'utilisateur. Sans effet si personne n'est connecté.
  Future<void> signOut();

  /// Supprime définitivement le compte de l'utilisateur connecté, puis le
  /// déconnecte.
  ///
  /// Échoue avec `notSignedIn` si personne n'est connecté.
  ///
  /// À REVOIR avec le backend : le sort des données du couple dépend de la
  /// matrice des droits et de conservation du plan (étape 2), pas encore
  /// rédigée. Il faudra aussi redemander le mot de passe avant de supprimer.
  Future<void> deleteAccount();
}
