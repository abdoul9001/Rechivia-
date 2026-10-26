import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';

/// Bloc de réglages : un titre optionnel et une carte contenant des lignes
/// (`SettingsRow`) séparées par un trait fin (maquettes 17 et 18).
///
/// Il fournit le `Material` dont les lignes ont besoin pour afficher l'effet
/// de toucher : les lignes doivent donc toujours être placées dans un groupe.
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({required this.children, this.title, super.key});

  /// Titre au-dessus de la carte ; `null` pour ne rien afficher.
  final String? title;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final heading = title;
    final borderRadius = BorderRadius.circular(AppRadius.card);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (heading != null)
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.xs,
              bottom: AppSpacing.sm,
            ),
            child: Semantics(
              header: true,
              child: Text(
                heading,
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        DecoratedBox(
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
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  for (var i = 0; i < children.length; i++) ...[
                    if (i > 0)
                      const Divider(height: 1, color: AppColors.border),
                    children[i],
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
