import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';

/// Séparateur "—— ou ——" placé entre deux groupes d'actions.
///
/// Présent sur la bienvenue, l'inscription, la connexion et le mot de passe
/// oublié des maquettes.
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    const line = Expanded(child: Divider(color: AppColors.border));

    return const Row(
      children: [
        line,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text('ou', style: AppTextStyles.bodySecondary),
        ),
        line,
      ],
    );
  }
}
