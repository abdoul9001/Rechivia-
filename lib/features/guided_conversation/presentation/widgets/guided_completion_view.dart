import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/core/widgets/primary_button.dart';
import 'package:rechivia/features/guided_conversation/domain/guided_conversation.dart';
import 'package:rechivia/features/guided_conversation/presentation/widgets/step_recap_card.dart';

/// Récapitulatif affiché lorsque l'utilisateur a traité toutes les étapes.
class GuidedCompletionView extends StatelessWidget {
  const GuidedCompletionView({
    required this.conversation,
    required this.myLabel,
    required this.onRefresh,
    required this.onClose,
    super.key,
  });

  final GuidedConversation conversation;
  final String myLabel;
  final VoidCallback onRefresh;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final isRevealed = conversation.phase == GuidedPhase.revealed;

    return Column(
      children: [
        _Banner(isRevealed: isRevealed),
        const SizedBox(height: AppSpacing.md),
        for (var i = 0; i < conversation.entries.length; i++) ...[
          StepRecapCard(
            entry: conversation.entries[i],
            number: i + 1,
            myLabel: myLabel,
            showPartner: isRevealed,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        const SizedBox(height: AppSpacing.sm),
        if (isRevealed)
          PrimaryButton(label: 'Retour', showArrow: false, onPressed: onClose)
        else
          TextButton.icon(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
            label: const Text('Actualiser'),
          ),
      ],
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.isRevealed});

  final bool isRevealed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.violet.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(
              isRevealed ? Icons.auto_awesome : Icons.hourglass_empty,
              color: AppColors.pink,
            ),
            const SizedBox(width: AppSpacing.sm + 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isRevealed
                        ? 'Conversation terminée !'
                        : 'Bravo, vous avez terminé !',
                    style: AppTextStyles.subtitle,
                  ),
                  Text(
                    isRevealed
                        ? 'Vous avez tous les deux terminé : découvrez vos '
                              'réponses ensemble.'
                        : 'Les réponses de votre partenaire seront dévoilées '
                              'dès qu\'il ou elle aura terminé aussi.',
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
