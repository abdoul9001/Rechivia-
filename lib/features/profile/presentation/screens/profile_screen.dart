import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/core/widgets/app_card.dart';
import 'package:rechivia/core/widgets/app_logo.dart';
import 'package:rechivia/core/widgets/app_snack_bar.dart';
import 'package:rechivia/core/widgets/error_retry_view.dart';
import 'package:rechivia/core/widgets/primary_button.dart';
import 'package:rechivia/core/widgets/settings_group.dart';
import 'package:rechivia/core/widgets/settings_row.dart';
import 'package:rechivia/core/widgets/user_avatar.dart';
import 'package:rechivia/features/auth/domain/app_user.dart';
import 'package:rechivia/features/auth/presentation/auth_error_messages.dart';
import 'package:rechivia/features/auth/presentation/providers/auth_providers.dart';
import 'package:rechivia/features/couple/domain/couple.dart';
import 'package:rechivia/features/couple/presentation/couple_icon_style.dart';
import 'package:rechivia/features/couple/presentation/providers/couple_providers.dart';

/// Onglet Profil (maquette 17) : identité, espace de couple et raccourcis.
///
/// L'écran lit l'utilisateur et l'espace de couple, puis les distribue à des
/// widgets spécialisés.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  /// Déconnecte puis ouvre l'écran de bienvenue.
  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    if (ref.read(authControllerProvider).isLoading) return;

    final success = await ref.read(authControllerProvider.notifier).signOut();
    if (success && context.mounted) context.go(AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authControllerProvider, (previous, next) {
      if (next case AsyncError(:final error)) {
        AppSnackBar.show(context, authErrorMessage(error));
      }
    });
    final user = ref.watch(currentUserProvider);
    final couple = ref.watch(currentCoupleProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const AppLogo(size: 28, horizontal: true),
            const SizedBox(height: AppSpacing.lg),
            user.when(
              data: (value) => value == null
                  ? _SignedOutView(onLogin: () => context.go(AppRoutes.login))
                  : _ProfileContent(
                      user: value,
                      couple: couple,
                      onCreateCouple: () => context.go(AppRoutes.createCouple),
                      onRetryCouple: () =>
                          ref.invalidate(currentCoupleProvider),
                      onOpenFavorites: () => context.go(AppRoutes.favorites),
                      onOpenSettings: () => context.go(AppRoutes.settings),
                      onSignOut: () => _signOut(context, ref),
                    ),
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, _) => Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: ErrorRetryView(
                  message: 'Impossible de charger votre profil.',
                  onRetry: () => ref.invalidate(currentUserProvider),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Contenu du profil d'un utilisateur connecté.
class _ProfileContent extends StatelessWidget {
  const _ProfileContent({
    required this.user,
    required this.couple,
    required this.onCreateCouple,
    required this.onRetryCouple,
    required this.onOpenFavorites,
    required this.onOpenSettings,
    required this.onSignOut,
  });

  final AppUser user;
  final AsyncValue<Couple?> couple;
  final VoidCallback onCreateCouple;
  final VoidCallback onRetryCouple;
  final VoidCallback onOpenFavorites;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserAvatar(name: user.username),
        const SizedBox(height: AppSpacing.md),
        Text(
          user.username,
          style: AppTextStyles.title,
          textAlign: TextAlign.center,
        ),
        Text(
          user.email,
          style: AppTextStyles.bodySecondary,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        _CoupleSection(
          couple: couple,
          onCreate: onCreateCouple,
          onRetry: onRetryCouple,
        ),
        const SizedBox(height: AppSpacing.lg),
        SettingsGroup(
          children: [
            SettingsRow(
              icon: Icons.photo_library_outlined,
              title: 'Mes souvenirs',
              subtitle: 'Questions et moments favoris',
              onTap: onOpenFavorites,
            ),
            SettingsRow(
              icon: Icons.settings_outlined,
              title: 'Paramètres et confidentialité',
              subtitle: 'Compte et sécurité',
              onTap: onOpenSettings,
            ),
            SettingsRow(
              icon: Icons.logout,
              title: 'Se déconnecter',
              onTap: onSignOut,
            ),
          ],
        ),
      ],
    );
  }
}

/// Carte de l'espace de couple : résumé s'il existe, invitation à le créer
/// sinon. Le lien "Voir l'espace" sera ajouté avec l'écran de l'espace couple.
class _CoupleSection extends StatelessWidget {
  const _CoupleSection({
    required this.couple,
    required this.onCreate,
    required this.onRetry,
  });

  final AsyncValue<Couple?> couple;
  final VoidCallback onCreate;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return couple.when(
      data: (value) {
        if (value == null) {
          return AppCard(
            onTap: onCreate,
            child: const _CoupleTile(
              icon: Icons.favorite_border,
              color: AppColors.pink,
              title: 'Créer mon espace de couple',
              subtitle: 'Vous n\'avez pas encore d\'espace.',
              showChevron: true,
            ),
          );
        }

        return AppCard(
          child: _CoupleTile(
            icon: value.icon.icon,
            color: value.icon.color,
            title: value.name,
            subtitle: 'Votre espace de couple',
          ),
        );
      },
      loading: () => const AppCard(
        child: SizedBox(
          height: 56,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, _) => AppCard(
        child: ErrorRetryView(
          message: 'Impossible de charger votre espace de couple.',
          onRetry: onRetry,
        ),
      ),
    );
  }
}

class _CoupleTile extends StatelessWidget {
  const _CoupleTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.showChevron = false,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.14),
            shape: BoxShape.circle,
          ),
          child: SizedBox(
            width: 48,
            height: 48,
            child: Icon(icon, color: color),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(subtitle, style: AppTextStyles.bodySecondary),
            ],
          ),
        ),
        if (showChevron)
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      ],
    );
  }
}

/// Affiché quand personne n'est connecté (en attendant la redirection
/// automatique prévue avec le backend).
class _SignedOutView extends StatelessWidget {
  const _SignedOutView({required this.onLogin});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.lock_outline, color: AppColors.violet, size: 48),
        const SizedBox(height: AppSpacing.md),
        const Text(
          'Vous n\'êtes pas connecté.',
          style: AppTextStyles.subtitle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(label: 'Se connecter', onPressed: onLogin),
      ],
    );
  }
}
