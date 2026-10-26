/// Espacements et rayons de coins communs à toute l'application.
///
/// Utiliser ces constantes plutôt que des nombres écrits au hasard garantit
/// un rythme visuel cohérent entre les écrans.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

/// Rayons d'arrondi : les maquettes utilisent des coins très arrondis.
abstract final class AppRadius {
  /// Champs de saisie.
  static const double field = 16;

  /// Cartes.
  static const double card = 20;

  /// Boutons "pilule".
  static const double button = 28;
}
