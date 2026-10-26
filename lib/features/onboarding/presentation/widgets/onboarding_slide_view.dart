import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/features/onboarding/presentation/onboarding_slide.dart';

/// Affichage d'une diapositive : grande icône dans un disque en dégradé,
/// titre et description centrés.
class OnboardingSlideView extends StatelessWidget {
  const OnboardingSlideView({required this.slide, super.key});

  final OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.pink.withValues(alpha: 0.30),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: SizedBox(
              width: 160,
              height: 160,
              child: Icon(slide.icon, size: 72, color: Colors.white),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            slide.title,
            style: AppTextStyles.title,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            slide.description,
            style: AppTextStyles.bodySecondary.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
