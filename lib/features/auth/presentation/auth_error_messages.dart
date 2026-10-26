import 'package:rechivia/features/auth/domain/auth_exception.dart';

/// Transforme une erreur technique en message compréhensible pour l'utilisateur.
String authErrorMessage(Object error) {
  if (error is AuthException) {
    return switch (error.failure) {
      AuthFailure.invalidCredentials => 'E-mail ou mot de passe incorrect.',
      AuthFailure.emailAlreadyUsed => 'Un compte existe déjà avec cet e-mail.',
      AuthFailure.notSignedIn => 'Vous n\'êtes pas connecté. Reconnectez-vous.',
      AuthFailure.network => 'Connexion impossible. Vérifiez votre réseau.',
      AuthFailure.unknown => _genericMessage,
    };
  }
  return _genericMessage;
}

const String _genericMessage = 'Une erreur est survenue. Réessayez.';
