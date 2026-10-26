import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';

/// Bouton principal de l'application : pilule avec dégradé rose-violet.
///
/// Exemples dans les maquettes : "Créer un compte", "Se connecter",
/// "Envoyer le lien".
///
/// - Si [onPressed] est `null`, le bouton est grisé (désactivé).
/// - Si [isLoading] est vrai, un indicateur remplace le texte et les
///   appuis sont ignorés (évite d'envoyer deux fois un formulaire).
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.showArrow = true,
    this.isLoading = false,
    super.key,
  });

  /// Texte affiché dans le bouton.
  final String label;

  /// Action déclenchée au clic ; `null` désactive le bouton.
  final VoidCallback? onPressed;

  /// Affiche la flèche "→" à droite du texte, comme sur les maquettes.
  final bool showArrow;

  /// Remplace le contenu par un indicateur de chargement.
  final bool isLoading;

  bool get _isEnabled => onPressed != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppRadius.button);

    return Opacity(
      // Un bouton désactivé reste visible mais clairement "éteint".
      opacity: onPressed == null ? 0.5 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: borderRadius,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: _isEnabled ? onPressed : null,
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: Center(child: _buildContent()),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            label,
            style: AppTextStyles.button,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (showArrow) ...[
          const SizedBox(width: AppSpacing.sm),
          const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
        ],
      ],
    );
  }
}
