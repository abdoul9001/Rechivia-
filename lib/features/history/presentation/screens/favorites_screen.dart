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
import 'package:rechivia/features/history/presentation/widgets/favorite_entry_card.dart';

/// Favoris sélectionnés dans la même source que l'historique.
class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  FavoritesFilter _filter = FavoritesFilter.all;

  static String _labelOf(FavoritesFilter filter) => switch (filter) {
    FavoritesFilter.all => 'Toutes',
    FavoritesFilter.questions => 'Questions',
    FavoritesFilter.conversations => 'Conversations',
  };

  Future<void> _refresh() async {
    ref.invalidate(historyEntriesProvider);
    try {
      await ref.read(historyEntriesProvider.future);
    } on Object {
      // L'erreur est affichée par l'écran lui-même.
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
              const Text('Mes favoris', style: AppTextStyles.title),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Retrouvez ici toutes les questions que vous avez '
                'enregistrées en favoris.',
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: AppSpacing.md),
              FilterChipsBar<FavoritesFilter>(
                values: FavoritesFilter.values,
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
              message: 'Impossible de charger vos favoris.',
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

    final shown = all
        .where((entry) => entry.isFavorite && _filter.matches(entry))
        .toList();
    if (shown.isEmpty) {
      return const [
        EmptyStateView(
          icon: Icons.bookmark_border,
          title: 'Pas encore de favoris',
          message:
              'Mettez une question en favori depuis l\'historique pour '
              'la retrouver ici.',
        ),
      ];
    }

    final controller = ref.read(historyControllerProvider.notifier);
    return [
      for (final entry in shown)
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: FavoriteEntryCard(
            key: ValueKey(entry.id),
            entry: entry,
            onRemove: () =>
                controller.setFavorite(entryId: entry.id, isFavorite: false),
          ),
        ),
    ];
  }
}
