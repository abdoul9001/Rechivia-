import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';

/// Thème Material de Rechivia.
///
/// Il applique la palette, la police et le style des champs à toute l'app,
/// afin que chaque écran n'ait pas à les redéfinir.
abstract final class AppTheme {
  /// Thème clair (le seul pour l'instant ; le mode sombre viendra avec les
  /// paramètres, maquette 18).
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(seedColor: AppColors.violet)
        .copyWith(
          primary: AppColors.violet,
          secondary: AppColors.pink,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          error: AppColors.error,
        );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: const TextTheme(
        headlineSmall: AppTextStyles.title,
        titleMedium: AppTextStyles.subtitle,
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.bodySecondary,
        labelLarge: AppTextStyles.label,
      ),
      inputDecorationTheme: _inputDecorationTheme,
    );
  }

  /// Style commun des champs de saisie : fond blanc, coins arrondis,
  /// bordure fine qui devient violette quand le champ est actif.
  static InputDecorationTheme get _inputDecorationTheme {
    OutlineInputBorder border(Color color, {double width = 1}) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.field),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      hintStyle: AppTextStyles.bodySecondary,
      border: border(AppColors.border),
      enabledBorder: border(AppColors.border),
      focusedBorder: border(AppColors.violet, width: 1.5),
      errorBorder: border(AppColors.error),
      focusedErrorBorder: border(AppColors.error, width: 1.5),
    );
  }
}
