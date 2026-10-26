import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/core/utils/date_formatter.dart';
import 'package:rechivia/core/widgets/app_card.dart';
import 'package:rechivia/features/history/domain/history_entry.dart';
import 'package:rechivia/features/history/presentation/history_presentation.dart';
import 'package:rechivia/features/history/presentation/widgets/history_badges.dart';

/// Carte extensible d'une entrée d'historique.
class HistoryEntryCard extends StatefulWidget {
  const HistoryEntryCard({
    required this.entry,
    required this.onToggleFavorite,
    super.key,
  });

  final HistoryEntry entry;
  final VoidCallback onToggleFavorite;

  @override
  State<HistoryEntryCard> createState() => _HistoryEntryCardState();
}

class _HistoryEntryCardState extends State<HistoryEntryCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    return AppCard(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HistoryKindIcon(kind: entry.kind),
          const SizedBox(width: AppSpacing.sm + 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.kind.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.label.copyWith(
                          color: entry.kind.color,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    HistoryStatusChip(status: entry.status),
                  ],
                ),
                Text(
                  DateFormatter.shortDate(entry.date),
                  style: AppTextStyles.bodySecondary.copyWith(fontSize: 12),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  entry.questionText,
                  style: AppTextStyles.subtitle.copyWith(fontSize: 15),
                ),
                const SizedBox(height: AppSpacing.sm),
                ..._buildAnswers(entry),
              ],
            ),
          ),
          IconButton(
            onPressed: widget.onToggleFavorite,
            tooltip: entry.isFavorite
                ? 'Retirer des favoris'
                : 'Ajouter aux favoris',
            icon: Icon(
              entry.isFavorite ? Icons.star : Icons.star_border,
              color: entry.isFavorite
                  ? AppColors.categoryYellow
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAnswers(HistoryEntry entry) {
    final mine = entry.myAnswer;
    if (mine == null) {
      return [
        Text(
          entry.status == HistoryStatus.expired
              ? 'Cette question a expiré sans réponse.'
              : 'Vous avez passé cette question.',
          style: AppTextStyles.bodySecondary.copyWith(
            fontStyle: FontStyle.italic,
          ),
        ),
      ];
    }

    return [
      _AnswerLine(author: 'Vous', text: mine, maxLines: _isExpanded ? null : 2),
      if (_isExpanded && entry.partnerAnswer != null) ...[
        const SizedBox(height: AppSpacing.sm),
        _AnswerLine(author: 'Votre partenaire', text: entry.partnerAnswer!),
      ],
      if (_isExpanded && entry.status == HistoryStatus.waitingForPartner) ...[
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Votre partenaire n\'a pas encore répondu.',
          style: AppTextStyles.bodySecondary.copyWith(
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    ];
  }
}

class _AnswerLine extends StatelessWidget {
  const _AnswerLine({required this.author, required this.text, this.maxLines});

  final String author;
  final String text;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          author,
          style: AppTextStyles.label.copyWith(
            fontSize: 12,
            color: AppColors.violet,
          ),
        ),
        Text(
          text,
          maxLines: maxLines,
          overflow: maxLines == null ? null : TextOverflow.ellipsis,
          style: AppTextStyles.body.copyWith(fontSize: 14),
        ),
      ],
    );
  }
}
