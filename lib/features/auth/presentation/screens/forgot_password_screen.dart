import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/core/widgets/app_snack_bar.dart';
import 'package:rechivia/core/widgets/app_text_field.dart';
import 'package:rechivia/core/widgets/or_divider.dart';
import 'package:rechivia/core/widgets/primary_button.dart';
import 'package:rechivia/core/widgets/secondary_button.dart';
import 'package:rechivia/features/auth/domain/auth_validators.dart';
import 'package:rechivia/features/auth/presentation/auth_error_messages.dart';
import 'package:rechivia/features/auth/presentation/providers/auth_providers.dart';
import 'package:rechivia/features/auth/presentation/widgets/auth_form_layout.dart';

/// Écran "Mot de passe oublié ?" (maquette 4).
///
/// Après l'envoi, un message neutre évite de révéler si l'e-mail est enregistré.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _linkSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final success = await ref
        .read(authControllerProvider.notifier)
        .sendPasswordResetEmail(email: _emailController.text.trim());

    if (success && mounted) setState(() => _linkSent = true);
  }

  void _onStateChanged(AsyncValue<void>? previous, AsyncValue<void> next) {
    if (next case AsyncError(:final error)) {
      AppSnackBar.show(context, authErrorMessage(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authControllerProvider, _onStateChanged);
    final isLoading = ref.watch(authControllerProvider).isLoading;

    return AuthFormLayout(
      title: 'Mot de passe oublié ?',
      subtitle:
          'Pas de souci ! Indiquez votre adresse e-mail et nous vous '
          'enverrons un lien pour réinitialiser votre mot de passe.',
      onBack: () => context.go(AppRoutes.login),
      children: [
        Form(
          key: _formKey,
          child: AppTextField(
            controller: _emailController,
            hintText: 'Adresse e-mail',
            prefixIcon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            validator: AuthValidators.email,
          ),
        ),
        if (_linkSent) ...[
          const SizedBox(height: AppSpacing.md),
          const _ConfirmationMessage(),
        ],
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: _linkSent ? 'Renvoyer le lien' : 'Envoyer le lien',
          isLoading: isLoading,
          onPressed: _submit,
        ),
        const SizedBox(height: AppSpacing.md),
        const OrDivider(),
        const SizedBox(height: AppSpacing.md),
        SecondaryButton(
          label: 'Retour à la connexion',
          icon: Icons.arrow_back,
          onPressed: () => context.go(AppRoutes.login),
        ),
      ],
    );
  }
}

class _ConfirmationMessage extends StatelessWidget {
  const _ConfirmationMessage();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.violet.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.field),
      ),
      child: const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(Icons.mark_email_read_outlined, color: AppColors.violet),
            SizedBox(width: AppSpacing.sm + 4),
            Expanded(
              child: Text(
                'Si cet e-mail est associé à un compte, vous recevrez un '
                'lien de réinitialisation dans quelques minutes.',
                style: AppTextStyles.bodySecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
