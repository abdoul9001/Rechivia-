import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/widgets/app_card.dart';
import 'package:rechivia/features/couple/domain/invitation.dart';

/// Affiche le code de l'invitation sans exposer l'adresse du destinataire.
class SentInvitationCard extends StatelessWidget {
  const SentInvitationCard({required this.invitation, super.key});

  final Invitation invitation;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          const Icon(Icons.mark_email_read_outlined, size: 40),
          const SizedBox(height: AppSpacing.sm),
          const Text('Votre invitation est prête'),
          const SizedBox(height: AppSpacing.sm),
          SelectableText(
            invitation.code,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.violet,
              fontWeight: FontWeight.bold,
              letterSpacing: 6,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Valable jusqu’au ${MaterialLocalizations.of(context).formatMediumDate(invitation.expiresAt)}',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Partagez ce code avec votre partenaire. Il ne peut être utilisé '
            'qu’une seule fois.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
