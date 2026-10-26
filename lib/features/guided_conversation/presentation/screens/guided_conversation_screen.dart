import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/core/widgets/app_snack_bar.dart';
import 'package:rechivia/core/widgets/error_retry_view.dart';
import 'package:rechivia/core/widgets/screen_top_bar.dart';
import 'package:rechivia/features/auth/presentation/providers/auth_providers.dart';
import 'package:rechivia/features/daily_question/presentation/widgets/answer_form.dart';
import 'package:rechivia/features/guided_conversation/domain/guided_conversation.dart';
import 'package:rechivia/features/guided_conversation/presentation/guided_error_messages.dart';
import 'package:rechivia/features/guided_conversation/presentation/providers/guided_conversation_providers.dart';
import 'package:rechivia/features/guided_conversation/presentation/widgets/guided_completion_view.dart';
import 'package:rechivia/features/guided_conversation/presentation/widgets/guided_step_card.dart';
import 'package:rechivia/features/guided_conversation/presentation/widgets/step_progress_indicator.dart';

/// Écran de conversation guidée en cinq étapes.
class GuidedConversationScreen extends ConsumerWidget {
  const GuidedConversationScreen({super.key});

  void _close(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(guidedConversationProvider);
    try {
      await ref.read(guidedConversationProvider.future);
    } on Object {
      // Le provider affiche l'erreur et propose une nouvelle tentative.
    }
  }

  void _onActionStateChanged(
    BuildContext context,
    AsyncValue<void>? previous,
    AsyncValue<void> next,
  ) {
    if (next case AsyncError(:final error)) {
      AppSnackBar.show(context, guidedErrorMessage(error));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      guidedConversationControllerProvider,
      (previous, next) => _onActionStateChanged(context, previous, next),
    );
    final conversation = ref.watch(guidedConversationProvider);
    final isSubmitting = ref
        .watch(guidedConversationControllerProvider)
        .isLoading;
    final username = ref.watch(currentUserProvider).value?.username;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _refresh(ref),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScreenTopBar(onBack: () => _close(context)),
                const SizedBox(height: AppSpacing.md),
                const Text('Conversation guidée', style: AppTextStyles.title),
                const SizedBox(height: AppSpacing.xs),
                const Text(
                  'Des sujets pour vous aider à mieux vous comprendre et '
                  'renforcer votre lien.',
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(height: AppSpacing.lg),
                conversation.when(
                  data: (data) => _ConversationContent(
                    conversation: data,
                    myLabel: username ?? 'Vous',
                    isSubmitting: isSubmitting,
                    onAnswer: (stepId, text) => ref
                        .read(guidedConversationControllerProvider.notifier)
                        .answerStep(stepId: stepId, text: text),
                    onPass: (stepId) => ref
                        .read(guidedConversationControllerProvider.notifier)
                        .passStep(stepId),
                    onRefresh: () => _refresh(ref),
                    onClose: () => _close(context),
                  ),
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, _) => Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xl,
                    ),
                    child: Center(
                      child: ErrorRetryView(
                        message: 'Impossible de charger la conversation.',
                        onRetry: () =>
                            ref.invalidate(guidedConversationProvider),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConversationContent extends StatelessWidget {
  const _ConversationContent({
    required this.conversation,
    required this.myLabel,
    required this.isSubmitting,
    required this.onAnswer,
    required this.onPass,
    required this.onRefresh,
    required this.onClose,
  });

  final GuidedConversation conversation;
  final String myLabel;
  final bool isSubmitting;
  final void Function(String stepId, String text) onAnswer;
  final ValueChanged<String> onPass;
  final VoidCallback onRefresh;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final index = conversation.currentIndex;
    if (index == null) {
      return GuidedCompletionView(
        conversation: conversation,
        myLabel: myLabel,
        onRefresh: onRefresh,
        onClose: onClose,
      );
    }

    final step = conversation.entries[index].step;
    final total = conversation.entries.length;
    return Column(
      children: [
        StepProgressIndicator(total: total, currentIndex: index),
        const SizedBox(height: AppSpacing.lg),
        GuidedStepCard(step: step, number: index + 1, total: total),
        const SizedBox(height: AppSpacing.lg),
        AnswerForm(
          key: ValueKey(step.id),
          isLoading: isSubmitting,
          onSubmit: (text) => onAnswer(step.id, text),
          onPass: () => onPass(step.id),
          passLabel: 'Passer cette étape',
          privacyNote:
              'Votre réponse sera partagée avec votre partenaire '
              'quand vous aurez tous les deux terminé la conversation.',
        ),
      ],
    );
  }
}
