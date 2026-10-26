import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/features/preferences/domain/theme_category.dart';
import 'package:rechivia/features/preferences/presentation/theme_category_style.dart';

/// Carte d'une catégorie : icône colorée, titre, description et case à cocher.
class ThemeCategoryCard extends StatelessWidget {
  const ThemeCategoryCard({
    required this.category,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final ThemeCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = category.style;
    final borderRadius = BorderRadius.circular(AppRadius.card);

    return Semantics(
      button: true,
      selected: isSelected,
      label: '${style.title}. ${style.description}',
      excludeSemantics: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.pink.withValues(alpha: 0.06)
              : AppColors.surface,
          borderRadius: borderRadius,
          border: Border.all(
            color: isSelected ? AppColors.pink : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md - 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _CategoryIcon(icon: style.icon, color: style.color),
                      const Spacer(),
                      _SelectionIndicator(isSelected: isSelected),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm + 4),
                  Text(
                    style.title,
                    style: AppTextStyles.subtitle.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    style.description,
                    style: AppTextStyles.bodySecondary.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}

class _SelectionIndicator extends StatelessWidget {
  const _SelectionIndicator({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: isSelected ? AppColors.primaryGradient : null,
        shape: BoxShape.circle,
        border: isSelected
            ? null
            : Border.all(color: AppColors.border, width: 1.5),
      ),
      child: SizedBox(
        width: 24,
        height: 24,
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 16)
            : null,
      ),
    );
  }
}
