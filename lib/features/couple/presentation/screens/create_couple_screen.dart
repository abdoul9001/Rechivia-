import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/widgets/app_snack_bar.dart';
import 'package:rechivia/core/widgets/app_text_field.dart';
import 'package:rechivia/core/widgets/form_screen_layout.dart';
import 'package:rechivia/core/widgets/primary_button.dart';
import 'package:rechivia/core/widgets/secondary_button.dart';
import 'package:rechivia/features/couple/domain/couple_icon.dart';
import 'package:rechivia/features/couple/domain/couple_validators.dart';
import 'package:rechivia/features/couple/presentation/providers/couple_controller.dart';
import 'package:rechivia/features/couple/presentation/widgets/couple_benefits_card.dart';
import 'package:rechivia/features/couple/presentation/widgets/couple_icon_picker.dart';

/// Création de l'espace partagé avant l'invitation du partenaire.
class CreateCoupleScreen extends ConsumerStatefulWidget {
  const CreateCoupleScreen({super.key});

  @override
  ConsumerState<CreateCoupleScreen> createState() => _CreateCoupleScreenState();
}

class _CreateCoupleScreenState extends ConsumerState<CreateCoupleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  CoupleIcon _selectedIcon = CoupleIcon.heart;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (!_formKey.currentState!.validate()) return;
    final couple = await ref
        .read(coupleControllerProvider.notifier)
        .create(name: _nameController.text, icon: _selectedIcon);
    if (!mounted) return;
    if (couple == null) {
      AppSnackBar.show(
        context,
        ref.read(coupleControllerProvider).errorMessage ??
            'Une erreur est survenue. Réessayez.',
      );
      return;
    }
    context.go(AppRoutes.invitePartner);
  }

  void _later() => context.go(AppRoutes.home);

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(coupleControllerProvider);
    return FormScreenLayout(
      title: 'Créez votre espace de couple',
      subtitle:
          'Un lieu privé pour vous retrouver et répondre ensemble, '
          'à votre rythme.',
      onBack: () => context.go(AppRoutes.themes),
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _nameController,
                hintText: 'Ex. : Nous deux',
                prefixIcon: Icons.favorite_outline,
                textInputAction: TextInputAction.done,
                validator: CoupleValidators.coupleName,
              ),
              const SizedBox(height: AppSpacing.md),
              const Text('Choisissez une icône'),
              const SizedBox(height: AppSpacing.sm),
              CoupleIconPicker(
                selected: _selectedIcon,
                onSelected: (icon) => setState(() => _selectedIcon = icon),
              ),
              const SizedBox(height: AppSpacing.lg),
              const CoupleBenefitsCard(),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Créer mon espace',
                isLoading: state.isLoading,
                onPressed: state.isLoading ? null : _create,
              ),
              const SizedBox(height: AppSpacing.sm),
              SecondaryButton(
                label: 'J’ai un code d’invitation',
                onPressed: state.isLoading
                    ? null
                    : () => context.go(AppRoutes.joinCouple),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: state.isLoading ? null : _later,
                child: const Text('Je le ferai plus tard'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
