import 'package:flutter/material.dart';

/// Palette de couleurs de Rechivia, relevée sur les maquettes.
///
/// Règle : aucune couleur n'est écrite "en dur" ailleurs dans l'application.
/// Si une couleur change, on ne la modifie qu'ici.
abstract final class AppColors {
  // --- Couleurs de marque ---------------------------------------------------

  /// Rose principal (début du dégradé, éléments clés).
  static const Color pink = Color(0xFFFF4DA6);

  /// Violet principal (fin du dégradé, éléments actifs).
  static const Color violet = Color(0xFF7B5CF6);

  /// Rose clair : fonds de cartes et éléments secondaires.
  static const Color pinkLight = Color(0xFFFADADD);

  /// Dégradé rose vers violet utilisé par les boutons et accents principaux.
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [pink, violet],
  );

  // --- Fonds ----------------------------------------------------------------

  /// Fond général des écrans.
  static const Color background = Color(0xFFF5F6FF);

  /// Fond des cartes et des champs de saisie.
  static const Color surface = Color(0xFFFFFFFF);

  // --- Textes ---------------------------------------------------------------

  /// Texte principal (titres, contenus importants).
  static const Color textPrimary = Color(0xFF2D1B69);

  /// Texte secondaire (descriptions, placeholders).
  static const Color textSecondary = Color(0xFF6B7280);

  // --- Divers ---------------------------------------------------------------

  /// Bordure fine des champs et des cartes.
  static const Color border = Color(0xFFE4E1F7);

  /// Couleur d'erreur (validation de formulaire, actions destructives).
  static const Color error = Color(0xFFE5484D);

  // --- Couleurs des catégories de thèmes (écran de choix des thèmes) --------

  static const Color categoryYellow = Color(0xFFFFC107);
  static const Color categoryGreen = Color(0xFF22C55E);
}
