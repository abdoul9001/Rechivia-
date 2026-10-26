import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';

/// Bouton de connexion avec un service tiers (Google, Apple).
///
/// Utiliser les constructeurs [SocialButton.google] et [SocialButton.apple]
/// plutôt que le constructeur par défaut : le texte et l'icône y sont déjà
/// fixés, ce qui garantit des boutons identiques sur tous les écrans.
class SocialButton extends StatelessWidget {
  const SocialButton._({
    required this.label,
    required this.leading,
    required this.onPressed,
    super.key,
  });

  /// "Continuer avec Google".
  const SocialButton.google({required VoidCallback? onPressed, Key? key})
    : this._(
        label: 'Continuer avec Google',
        leading: const _GoogleMark(),
        onPressed: onPressed,
        key: key,
      );

  /// "Continuer avec Apple".
  const SocialButton.apple({required VoidCallback? onPressed, Key? key})
    : this._(
        label: 'Continuer avec Apple',
        leading: const Icon(Icons.apple, size: 26),
        onPressed: onPressed,
        key: key,
      );

  /// Texte affiché dans le bouton.
  final String label;

  /// Logo du service, affiché avant le texte.
  final Widget leading;

  /// Action au clic ; `null` désactive le bouton.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        foregroundColor: AppColors.textPrimary,
        backgroundColor: AppColors.surface,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          leading,
          const SizedBox(width: AppSpacing.sm + 4),
          Flexible(
            child: Text(
              label,
              style: AppTextStyles.label.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

/// Lettre "G" aux couleurs de Google.
///
/// Version simplifiée : le vrai logo officiel sera ajouté en image lors du
/// branchement de la connexion Google (il a des règles d'usage précises).
class _GoogleMark extends StatelessWidget {
  const _GoogleMark();

  /// Bleu de marque de Google, propre à ce logo (volontairement hors palette).
  static const Color _googleBlue = Color(0xFF4285F4);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'G',
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: _googleBlue,
      ),
    );
  }
}
