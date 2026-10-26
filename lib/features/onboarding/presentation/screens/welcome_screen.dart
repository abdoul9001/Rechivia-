import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/widgets/or_divider.dart';
import 'package:rechivia/core/widgets/primary_button.dart';
import 'package:rechivia/core/widgets/secondary_button.dart';
import 'package:rechivia/core/widgets/social_button.dart';

/// Écran de bienvenue (maquette 1) : première vraie page de l'application.
///
/// En haut, une ambiance romantique avec le nom et le slogan ; en bas, une
/// feuille blanche avec les choix : créer un compte, se connecter, ou passer
/// par Google ou Apple.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const LinearGradient _sunsetGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.textPrimary,
      AppColors.violet,
      AppColors.pink,
      Color(0xFFFFB38A),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(child: _Hero()),
          _ActionsSheet(
            onRegister: () => context.go(AppRoutes.register),
            onLogin: () => context.go(AppRoutes.login),
            onSocialTap: () => _showComingSoon(context),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Bientôt disponible')));
  }
}

/// Partie haute : fond en dégradé, cœur, nom et slogan.
class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: WelcomeScreen._sunsetGradient),
      child: SafeArea(
        bottom: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.favorite, size: 72, color: Colors.white),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'Rechivia',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Des conversations qui\nrenforcent votre amour.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    color: Colors.white.withValues(alpha: 0.9),
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

/// Partie basse : feuille blanche arrondie contenant les boutons.
class _ActionsSheet extends StatelessWidget {
  const _ActionsSheet({
    required this.onRegister,
    required this.onLogin,
    required this.onSocialTap,
  });

  final VoidCallback onRegister;
  final VoidCallback onLogin;
  final VoidCallback onSocialTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrimaryButton(label: 'Créer un compte', onPressed: onRegister),
              const SizedBox(height: AppSpacing.sm + 4),
              SecondaryButton(label: 'Se connecter', onPressed: onLogin),
              const SizedBox(height: AppSpacing.md),
              const OrDivider(),
              const SizedBox(height: AppSpacing.md),
              SocialButton.google(onPressed: onSocialTap),
              const SizedBox(height: AppSpacing.sm + 4),
              SocialButton.apple(onPressed: onSocialTap),
            ],
          ),
        ),
      ),
    );
  }
}
