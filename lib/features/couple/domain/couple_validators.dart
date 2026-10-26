/// Règles de validation des formulaires du couple.
abstract final class CoupleValidators {
  static const int minNameLength = 2;
  static const int maxNameLength = 30;

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _phonePattern = RegExp(r'^\+?\d{8,15}$');

  static String? coupleName(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Donnez un nom à votre espace.';
    if (text.length < minNameLength || text.length > maxNameLength) {
      return '$minNameLength à $maxNameLength caractères.';
    }
    return null;
  }

  /// Accepte une adresse e-mail ou un numéro de téléphone international.
  static String? partnerContact(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Saisissez son e-mail ou son numéro de téléphone.';
    }
    final digitsOnly = text.replaceAll(RegExp(r'[\s().-]'), '');
    if (_emailPattern.hasMatch(text) || _phonePattern.hasMatch(digitsOnly)) {
      return null;
    }
    return 'E-mail ou numéro de téléphone invalide.';
  }
}
