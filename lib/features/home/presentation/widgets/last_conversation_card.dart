import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/core/utils/date_formatter.dart';
import 'package:rechivia/core/widgets/app_card.dart';
import 'package:rechivia/core/widgets/error_retry_view.dart';
import 'package:rechivia/features/history/domain/history_entry.dart';
import 'package:rechivia/features/history/presentation/widgets/history_badges.dart';

/// Résumé de la dernière entrée d'historique ou invitation à commencer.
class LastConversationCard extends StatelessWidget {
  const LastConversationCard({
    required this.entry,
    required this.onOpen,
    required this.onRetry,
    super.key,
  });

  final AsyncValue<HistoryEntry?> entry;
  final VoidCallback onOpen;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return entry.when(
      data: (value) => value == null
          ? const _EmptyCard()
          : _EntryCard(entry: value, onTap: onOpen),
      loading: () => const AppCard(
        child: SizedBox(
          height: 56,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, _) => AppCard(
        child: ErrorRetryView(
          message: 'Impossible de charger la dernière conversation.',
          onRetry: onRetry,
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard();

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

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry, required this.onTap});

  final HistoryEntry entry;
  final VoidCallback onTap;

  String get _summary {
    if (entry.myAnswer != null) {
      return 'Vous avez répondu à « ${entry.questionText} »';
    }
    if (entry.status == HistoryStatus.passed) {
      return 'Question passée : « ${entry.questionText} »';
    }
    return 'Question expirée : « ${entry.questionText} »';
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          HistoryKindIcon(kind: entry.kind),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label,
                ),
                Text(
                  DateFormatter.relativeDay(entry.date),
                  style: AppTextStyles.bodySecondary.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
