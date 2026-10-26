import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/widgets/app_snack_bar.dart';
import 'package:rechivia/core/widgets/app_text_field.dart';
import 'package:rechivia/core/widgets/form_screen_layout.dart';
import 'package:rechivia/core/widgets/primary_button.dart';
import 'package:rechivia/features/couple/domain/invitation_code.dart';
import 'package:rechivia/features/couple/presentation/providers/couple_controller.dart';

/// Rejoint un espace existant à l'aide d'un code ou d'un lien.
class JoinCoupleScreen extends ConsumerStatefulWidget {
  const JoinCoupleScreen({super.key});

  @override
  ConsumerState<JoinCoupleScreen> createState() => _JoinCoupleScreenState();
}

class _JoinCoupleScreenState extends ConsumerState<JoinCoupleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  String? _validateCode(String? raw) {
    if (InvitationCode.normalize(raw) != null ||
        InvitationCode.fromLink(raw) != null) {
      return null;
    }
    return 'Saisissez un code de 6 caractères ou un lien valide.';
  }

  Future<void> _join() async {
    if (!_formKey.currentState!.validate()) return;
    final raw = _codeController.text;
    final code = InvitationCode.normalize(raw) ?? InvitationCode.fromLink(raw);
    if (code == null) return;
    final couple = await ref
        .read(coupleControllerProvider.notifier)
        .join(code: code);
    if (!mounted) return;
    if (couple == null) {
      AppSnackBar.show(
        context,
        ref.read(coupleControllerProvider).errorMessage ??
            'Une erreur est survenue. Réessayez.',
      );
      return;
    }
    AppSnackBar.show(context, 'Vous avez rejoint ${couple.name}.');
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(coupleControllerProvider);
    return FormScreenLayout(
      title: 'Rejoindre un espace',
      subtitle:
          'Saisissez le code reçu de votre partenaire ou collez son lien '
          'd’invitation.',
      onBack: () => context.go(AppRoutes.createCouple),
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _codeController,
                hintText: 'Code ou lien d’invitation',
                prefixIcon: Icons.key_rounded,
                textInputAction: TextInputAction.done,
                validator: _validateCode,
              ),
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                label: 'Rejoindre',
                isLoading: state.isLoading,
                onPressed: state.isLoading ? null : _join,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextButton(
          onPressed: state.isLoading ? null : () => context.go(AppRoutes.home),
          child: const Text('Je le ferai plus tard'),
        ),
      ],
    );
  }
}
