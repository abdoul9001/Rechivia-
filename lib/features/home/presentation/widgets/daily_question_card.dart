import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/core/widgets/error_retry_view.dart';
import 'package:rechivia/core/widgets/primary_button.dart';
import 'package:rechivia/features/daily_question/domain/daily_session.dart';

/// Carte d'accueil qui présente la question du jour.
class DailyQuestionCard extends StatelessWidget {
  const DailyQuestionCard({
    required this.question,
    required this.onOpen,
    required this.onRetry,
    super.key,
  });

  final AsyncValue<DailySession> question;
  final VoidCallback onOpen;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppColors.warmGradient,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.wb_sunny_outlined, color: AppColors.pink, size: 20),
                SizedBox(width: AppSpacing.sm),
                Text('Question du jour', style: AppTextStyles.label),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            question.when(
              data: (data) =>
                  _QuestionContent(text: data.question.text, onOpen: onOpen),
              loading: () => const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, _) => ErrorRetryView(
                message: 'Impossible de charger la question du jour.',
                onRetry: onRetry,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionContent extends StatelessWidget {
  const _QuestionContent({required this.text, required this.onOpen});

  final String text;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                text,
                style: AppTextStyles.subtitle.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        FractionallySizedBox(
          widthFactor: 0.8,
          child: PrimaryButton(label: 'Voir la question', onPressed: onOpen),
        ),
      ],
    );
  }
}
