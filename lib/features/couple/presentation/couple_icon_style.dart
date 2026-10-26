import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/features/couple/domain/couple_icon.dart';

/// Icône et couleur de présentation d'une option du sélecteur.
extension CoupleIconStyle on CoupleIcon {
  IconData get icon => switch (this) {
    CoupleIcon.heart => Icons.favorite,
    CoupleIcon.home => Icons.home_rounded,
    CoupleIcon.star => Icons.star_rounded,
    CoupleIcon.leaf => Icons.eco_rounded,
    CoupleIcon.landscape => Icons.landscape_rounded,
    CoupleIcon.paw => Icons.pets_rounded,
    CoupleIcon.sun => Icons.wb_sunny_rounded,
    CoupleIcon.moon => Icons.nightlight_round,
    CoupleIcon.gem => Icons.diamond_rounded,
    CoupleIcon.other => Icons.auto_awesome_rounded,
  };

  Color get color => switch (this) {
    CoupleIcon.heart || CoupleIcon.gem => AppColors.pink,
    CoupleIcon.home || CoupleIcon.moon || CoupleIcon.other => AppColors.violet,
    CoupleIcon.star || CoupleIcon.sun => AppColors.categoryYellow,
    CoupleIcon.leaf => AppColors.categoryGreen,
    CoupleIcon.landscape => AppColors.categoryBlue,
    CoupleIcon.paw => AppColors.categoryOrange,
  };

  String get label => switch (this) {
    CoupleIcon.heart => 'Cœur',
    CoupleIcon.home => 'Maison',
    CoupleIcon.star => 'Étoile',
    CoupleIcon.leaf => 'Nature',
    CoupleIcon.landscape => 'Paysage',
    CoupleIcon.paw => 'Animal',
    CoupleIcon.sun => 'Soleil',
    CoupleIcon.moon => 'Lune',
    CoupleIcon.gem => 'Bijou',
    CoupleIcon.other => 'Autre',
  };
}
