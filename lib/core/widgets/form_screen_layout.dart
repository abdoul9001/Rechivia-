import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/core/widgets/app_logo.dart';

/// Mise en page commune aux écrans à formulaire (authentification, couple).
///
/// Le contenu défile afin que le formulaire reste accessible avec le clavier
/// ouvert ou sur un petit écran.
class FormScreenLayout extends StatelessWidget {
  const FormScreenLayout({
    required this.title,
    required this.subtitle,
    required this.children,
    this.onBack,
    super.key,
  });

  final String title;
  final String subtitle;

  /// Action du bouton retour. Si `null`, le bouton est masqué.
  final VoidCallback? onBack;

  /// Contenu propre à l'écran.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              if (onBack != null)
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
                )
              else
                const SizedBox(height: AppSpacing.md),
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
