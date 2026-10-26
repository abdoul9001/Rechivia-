import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/core/widgets/app_logo.dart';
import 'package:rechivia/core/widgets/app_snack_bar.dart';
import 'package:rechivia/core/widgets/empty_state_view.dart';
import 'package:rechivia/core/widgets/error_retry_view.dart';
import 'package:rechivia/core/widgets/filter_chips_bar.dart';
import 'package:rechivia/features/history/domain/history_entry.dart';
import 'package:rechivia/features/history/domain/history_filter.dart';
import 'package:rechivia/features/history/presentation/history_error_messages.dart';
import 'package:rechivia/features/history/presentation/providers/history_providers.dart';
import 'package:rechivia/features/history/presentation/widgets/history_entry_card.dart';

/// Historique des sessions passées et filtres associés.
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  HistoryFilter _filter = HistoryFilter.all;

  static String _labelOf(HistoryFilter filter) => switch (filter) {
    HistoryFilter.all => 'Toutes',
    HistoryFilter.waiting => 'En attente',
    HistoryFilter.answered => 'Répondues',
    HistoryFilter.favorites => 'Favoris',
  };

  Future<void> _refresh() async {
    ref.invalidate(historyEntriesProvider);
    try {
      await ref.read(historyEntriesProvider.future);
    } on Object {
      // L'état d'erreur et le bouton de nouvelle tentative sont affichés.
    }
  }

  void _onActionStateChanged(
    AsyncValue<void>? previous,
    AsyncValue<void> next,
  ) {
    if (next case AsyncError(:final error)) {
      AppSnackBar.show(context, historyErrorMessage(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(historyControllerProvider, _onActionStateChanged);
    final entries = ref.watch(historyEntriesProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              const AppLogo(size: 28, horizontal: true),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Historique des questions',
                style: AppTextStyles.title,
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Toutes vos questions, réponses et moments partagés au fil '
                'du temps.',
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: AppSpacing.md),
              FilterChipsBar<HistoryFilter>(
                values: HistoryFilter.values,
                selected: _filter,
                labelOf: _labelOf,
                onSelected: (filter) => setState(() => _filter = filter),
              ),
              const SizedBox(height: AppSpacing.md),
              ..._buildContent(entries),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent(AsyncValue<List<HistoryEntry>> entries) {
    final all = entries.value;
    if (all == null) {
      if (entries.hasError) {
        return [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: ErrorRetryView(
              message: 'Impossible de charger l\'historique.',
              onRetry: () => ref.invalidate(historyEntriesProvider),
            ),
          ),
        ];
      }
      return const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }

    final shown = all.where(_filter.matches).toList();
    if (shown.isEmpty) return [_buildEmptyState()];

    final controller = ref.read(historyControllerProvider.notifier);
    return [
      for (final entry in shown)
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: HistoryEntryCard(
            key: ValueKey(entry.id),
            entry: entry,
            onToggleFavorite: () => controller.setFavorite(
              entryId: entry.id,
              isFavorite: !entry.isFavorite,
            ),
          ),
        ),
    ];
  }

  Widget _buildEmptyState() => switch (_filter) {
    HistoryFilter.all => const EmptyStateView(
      icon: Icons.history,
      title: 'Aucune question pour le moment',
      message: 'Répondez à la question du jour pour commencer votre histoire.',
    ),
    HistoryFilter.waiting => const EmptyStateView(
      icon: Icons.hourglass_empty,
      title: 'Aucune question en attente',
      message: 'Toutes vos questions ont reçu une réponse.',
    ),
    HistoryFilter.answered => const EmptyStateView(
      icon: Icons.chat_bubble_outline,
      title: 'Aucune réponse partagée',
      message:
          'Vos échanges apparaîtront ici dès que vous aurez répondu '
          'tous les deux.',
    ),
    HistoryFilter.favorites => const EmptyStateView(
      icon: Icons.star_border,
      title: 'Pas encore de favoris',
      message: 'Touchez l\'étoile d\'une question pour la retrouver ici.',
    ),
  };
}
