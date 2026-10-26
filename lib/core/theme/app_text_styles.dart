import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';

/// Styles de texte de Rechivia (police Poppins, déclarée dans le pubspec).
///
/// Tailles relevées sur les maquettes : titres 24 gras, texte 16 normal,
/// libellés 14 medium, boutons 16 medium.
abstract final class AppTextStyles {
  static const String _fontFamily = 'Poppins';

  /// Grand titre d'écran (ex. "Bon retour !").
  static const TextStyle title = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// Titre de section ou de carte.
  static const TextStyle subtitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Texte courant.
  static const TextStyle body = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  /// Texte courant discret (descriptions, aides).
  static const TextStyle bodySecondary = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  /// Libellés de champs et petits titres.
  static const TextStyle label = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  /// Texte des boutons (blanc : ils ont un fond dégradé).
  static const TextStyle button = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}
