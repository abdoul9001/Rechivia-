import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/core/widgets/app_logo.dart';
import 'package:rechivia/features/auth/presentation/providers/auth_providers.dart';
import 'package:rechivia/features/couple/presentation/providers/couple_providers.dart';
import 'package:rechivia/features/daily_question/presentation/providers/daily_question_providers.dart';
import 'package:rechivia/features/home/presentation/widgets/couple_space_card.dart';
import 'package:rechivia/features/home/presentation/widgets/daily_question_card.dart';
import 'package:rechivia/features/home/presentation/widgets/last_conversation_card.dart';
import 'package:rechivia/features/home/presentation/widgets/section_header.dart';

/// Accueil principal : salutation, question du jour, espace et conversation.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final username = ref.watch(currentUserProvider).value?.username;
    final question = ref.watch(dailyQuestionProvider);
    final couple = ref.watch(currentCoupleProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppLogo(size: 28, horizontal: true),
              const SizedBox(height: AppSpacing.lg),
              _Greeting(username: username),
              const SizedBox(height: AppSpacing.lg),
              DailyQuestionCard(
                question: question,
                onOpen: () => context.push(AppRoutes.answer),
                onRetry: () => ref.invalidate(dailyQuestionProvider),
              ),
              const SizedBox(height: AppSpacing.lg),
              const SectionHeader(
                title: 'Mon espace de couple',
                icon: Icons.favorite,
              ),
              const SizedBox(height: AppSpacing.sm + 4),
              CoupleSpaceCard(
                couple: couple,
                onRetry: () => ref.invalidate(currentCoupleProvider),
                onCreate: () => context.go(AppRoutes.createCouple),
                onJoin: () => context.go(AppRoutes.joinCouple),
              ),
              const SizedBox(height: AppSpacing.lg),
              SectionHeader(
                title: 'Dernière conversation',
                icon: Icons.chat_bubble_outline,
                actionLabel: 'Voir l\'historique',
                onAction: () => context.go(AppRoutes.history),
              ),
              const SizedBox(height: AppSpacing.sm + 4),
              const LastConversationCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.username});

  final String? username;

  @override
  Widget build(BuildContext context) {
    final name = username;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                name == null ? 'Bonjour' : 'Bonjour $name',
                style: AppTextStyles.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Icon(Icons.favorite, color: AppColors.pink, size: 22),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        const Text(
          'Aujourd\'hui est une nouvelle occasion de mieux vous découvrir.',
          style: AppTextStyles.bodySecondary,
        ),
      ],
    );
  }
}
