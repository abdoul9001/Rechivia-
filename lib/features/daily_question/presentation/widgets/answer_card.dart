import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/core/widgets/app_card.dart';
import 'package:rechivia/features/daily_question/domain/answer.dart';

/// Carte de réponse avec son auteur et son horodatage.
class AnswerCard extends StatelessWidget {
  const AnswerCard({
    required this.authorLabel,
    required this.answer,
    required this.tag,
    super.key,
  });

  final String authorLabel;
  final Answer answer;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  authorLabel,
                  style: AppTextStyles.label.copyWith(color: AppColors.violet),
                ),
              ),
              Text(
                tag,
                style: AppTextStyles.label.copyWith(color: AppColors.pink),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(answer.text, style: AppTextStyles.body),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Envoyée le ${answer.submittedAt.day.toString().padLeft(2, '0')}/'
            '${answer.submittedAt.month.toString().padLeft(2, '0')}/'
            '${answer.submittedAt.year}',
            style: AppTextStyles.bodySecondary,
          ),
        ],
      ),
    );
  }
}
