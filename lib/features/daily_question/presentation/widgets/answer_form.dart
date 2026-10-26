import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/core/widgets/primary_button.dart';
import 'package:rechivia/features/daily_question/domain/answer_validators.dart';

/// Formulaire réutilisable pour une réponse privée à partager.
class AnswerForm extends StatefulWidget {
  const AnswerForm({
    required this.isLoading,
    required this.onSubmit,
    required this.onPass,
    this.onCancel,
    this.passLabel = 'Passer cette question',
    this.privacyNote = defaultPrivacyNote,
    this.submitLabel = 'Partager ma réponse',
    super.key,
  });

  final bool isLoading;
  final ValueChanged<String> onSubmit;
  final VoidCallback onPass;
  final VoidCallback? onCancel;

  /// Texte du bouton "passer".
  final String passLabel;

  /// Rappel de confidentialité affiché sous le champ de saisie.
  final String privacyNote;

  /// Libellé du bouton de partage.
  final String submitLabel;

  /// Rappel par défaut (question du jour).
  static const String defaultPrivacyNote =
      'Votre réponse reste privée : votre partenaire ne la verra que '
      'lorsque vous aurez tous les deux répondu.';

  @override
  State<AnswerForm> createState() => _AnswerFormState();
}

class _AnswerFormState extends State<AnswerForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _controller,
            minLines: 4,
            maxLines: 7,
            maxLength: AnswerValidators.maxLength,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'Écrivez votre réponse ici…',
              alignLabelWithHint: true,
            ),
            validator: AnswerValidators.answer,
          ),
          const SizedBox(height: AppSpacing.md),
          _PrivacyNote(text: widget.privacyNote),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: widget.submitLabel,
            isLoading: widget.isLoading,
            onPressed: widget.isLoading ? null : _submit,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: widget.isLoading ? null : widget.onPass,
            child: Text(widget.passLabel),
          ),
          if (widget.onCancel != null)
            TextButton(
              onPressed: widget.isLoading ? null : widget.onCancel,
              child: const Text('Annuler'),
            ),
        ],
      ),
    );
  }
}

/// Rappel de confidentialité sous le champ de saisie.
class _PrivacyNote extends StatelessWidget {
  const _PrivacyNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.violet.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.field),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            const Icon(Icons.lock_outline, color: AppColors.violet, size: 20),
            const SizedBox(width: AppSpacing.sm + 4),
            Expanded(child: Text(text, style: AppTextStyles.bodySecondary)),
          ],
        ),
      ),
    );
  }
}
