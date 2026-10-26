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
}
