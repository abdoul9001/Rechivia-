import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/features/couple/domain/couple_icon.dart';
import 'package:rechivia/features/couple/presentation/couple_icon_style.dart';

/// Sélecteur compact de l'icône de l'espace.
class CoupleIconPicker extends StatelessWidget {
  const CoupleIconPicker({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final CoupleIcon selected;
  final ValueChanged<CoupleIcon> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final icon in CoupleIcon.values)
          Semantics(
            button: true,
            selected: icon == selected,
            label: icon.label,
            child: InkWell(
              onTap: () => onSelected(icon),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: icon == selected
                      ? icon.color.withValues(alpha: 0.15)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: icon == selected ? icon.color : AppColors.border,
                    width: icon == selected ? 2 : 1,
                  ),
                ),
                child: Icon(icon.icon, color: icon.color, size: 24),
              ),
            ),
          ),
      ],
    );
  }
}
