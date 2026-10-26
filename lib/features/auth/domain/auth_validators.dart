/// Règles de validation des champs des formulaires d'authentification.
///
/// Chaque fonction retourne un message d'erreur, ou `null` si la valeur est
/// valide : c'est exactement le contrat attendu par le `validator` d'un
/// champ de formulaire. Ce sont des fonctions pures, faciles à tester.
abstract final class AuthValidators {
  /// Longueur minimale d'un mot de passe.
  static const int minPasswordLength = 8;

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  /// 3 à 20 caractères : lettres (accents inclus), chiffres, _ - et espace.
  static final RegExp _usernamePattern = RegExp(
    r'^[\p{L}\p{N}_ -]{3,20}$',
    unicode: true,
  );

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Saisissez votre adresse e-mail.';
    if (!_emailPattern.hasMatch(text)) return 'Adresse e-mail invalide.';
    return null;
  }

  static String? username(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Choisissez un nom d\'utilisateur.';
    if (!_usernamePattern.hasMatch(text)) {
      return '3 à 20 caractères : lettres, chiffres, espace, _ ou -.';
    }
    return null;
  }

  /// Mot de passe à la création : on impose une longueur minimale.
  static String? newPassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Saisissez un mot de passe.';
    if (text.length < minPasswordLength) {
      return '$minPasswordLength caractères minimum.';
    }
    return null;
  }

  /// Mot de passe à la connexion : on vérifie seulement qu'il est rempli
  /// (c'est le serveur qui dira s'il est correct).
  static String? existingPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Saisissez votre mot de passe.';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Confirmez votre mot de passe.';
    if (value != password) return 'Les mots de passe ne correspondent pas.';
    return null;
  }
}
