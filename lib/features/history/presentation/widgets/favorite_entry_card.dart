import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/core/utils/date_formatter.dart';
import 'package:rechivia/core/widgets/app_card.dart';
import 'package:rechivia/features/history/domain/history_entry.dart';
import 'package:rechivia/features/history/presentation/history_presentation.dart';
import 'package:rechivia/features/history/presentation/widgets/history_badges.dart';

/// Carte d'un favori ; le signet le retire de la sélection.
class FavoriteEntryCard extends StatelessWidget {
  const FavoriteEntryCard({
    required this.entry,
    required this.onRemove,
    super.key,
  });

  final HistoryEntry entry;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final mine = entry.myAnswer;
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HistoryKindIcon(kind: entry.kind),
          const SizedBox(width: AppSpacing.sm + 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entry.kind.label} · ${DateFormatter.shortDate(entry.date)}',
                  style: AppTextStyles.bodySecondary.copyWith(fontSize: 12),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  entry.questionText,
                  style: AppTextStyles.subtitle.copyWith(fontSize: 15),
                ),
                if (mine != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Votre réponse',
                    style: AppTextStyles.label.copyWith(
                      fontSize: 12,
                      color: AppColors.violet,
                    ),
                  ),
                  Text(
                    mine,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(fontSize: 14),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            tooltip: 'Retirer des favoris',
            icon: const Icon(Icons.bookmark, color: AppColors.pink),
          ),
        ],
      ),
    );
  }
}
