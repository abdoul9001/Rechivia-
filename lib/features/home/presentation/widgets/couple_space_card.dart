import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/core/widgets/app_card.dart';
import 'package:rechivia/core/widgets/error_retry_view.dart';
import 'package:rechivia/core/widgets/primary_button.dart';
import 'package:rechivia/features/couple/domain/couple.dart';
import 'package:rechivia/features/couple/presentation/couple_icon_style.dart';

/// Carte de résumé ou d'accès à l'espace de couple.
class CoupleSpaceCard extends StatelessWidget {
  const CoupleSpaceCard({
    required this.couple,
    required this.onRetry,
    required this.onCreate,
    required this.onJoin,
    super.key,
  });

  final AsyncValue<Couple?> couple;
  final VoidCallback onRetry;
  final VoidCallback onCreate;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    return couple.when(
      data: (value) => value == null
          ? _NoCouple(onCreate: onCreate, onJoin: onJoin)
          : _CoupleSummary(couple: value),
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

class _CoupleSummary extends StatelessWidget {
  const _CoupleSummary({required this.couple});

  final Couple couple;

  @override
  Widget build(BuildContext context) {
    final icon = couple.icon;
    return AppCard(
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: icon.color.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: SizedBox(
              width: 48,
              height: 48,
              child: Icon(icon.icon, color: icon.color),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  couple.name,
                  style: AppTextStyles.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Text(
                  'Votre espace privé',
                  style: AppTextStyles.bodySecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NoCouple extends StatelessWidget {
  const _NoCouple({required this.onCreate, required this.onJoin});

  final VoidCallback onCreate;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          const Text(
            'Vous n\'avez pas encore d\'espace de couple.',
            style: AppTextStyles.subtitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Créez-le pour inviter votre partenaire.',
            style: AppTextStyles.bodySecondary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(label: 'Créer mon espace', onPressed: onCreate),
          TextButton(
            onPressed: onJoin,
            child: const Text('J\'ai reçu une invitation'),
          ),
        ],
      ),
    );
  }
}
