import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
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

/// Écran d'inscription (maquette 2).
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final success = await ref
        .read(authControllerProvider.notifier)
        .signUp(
          email: _emailController.text.trim(),
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        );

    if (success && mounted) context.go(AppRoutes.themes);
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
      title: 'Créez votre compte',
      subtitle:
          'Rejoignez Rechivia pour partager, vous découvrir '
          'et vous aimer encore plus.',
      onBack: () => context.go(AppRoutes.welcome),
      children: [
        AuthModeSwitch(
          activeLabel: 'Je m\'inscris',
          otherLabel: 'J\'ai déjà un compte',
          onOtherTap: () => context.go(AppRoutes.login),
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
                controller: _usernameController,
                hintText: 'Nom d\'utilisateur',
                prefixIcon: Icons.person_outline,
                textInputAction: TextInputAction.next,
                validator: AuthValidators.username,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _passwordController,
                hintText: 'Mot de passe',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                textInputAction: TextInputAction.next,
                validator: AuthValidators.newPassword,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _confirmController,
                hintText: 'Confirmer le mot de passe',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                textInputAction: TextInputAction.done,
                validator: (value) => AuthValidators.confirmPassword(
                  value,
                  _passwordController.text,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: 'S\'inscrire',
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
          prompt: 'Vous avez déjà un compte ?',
          actionLabel: 'Se connecter',
          onTap: () => context.go(AppRoutes.login),
        ),
      ],
    );
  }
}
