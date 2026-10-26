import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rechivia/features/guided_conversation/data/fake_guided_conversation_repository.dart';
import 'package:rechivia/features/guided_conversation/domain/guided_conversation.dart';
import 'package:rechivia/features/guided_conversation/domain/guided_conversation_repository.dart';

/// Dépôt de la conversation guidée.
final guidedConversationRepositoryProvider =
    Provider<GuidedConversationRepository>(
      (ref) => FakeGuidedConversationRepository(),
    );

/// Conversation guidée et états de chargement.
final guidedConversationProvider =
    FutureProvider.autoDispose<GuidedConversation>(
      (ref) =>
          ref.watch(guidedConversationRepositoryProvider).getConversation(),
    );

/// Contrôleur des actions sur les étapes.
class GuidedConversationController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> answerStep({required String stepId, required String text}) {
    return _run(
      () => ref
          .read(guidedConversationRepositoryProvider)
          .answerStep(stepId: stepId, text: text),
    );
  }

  Future<bool> passStep(String stepId) {
    return _run(
      () => ref
          .read(guidedConversationRepositoryProvider)
          .passStep(stepId: stepId),
    );
  }

  Future<bool> _run(Future<GuidedConversation> Function() action) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(action);
    if (!ref.mounted) return false;

    if (result.hasError) {
      state = AsyncError<void>(result.error!, result.stackTrace!);
      return false;
    }

    ref.invalidate(guidedConversationProvider);
    state = const AsyncData<void>(null);
    return true;
  }
}

final guidedConversationControllerProvider =
    AsyncNotifierProvider.autoDispose<GuidedConversationController, void>(
      GuidedConversationController.new,
    );
