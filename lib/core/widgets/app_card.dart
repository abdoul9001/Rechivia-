import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';

/// Carte blanche aux coins arrondis, avec une ombre légère.
///
/// Sert de conteneur de base : question du jour, ligne d'historique,
/// bloc de paramètres... Si [onTap] est fourni, la carte est cliquable.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    super.key,
  });

  /// Contenu de la carte.
  final Widget child;

  /// Action au clic ; `null` rend la carte non cliquable.
  final VoidCallback? onTap;

  /// Marge intérieure.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppRadius.card);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: borderRadius,
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.violet.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
