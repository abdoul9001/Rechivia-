import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/core/widgets/app_logo.dart';
import 'package:rechivia/core/widgets/app_snack_bar.dart';
import 'package:rechivia/core/widgets/primary_button.dart';
import 'package:rechivia/features/preferences/domain/theme_category.dart';
import 'package:rechivia/features/preferences/presentation/providers/theme_selection_controller.dart';
import 'package:rechivia/features/preferences/presentation/widgets/theme_category_grid.dart';

/// Écran de choix des thèmes, affiché après l'inscription.
class ThemeSelectionScreen extends ConsumerWidget {
  const ThemeSelectionScreen({super.key});

  Future<void> _onContinue(BuildContext context, WidgetRef ref) async {
    final success = await ref
        .read(themeSelectionControllerProvider.notifier)
        .save();
    if (!context.mounted) return;

    if (success) {
      _leave(context);
    } else {
      AppSnackBar.show(context, 'Enregistrement impossible. Réessayez.');
    }
  }

  void _leave(BuildContext context) => context.go(AppRoutes.createCouple);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(themeSelectionControllerProvider);
    final controller = ref.read(themeSelectionControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: state.isSaving ? null : () => _leave(context),
                child: const Text('Plus tard'),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  children: [
                    const AppLogo(size: 48),
                    const SizedBox(height: AppSpacing.md),
                    const Text(
                      'Choisissez vos thèmes',
                      style: AppTextStyles.title,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const Text(
                      'Sélectionnez les catégories qui vous intéressent. '
                      'Vous pourrez les modifier plus tard dans les '
                      'paramètres.',
                      style: AppTextStyles.bodySecondary,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ThemeCategoryGrid(
                      categories: ThemeCategory.values,
                      selected: state.selected,
                      onToggle: controller.toggle,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: PrimaryButton(
                label: 'Continuer',
                isLoading: state.isSaving,
                onPressed: state.canContinue
                    ? () => _onContinue(context, ref)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
