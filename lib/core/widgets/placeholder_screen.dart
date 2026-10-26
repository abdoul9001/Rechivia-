import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';

/// Écran temporaire affiché à la place d'un écran pas encore construit.
///
/// Il permet de tester la navigation dès maintenant. Chaque utilisation sera
/// remplacée par le vrai écran dans une tâche ultérieure.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({required this.title, super.key});

  /// Nom de l'écran affiché au centre.
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: AppTextStyles.title),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Cet écran sera construit dans une prochaine tâche.',
                style: AppTextStyles.bodySecondary,
                textAlign: TextAlign.center,
              ),
              if (context.canPop()) ...[
                const SizedBox(height: AppSpacing.md),
                TextButton(onPressed: context.pop, child: const Text('Retour')),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
