import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rechivia/features/history/data/fake_history_repository.dart';
import 'package:rechivia/features/history/domain/history_entry.dart';
import 'package:rechivia/features/history/domain/history_repository.dart';

final historyRepositoryProvider = Provider<HistoryRepository>(
  (ref) => FakeHistoryRepository(),
);

/// Source unique pour l'historique, les favoris et l'accueil.
final historyEntriesProvider = FutureProvider.autoDispose<List<HistoryEntry>>(
  (ref) => ref.watch(historyRepositoryProvider).getEntries(),
);

final lastHistoryEntryProvider =
    Provider.autoDispose<AsyncValue<HistoryEntry?>>((ref) {
      return ref
          .watch(historyEntriesProvider)
          .whenData((entries) => entries.isEmpty ? null : entries.first);
    });

class HistoryController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> setFavorite({
    required String entryId,
    required bool isFavorite,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref
          .read(historyRepositoryProvider)
          .setFavorite(entryId: entryId, isFavorite: isFavorite),
    );
    if (!ref.mounted) return false;
    if (result.hasError) {
      state = AsyncError<void>(result.error!, result.stackTrace!);
      return false;
    }
    ref.invalidate(historyEntriesProvider);
    state = const AsyncData<void>(null);
    return true;
  }
}

final historyControllerProvider =
    AsyncNotifierProvider<HistoryController, void>(HistoryController.new);
