import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/core/widgets/primary_button.dart';
import 'package:rechivia/features/daily_question/domain/answer.dart';
import 'package:rechivia/features/daily_question/presentation/widgets/answer_card.dart';

/// Réponses dévoilées et invitation à poursuivre avec la conversation guidée.
class RevealView extends StatelessWidget {
  const RevealView({
    required this.myLabel,
    required this.myAnswer,
    required this.partnerAnswer,
    required this.onContinueDiscussion,
    super.key,
  });

  final String myLabel;
  final Answer myAnswer;
  final Answer partnerAnswer;
  final VoidCallback onContinueDiscussion;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _RevealBanner(),
        const SizedBox(height: AppSpacing.md),
        AnswerCard(authorLabel: myLabel, answer: myAnswer, tag: 'Ma réponse'),
        const SizedBox(height: AppSpacing.md),
        AnswerCard(
          authorLabel: 'Votre partenaire',
          answer: partnerAnswer,
          tag: 'Sa réponse',
        ),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: 'Continuer la discussion',
          onPressed: onContinueDiscussion,
        ),
      ],
    );
  }
}

class _RevealBanner extends StatelessWidget {
  const _RevealBanner();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.violet.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(Icons.auto_awesome, color: AppColors.pink),
            SizedBox(width: AppSpacing.sm + 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Découverte des réponses',
                    style: AppTextStyles.subtitle,
                  ),
                  Text(
                    'Prenez le temps de lire la réponse de votre partenaire '
                    'et de la savourer.',
                    style: AppTextStyles.bodySecondary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
