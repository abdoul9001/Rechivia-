import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/core/utils/date_formatter.dart';
import 'package:rechivia/core/widgets/error_retry_view.dart';
import 'package:rechivia/core/widgets/primary_button.dart';
import 'package:rechivia/features/daily_question/domain/answer_validators.dart';
import 'package:rechivia/features/daily_question/domain/daily_session.dart';
import 'package:rechivia/features/daily_question/domain/daily_session_exception.dart';
import 'package:rechivia/features/daily_question/presentation/providers/daily_question_providers.dart';

/// Écran de réponse, d'attente et de dévoilement de la question du jour.
class DailySessionScreen extends ConsumerStatefulWidget {
  const DailySessionScreen({super.key});

  @override
  ConsumerState<DailySessionScreen> createState() => _DailySessionScreenState();
}

class _DailySessionScreenState extends ConsumerState<DailySessionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _answerController = TextEditingController();
  bool _isSubmitting = false;
  bool _isEditing = false;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(dailySessionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Question du jour'),
        actions: [
          IconButton(
            tooltip: 'Actualiser',
            onPressed: () => ref.invalidate(dailySessionProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: session.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: ErrorRetryView(
                message: 'Impossible de charger votre session du jour.',
                onRetry: () => ref.invalidate(dailySessionProvider),
              ),
            ),
          ),
          data: (data) => _buildSession(data),
        ),
      ),
    );
  }

  Widget _buildSession(DailySession session) {
    if (session.myAnswer != null && _answerController.text.isEmpty) {
      _answerController.text = session.myAnswer!.text;
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _QuestionPanel(session: session),
          const SizedBox(height: AppSpacing.lg),
          switch (session.phase) {
            SessionPhase.toAnswer => _buildAnswerForm(),
            SessionPhase.waitingForPartner => _buildWaitingView(session),
            SessionPhase.revealed => _buildRevealedView(session),
            SessionPhase.iPassed => _buildPassedView(),
            SessionPhase.partnerPassed => _buildPartnerPassedView(session),
          },
        ],
      ),
    );
  }

  Widget _buildAnswerForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Votre réponse reste privée',
            style: AppTextStyles.subtitle,
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Elle sera dévoilée uniquement après la réponse de votre partenaire.',
            style: AppTextStyles.bodySecondary,
          ),
          const SizedBox(height: AppSpacing.md),
          _answerField(),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: 'Envoyer ma réponse',
            isLoading: _isSubmitting,
            onPressed: _isSubmitting ? null : _submitAnswer,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: _isSubmitting ? null : _confirmPass,
            child: const Text('Passer cette question'),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingView(DailySession session) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _StatusCard(
          icon: Icons.hourglass_top,
          title: 'Votre réponse est envoyée',
          message:
              'Votre réponse reste privée. Elle sera dévoilée quand votre partenaire aura répondu.',
        ),
        const SizedBox(height: AppSpacing.md),
        const Text('Votre réponse', style: AppTextStyles.subtitle),
        const SizedBox(height: AppSpacing.sm),
        if (_isEditing)
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _answerField(),
                const SizedBox(height: AppSpacing.md),
                PrimaryButton(
                  label: 'Enregistrer la modification',
                  isLoading: _isSubmitting,
                  onPressed: _isSubmitting ? null : _submitAnswer,
                ),
                TextButton(
                  onPressed: _isSubmitting
                      ? null
                      : () => setState(() {
                          _answerController.text = session.myAnswer!.text;
                          _isEditing = false;
                        }),
                  child: const Text('Annuler'),
                ),
              ],
            ),
          ),
        if (!_isEditing) ...[
          _AnswerCard(text: session.myAnswer!.text),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: () => setState(() => _isEditing = true),
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Modifier ma réponse'),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        _ExpiryLabel(expiresAt: session.expiresAt),
      ],
    );
  }

  Widget _buildRevealedView(DailySession session) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _StatusCard(
          icon: Icons.favorite,
          title: 'Vos réponses sont dévoilées',
          message: 'Prenez un moment pour découvrir vos réponses ensemble.',
        ),
        const SizedBox(height: AppSpacing.md),
        const Text('Votre réponse', style: AppTextStyles.subtitle),
        const SizedBox(height: AppSpacing.sm),
        _AnswerCard(text: session.myAnswer!.text),
        const SizedBox(height: AppSpacing.md),
        const Text(
          'Réponse de votre partenaire',
          style: AppTextStyles.subtitle,
        ),
        const SizedBox(height: AppSpacing.sm),
        _AnswerCard(text: session.partnerAnswer!.text, partner: true),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Envoyée le ${DateFormatter.shortDateTime(session.partnerAnswer!.submittedAt)}',
          style: AppTextStyles.bodySecondary,
          textAlign: TextAlign.end,
        ),
      ],
    );
  }

  Widget _buildPassedView() {
    return const _StatusCard(
      icon: Icons.skip_next,
      title: 'Question passée',
      message:
          'Vous avez passé cette question. Une nouvelle question sera disponible demain.',
    );
  }

  Widget _buildPartnerPassedView(DailySession session) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _StatusCard(
          icon: Icons.favorite_border,
          title: 'Question passée',
          message:
              'Votre partenaire a passé cette question. Une nouvelle question sera disponible demain.',
        ),
        const SizedBox(height: AppSpacing.md),
        const Text('Votre réponse', style: AppTextStyles.subtitle),
        const SizedBox(height: AppSpacing.sm),
        _AnswerCard(text: session.myAnswer!.text),
      ],
    );
  }

  Widget _answerField() {
    return TextFormField(
      controller: _answerController,
      minLines: 4,
      maxLines: 7,
      maxLength: AnswerValidators.maxLength,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        hintText: 'Écrivez votre réponse ici…',
        alignLabelWithHint: true,
      ),
      validator: AnswerValidators.answer,
    );
  }

  Future<void> _submitAnswer() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      await ref
          .read(dailyQuestionRepositoryProvider)
          .submitAnswer(text: _answerController.text);
      if (!mounted) return;
      _isEditing = false;
      ref.invalidate(dailySessionProvider);
    } on DailySessionException catch (error) {
      if (!mounted) return;
      _showMessage(_messageForFailure(error.failure));
    } catch (_) {
      if (!mounted) return;
      _showMessage('Votre réponse n’a pas pu être envoyée. Réessayez.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _confirmPass() async {
    final shouldPass = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Passer cette question ?'),
        content: const Text(
          'Vous ne pourrez plus répondre à cette question aujourd’hui.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Continuer à répondre'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Passer'),
          ),
        ],
      ),
    );
    if (shouldPass != true || !mounted) return;

    setState(() => _isSubmitting = true);
    try {
      await ref.read(dailyQuestionRepositoryProvider).passToday();
      if (!mounted) return;
      ref.invalidate(dailySessionProvider);
    } on DailySessionException catch (error) {
      if (!mounted) return;
      _showMessage(_messageForFailure(error.failure));
    } catch (_) {
      if (!mounted) return;
      _showMessage('La question n’a pas pu être passée. Réessayez.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _messageForFailure(DailySessionFailure failure) {
    return switch (failure) {
      DailySessionFailure.invalidAnswer =>
        'Vérifiez le contenu de votre réponse.',
      DailySessionFailure.alreadyAnswered =>
        'Vous avez déjà répondu à cette question.',
      DailySessionFailure.alreadyRevealed =>
        'Les réponses ont déjà été dévoilées.',
      DailySessionFailure.alreadyPassed =>
        'Vous avez déjà passé cette question.',
      DailySessionFailure.network || DailySessionFailure.unknown =>
        'Cette action n’a pas pu aboutir. Réessayez.',
    };
  }
}

class _QuestionPanel extends StatelessWidget {
  const _QuestionPanel({required this.session});

  final DailySession session;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppColors.warmGradient,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Text(
              'Question du ${DateFormatter.shortDate(session.question.date)}',
              style: AppTextStyles.label,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              session.question.text,
              textAlign: TextAlign.center,
              style: AppTextStyles.subtitle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: AppSpacing.md),
            _ExpiryLabel(expiresAt: session.expiresAt),
          ],
        ),
      ),
    );
  }
}

class _ExpiryLabel extends StatelessWidget {
  const _ExpiryLabel({required this.expiresAt});

  final DateTime expiresAt;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Disponible jusqu’au ${DateFormatter.shortDateTime(expiresAt)}',
      style: AppTextStyles.bodySecondary,
      textAlign: TextAlign.center,
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: AppColors.violet),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: AppTextStyles.subtitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            style: AppTextStyles.bodySecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AnswerCard extends StatelessWidget {
  const _AnswerCard({required this.text, this.partner = false});

  final String text;
  final bool partner;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: partner ? AppColors.pinkLight : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(text, style: AppTextStyles.body),
    );
  }
}
