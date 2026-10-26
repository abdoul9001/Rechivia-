import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/core/widgets/app_snack_bar.dart';
import 'package:rechivia/core/widgets/confirm_dialog.dart';
import 'package:rechivia/core/widgets/screen_top_bar.dart';
import 'package:rechivia/core/widgets/settings_group.dart';
import 'package:rechivia/core/widgets/settings_row.dart';
import 'package:rechivia/features/auth/presentation/auth_error_messages.dart';
import 'package:rechivia/features/auth/presentation/providers/auth_providers.dart';

/// Écran "Paramètres et confidentialité" (maquette 18).
///
/// Pour l'instant : changer le mot de passe et supprimer le compte. Les
/// notifications (tâche suivante) et la modification des thèmes viendront
/// s'y ajouter ; les pages légales, une fois les textes validés.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  /// Revient au profil, même si l'écran a été ouvert directement.
  void _back(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.profile);
    }
  }

  /// Envoie le lien de réinitialisation à l'adresse du compte connecté.
  Future<void> _changePassword(
    BuildContext context,
    WidgetRef ref,
    String? email,
  ) async {
    if (email == null) {
      AppSnackBar.show(
        context,
        'Impossible de retrouver votre adresse e-mail. Reconnectez-vous.',
      );
      return;
    }
    if (ref.read(authControllerProvider).isLoading) return;

    final success = await ref
        .read(authControllerProvider.notifier)
        .sendPasswordResetEmail(email: email);

    if (success && context.mounted) {
      AppSnackBar.show(
        context,
        'Si cet e-mail est associé à un compte, vous recevrez un lien de '
        'réinitialisation dans quelques minutes.',
      );
    }
  }

  /// Demande confirmation, supprime le compte, puis ouvre la bienvenue.
  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    if (ref.read(authControllerProvider).isLoading) return;

    final confirmed = await showConfirmDialog(
      context,
      title: 'Supprimer votre compte ?',
      message:
          'Cette action est définitive : votre compte sera supprimé et '
          'vous ne pourrez plus vous connecter avec cette adresse e-mail.',
      confirmLabel: 'Supprimer',
      isDestructive: true,
    );
    if (!confirmed || !context.mounted) return;

    final success = await ref
        .read(authControllerProvider.notifier)
        .deleteAccount();
    if (success && context.mounted) context.go(AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authControllerProvider, (previous, next) {
      if (next case AsyncError(:final error)) {
        AppSnackBar.show(context, authErrorMessage(error));
      }
    });
    final email = ref.watch(currentUserProvider).value?.email;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            ScreenTopBar(onBack: () => _back(context)),
            const SizedBox(height: AppSpacing.md),
            const Text('Paramètres', style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.xs),
            const Text(
              'Gérez votre compte en toute sérénité.',
              style: AppTextStyles.bodySecondary,
            ),
            const SizedBox(height: AppSpacing.lg),
            SettingsGroup(
              title: 'Compte',
              children: [
                SettingsRow(
                  icon: Icons.lock_outline,
                  title: 'Changer le mot de passe',
                  subtitle: 'Recevoir un lien par e-mail',
                  onTap: () => _changePassword(context, ref, email),
                ),
                SettingsRow(
                  icon: Icons.delete_outline,
                  title: 'Supprimer mon compte',
                  subtitle: 'Suppression définitive',
                  isDestructive: true,
                  onTap: () => _deleteAccount(context, ref),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
