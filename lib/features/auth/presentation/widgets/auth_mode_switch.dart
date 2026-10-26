import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';

/// Sélecteur à deux segments en haut des écrans d'inscription et de connexion.
class AuthModeSwitch extends StatelessWidget {
  const AuthModeSwitch({
    required this.activeLabel,
    required this.otherLabel,
    required this.onOtherTap,
    super.key,
  });

  final String activeLabel;
  final String otherLabel;
  final VoidCallback onOtherTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.violet.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Row(
          children: [
            Expanded(child: _Segment(label: activeLabel, isActive: true)),
            Expanded(
              child: _Segment(
                label: otherLabel,
                isActive: false,
                onTap: onOtherTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({required this.label, required this.isActive, this.onTap});

  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppRadius.button);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: isActive ? AppColors.primaryGradient : null,
        borderRadius: borderRadius,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: SizedBox(
            height: 44,
            child: Center(
              child: Text(
                label,
                style: AppTextStyles.label.copyWith(
                  color: isActive ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
