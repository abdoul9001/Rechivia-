import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/core/widgets/app_logo.dart';

/// Mise en page commune aux écrans d'authentification.
///
/// Le contenu défile : le formulaire reste accessible quand le clavier
/// est ouvert ou sur un petit écran.
class AuthFormLayout extends StatelessWidget {
  const AuthFormLayout({
    required this.title,
    required this.subtitle,
    required this.onBack,
    required this.children,
    super.key,
  });

  final String title;
  final String subtitle;

  /// Action du bouton retour (en haut à gauche).
  final VoidCallback onBack;

  /// Contenu propre à l'écran, affiché sous le sous-titre.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: onBack,
                  tooltip: 'Retour',
                  icon: const Icon(Icons.arrow_back),
                  style: IconButton.styleFrom(
                    foregroundColor: AppColors.violet,
                    backgroundColor: AppColors.violet.withValues(alpha: 0.1),
                  ),
                ),
              ),
              const AppLogo(size: 56),
              const SizedBox(height: AppSpacing.md),
              Text(
                title,
                style: AppTextStyles.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                subtitle,
                style: AppTextStyles.bodySecondary,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
