import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/core/widgets/app_card.dart';
import 'package:rechivia/features/daily_question/domain/participant_status.dart';
import 'package:rechivia/features/guided_conversation/domain/guided_conversation.dart';

/// Récapitulatif des réponses pour une étape terminée.
class StepRecapCard extends StatelessWidget {
  const StepRecapCard({
    required this.entry,
    required this.number,
    required this.myLabel,
    required this.showPartner,
    super.key,
  });

  final GuidedStepEntry entry;
  final int number;
  final String myLabel;
  final bool showPartner;

  @override
  Widget build(BuildContext context) {
    final partnerStatus = entry.partnerStatus;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Étape $number',
            style: AppTextStyles.label.copyWith(color: AppColors.pink),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(entry.step.title, style: AppTextStyles.subtitle),
          const SizedBox(height: AppSpacing.sm + 4),
          _ResponseLine(
            author: myLabel,
            text: entry.myAnswer,
            passedLabel: 'Étape passée',
          ),
          if (showPartner && partnerStatus != null) ...[
            const SizedBox(height: AppSpacing.sm + 4),
            _ResponseLine(
              author: 'Votre partenaire',
              text: entry.partnerAnswer,
              passedLabel: partnerStatus == ParticipantStatus.passed
                  ? 'A passé cette étape'
                  : '',
            ),
          ],
        ],
      ),
    );
  }
}

class _ResponseLine extends StatelessWidget {
  const _ResponseLine({
    required this.author,
    required this.text,
    required this.passedLabel,
  });

  final String author;
  final String? text;
  final String passedLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          author,
          style: AppTextStyles.label.copyWith(color: AppColors.violet),
        ),
        const SizedBox(height: AppSpacing.xs / 2),
        if (text != null)
          Text(text!, style: AppTextStyles.body)
        else
          Text(
            passedLabel,
            style: AppTextStyles.bodySecondary.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }
}
