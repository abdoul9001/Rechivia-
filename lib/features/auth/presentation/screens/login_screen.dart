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
import 'package:rechivia/core/widgets/social_button.dart';
import 'package:rechivia/features/auth/domain/auth_validators.dart';
import 'package:rechivia/features/auth/presentation/auth_error_messages.dart';
import 'package:rechivia/features/auth/presentation/providers/auth_providers.dart';
import 'package:rechivia/features/auth/presentation/widgets/auth_footer_link.dart';
import 'package:rechivia/features/auth/presentation/widgets/auth_form_layout.dart';
import 'package:rechivia/features/auth/presentation/widgets/auth_mode_switch.dart';

/// Écran de connexion (maquette 3).
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final success = await ref
        .read(authControllerProvider.notifier)
        .signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (success && mounted) context.go(AppRoutes.home);
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
      title: 'Bon retour !',
      subtitle:
          'Retrouvez votre espace de couple\n'
          'et continuez votre histoire.',
      onBack: () => context.go(AppRoutes.welcome),
      children: [
        AuthModeSwitch(
          activeLabel: 'Je me connecte',
          otherLabel: 'Créer un compte',
          onOtherTap: () => context.go(AppRoutes.register),
        ),
        const SizedBox(height: AppSpacing.lg),
        Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                controller: _emailController,
                hintText: 'Adresse e-mail',
                prefixIcon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: AuthValidators.email,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _passwordController,
                hintText: 'Mot de passe',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                textInputAction: TextInputAction.done,
                validator: AuthValidators.existingPassword,
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => context.go(AppRoutes.forgotPassword),
            child: Text(
              'Mot de passe oublié ?',
              style: AppTextStyles.label.copyWith(
                color: AppColors.violet,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.violet,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        PrimaryButton(
          label: 'Se connecter',
          isLoading: isLoading,
          onPressed: _submit,
        ),
        const SizedBox(height: AppSpacing.md),
        const OrDivider(),
        const SizedBox(height: AppSpacing.md),
        SocialButton.google(
          onPressed: () => AppSnackBar.show(context, 'Bientôt disponible'),
        ),
        const SizedBox(height: AppSpacing.sm + 4),
        SocialButton.apple(
          onPressed: () => AppSnackBar.show(context, 'Bientôt disponible'),
        ),
        const SizedBox(height: AppSpacing.lg),
        AuthFooterLink(
          prompt: 'Vous n\'avez pas encore de compte ?',
          actionLabel: 'S\'inscrire',
          onTap: () => context.go(AppRoutes.register),
        ),
      ],
    );
  }
}
