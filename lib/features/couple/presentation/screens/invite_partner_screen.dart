import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/widgets/app_snack_bar.dart';
import 'package:rechivia/core/widgets/app_text_field.dart';
import 'package:rechivia/core/widgets/form_screen_layout.dart';
import 'package:rechivia/core/widgets/primary_button.dart';
import 'package:rechivia/core/widgets/secondary_button.dart';
import 'package:rechivia/features/couple/domain/couple_validators.dart';
import 'package:rechivia/features/couple/presentation/providers/couple_controller.dart';
import 'package:rechivia/features/couple/presentation/widgets/sent_invitation_card.dart';

/// Invitation d'un partenaire par e-mail ou numéro de téléphone.
class InvitePartnerScreen extends ConsumerStatefulWidget {
  const InvitePartnerScreen({super.key});

  @override
  ConsumerState<InvitePartnerScreen> createState() =>
      _InvitePartnerScreenState();
}

class _InvitePartnerScreenState extends ConsumerState<InvitePartnerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contactController = TextEditingController();

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _invite() async {
    if (!_formKey.currentState!.validate()) return;
    final invitation = await ref
        .read(coupleControllerProvider.notifier)
        .invite(contact: _contactController.text);
    if (!mounted) return;
    if (invitation == null) {
      AppSnackBar.show(
        context,
        ref.read(coupleControllerProvider).errorMessage ??
            'Une erreur est survenue. Réessayez.',
      );
    }
  }

  Future<void> _copyCode(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (mounted) AppSnackBar.show(context, 'Code copié.');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(coupleControllerProvider);
    final invitation = state.invitation;
    return FormScreenLayout(
      title: 'Invitez votre partenaire',
      subtitle: 'Envoyez-lui une invitation pour rejoindre votre espace privé.',
      onBack: () => context.go(AppRoutes.createCouple),
      children: [
        if (invitation == null) ...[
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  controller: _contactController,
                  hintText: 'E-mail ou téléphone',
                  prefixIcon: Icons.person_add_alt_1,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator: CoupleValidators.partnerContact,
                ),
                const SizedBox(height: AppSpacing.md),
                PrimaryButton(
                  label: 'Créer une invitation',
                  showArrow: false,
                  isLoading: state.isLoading,
                  onPressed: state.isLoading ? null : _invite,
                ),
              ],
            ),
          ),
        ] else ...[
          SentInvitationCard(invitation: invitation),
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(
            label: 'Copier le code',
            icon: Icons.copy,
            onPressed: () => _copyCode(invitation.code),
          ),
          const SizedBox(height: AppSpacing.sm),
          PrimaryButton(
            label: 'Terminer',
            showArrow: false,
            onPressed: () => context.go(AppRoutes.home),
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        TextButton(
          onPressed: state.isLoading ? null : () => context.go(AppRoutes.home),
          child: const Text('Annuler'),
        ),
      ],
    );
  }
}
