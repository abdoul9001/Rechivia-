import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/core/widgets/app_card.dart';

/// État vide honnête jusqu'à l'arrivée des réponses et de l'historique.
class LastConversationCard extends StatelessWidget {
  const LastConversationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      child: Row(
        children: [
          Icon(Icons.chat_bubble_outline, color: AppColors.violet),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pas encore de conversation', style: AppTextStyles.label),
                Text(
                  'Répondez à la question du jour pour commencer votre '
                  'histoire.',
                  style: AppTextStyles.bodySecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
