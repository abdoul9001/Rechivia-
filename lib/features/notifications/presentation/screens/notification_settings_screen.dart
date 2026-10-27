import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/core/widgets/app_snack_bar.dart';
import 'package:rechivia/core/widgets/error_retry_view.dart';
import 'package:rechivia/core/widgets/screen_top_bar.dart';
import 'package:rechivia/core/widgets/settings_group.dart';
import 'package:rechivia/core/widgets/settings_switch_row.dart';
import 'package:rechivia/features/notifications/domain/notification_settings.dart';
import 'package:rechivia/features/notifications/presentation/notification_error_messages.dart';
import 'package:rechivia/features/notifications/presentation/providers/notification_providers.dart';

/// Réglages des notifications ; chaque changement est enregistré sans délai.
class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  void _back(BuildContext context) {
    context.go(AppRoutes.settings);
  }

  void _save(WidgetRef ref, NotificationSettings settings) {
    ref.read(notificationControllerProvider.notifier).saveSettings(settings);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(notificationControllerProvider, (previous, next) {
      if (next case AsyncError(:final error)) {
        AppSnackBar.show(context, notificationErrorMessage(error));
      }
    });
    final settings = ref.watch(notificationSettingsProvider);
    final current = settings.value;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            ScreenTopBar(onBack: () => _back(context)),
            const SizedBox(height: AppSpacing.md),
            const Text('Notifications', style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.xs),
            const Text(
              'Choisissez les alertes que vous souhaitez recevoir.',
              style: AppTextStyles.bodySecondary,
            ),
            const SizedBox(height: AppSpacing.lg),
            if (current != null)
              ..._buildSwitches(ref, current)
            else if (settings.hasError)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: ErrorRetryView(
                  message: 'Impossible de charger vos réglages.',
                  onRetry: () => ref.invalidate(notificationSettingsProvider),
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSwitches(WidgetRef ref, NotificationSettings current) {
    return [
      SettingsGroup(
        title: 'Types de notifications',
        children: [
          SettingsSwitchRow(
            icon: Icons.help_outline,
            title: 'Question du jour',
            subtitle: 'Être prévenu d\'une nouvelle question',
            value: current.dailyQuestion,
            onChanged: (value) =>
                _save(ref, current.copyWith(dailyQuestion: value)),
          ),
          SettingsSwitchRow(
            icon: Icons.favorite_border,
            title: 'Réponses de votre partenaire',
            subtitle: 'Être prévenu quand il ou elle répond',
            value: current.partnerAnswers,
            onChanged: (value) =>
                _save(ref, current.copyWith(partnerAnswers: value)),
          ),
          SettingsSwitchRow(
            icon: Icons.group_outlined,
            title: 'Espace de couple',
            subtitle: 'Invitations et événements du couple',
            value: current.coupleEvents,
            onChanged: (value) =>
                _save(ref, current.copyWith(coupleEvents: value)),
          ),
          SettingsSwitchRow(
            icon: Icons.info_outline,
            title: 'Informations de l\'application',
            subtitle: 'Mises à jour, conseils et infos importantes',
            value: current.system,
            onChanged: (value) => _save(ref, current.copyWith(system: value)),
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.lg),
      SettingsGroup(
        title: 'Mode silencieux',
        children: [
          SettingsSwitchRow(
            icon: Icons.bedtime_outlined,
            title: 'Mode silencieux',
            subtitle: 'Mettre toutes les alertes en pause',
            value: current.quietMode,
            onChanged: (value) =>
                _save(ref, current.copyWith(quietMode: value)),
          ),
        ],
      ),
    ];
  }
}
