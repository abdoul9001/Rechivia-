import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';

/// Titre de section d'accueil, avec une action optionnelle.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    required this.icon,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String title;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final label = actionLabel;
    return Row(
      children: [
        Icon(icon, color: AppColors.pink, size: 18),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(title, style: AppTextStyles.subtitle)),
        if (label != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              label,
              style: AppTextStyles.label.copyWith(color: AppColors.violet),
            ),
          ),
      ],
    );
  }
}
