import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/core/widgets/app_card.dart';
import 'package:rechivia/features/guided_conversation/domain/guided_step.dart';
import 'package:rechivia/features/preferences/presentation/theme_category_style.dart';

/// Question et contexte de l'étape en cours.
class GuidedStepCard extends StatelessWidget {
  const GuidedStepCard({
    required this.step,
    required this.number,
    required this.total,
    super.key,
  });

  final GuidedStep step;
  final int number;
  final int total;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Étape $number / $total',
                style: AppTextStyles.label.copyWith(color: AppColors.pink),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _CategoryChip(title: step.category.style.title),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm + 4),
          Text(
            step.title,
            style: AppTextStyles.subtitle.copyWith(fontSize: 18),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(step.description, style: AppTextStyles.bodySecondary),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.pink.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.label.copyWith(
            fontSize: 12,
            color: AppColors.pink,
          ),
        ),
      ),
    );
  }
}
