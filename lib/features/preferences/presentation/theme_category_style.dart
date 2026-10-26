import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/features/preferences/domain/theme_category.dart';

/// Apparence d'une catégorie : texte, icône et couleur.
@immutable
class ThemeCategoryStyle {
  const ThemeCategoryStyle({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
}

/// Associe à chaque [ThemeCategory] son apparence.
extension ThemeCategoryPresentation on ThemeCategory {
  ThemeCategoryStyle get style => switch (this) {
    ThemeCategory.loveRomance => const ThemeCategoryStyle(
      title: 'Amour & romantisme',
      description: 'Coups de cœur, gestes tendres, relation',
      icon: Icons.favorite_border,
      color: AppColors.pink,
    ),
    ThemeCategory.intimacyDesire => const ThemeCategoryStyle(
      title: 'Intimité & désir',
      description: 'Envies, fantasmes, complicité',
      icon: Icons.local_fire_department_outlined,
      color: AppColors.violet,
    ),
    ThemeCategory.gamesChallenges => const ThemeCategoryStyle(
      title: 'Jeux & défis',
      description: 'S\'amuser ensemble',
      icon: Icons.sports_esports_outlined,
      color: AppColors.categoryYellow,
    ),
    ThemeCategory.futureProjects => const ThemeCategoryStyle(
      title: 'Avenir & projets',
      description: 'Rêves, objectifs, vie à deux',
      icon: Icons.eco_outlined,
      color: AppColors.categoryGreen,
    ),
    ThemeCategory.personalityDiscovery => const ThemeCategoryStyle(
      title: 'Personnalité & découverte',
      description: 'Se connaître encore plus',
      icon: Icons.psychology_outlined,
      color: AppColors.categoryBlue,
    ),
    ThemeCategory.wellbeingBalance => const ThemeCategoryStyle(
      title: 'Bien-être & équilibre',
      description: 'Santé, stress, quotidien',
      icon: Icons.wb_sunny_outlined,
      color: AppColors.categoryOrange,
    ),
    ThemeCategory.travelAdventure => const ThemeCategoryStyle(
      title: 'Voyages & aventures',
      description: 'Découvertes, escapades, rêves',
      icon: Icons.explore_outlined,
      color: AppColors.categoryTeal,
    ),
    ThemeCategory.other => const ThemeCategoryStyle(
      title: 'Autres',
      description: 'Thèmes personnalisés',
      icon: Icons.more_horiz,
      color: AppColors.textSecondary,
    ),
  };
}
