import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/core/utils/date_formatter.dart';
import 'package:rechivia/core/widgets/app_snack_bar.dart';
import 'package:rechivia/core/widgets/empty_state_view.dart';
import 'package:rechivia/core/widgets/error_retry_view.dart';
import 'package:rechivia/core/widgets/filter_chips_bar.dart';
import 'package:rechivia/features/notifications/domain/app_notification.dart';
import 'package:rechivia/features/notifications/domain/notification_exception.dart';
import 'package:rechivia/features/notifications/domain/notification_filter.dart';
import 'package:rechivia/features/notifications/domain/notification_grouping.dart';
import 'package:rechivia/features/notifications/presentation/notification_error_messages.dart';
import 'package:rechivia/features/notifications/presentation/notification_presentation.dart';
import 'package:rechivia/features/notifications/presentation/providers/notification_providers.dart';
import 'package:rechivia/features/notifications/presentation/widgets/notification_tile.dart';

/// Centre de notifications : liste groupée par jour, filtres et compteur.
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  NotificationFilter _filter = NotificationFilter.all;

  static String _labelOf(NotificationFilter filter) {
    return switch (filter) {
      NotificationFilter.all => 'Toutes',
      NotificationFilter.questions => 'Questions',
      NotificationFilter.couple => 'Couple',
      NotificationFilter.system => 'Système',
    };
  }

  void _back() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.profile);
    }
  }

  Future<void> _refresh() async {
    ref.invalidate(notificationsProvider);
    try {
      await ref.read(notificationsProvider.future);
    } on NotificationException catch (error) {
      if (mounted) {
        AppSnackBar.show(context, notificationErrorMessage(error));
      }
    }
  }

  Future<void> _open(AppNotification notification) async {
    if (!notification.isRead) {
      final success = await ref
          .read(notificationControllerProvider.notifier)
          .markAsRead(notification.id);
      if (!success || !mounted) return;
    }

    if (notification.kind.opensDailyQuestion) {
      context.push(AppRoutes.answer);
    }
  }

  void _onActionStateChanged(
    AsyncValue<void>? previous,
    AsyncValue<void> next,
  ) {
    if (next case AsyncError(:final error)) {
      AppSnackBar.show(context, notificationErrorMessage(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(notificationControllerProvider, _onActionStateChanged);
    final notifications = ref.watch(notificationsProvider);
    final unreadCount = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              _Header(
                onBack: _back,
                onOpenSettings: () =>
                    context.go(AppRoutes.notificationSettings),
              ),
              const SizedBox(height: AppSpacing.md),
              FilterChipsBar<NotificationFilter>(
                values: NotificationFilter.values,
                selected: _filter,
                labelOf: _labelOf,
                onSelected: (filter) => setState(() => _filter = filter),
              ),
              const SizedBox(height: AppSpacing.md),
              if (unreadCount > 0) ...[
                _UnreadBanner(
                  count: unreadCount,
                  onMarkAllRead: () => ref
                      .read(notificationControllerProvider.notifier)
                      .markAllAsRead(),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              ..._buildContent(notifications),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent(AsyncValue<List<AppNotification>> notifications) {
    final all = notifications.value;
    if (all == null) {
      if (notifications.hasError) {
        return [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: ErrorRetryView(
              message: 'Impossible de charger vos notifications.',
              onRetry: () => ref.invalidate(notificationsProvider),
            ),
          ),
        ];
      }
      return const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }

    final shown = all.where(_filter.matches).toList();
    if (shown.isEmpty) {
      return const [
        EmptyStateView(
          icon: Icons.notifications_none,
          title: 'Aucune notification',
          message: 'Vos nouvelles notifications apparaîtront ici.',
        ),
      ];
    }

    return [
      for (final group in groupNotificationsByDay(shown)) ...[
        Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.sm,
            bottom: AppSpacing.sm,
          ),
          child: Semantics(
            header: true,
            child: Text(
              DateFormatter.relativeDay(group.day),
              style: AppTextStyles.label.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
        for (final notification in group.notifications)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm + 4),
            child: NotificationTile(
              key: ValueKey(notification.id),
              notification: notification,
              onTap: () => _open(notification),
            ),
          ),
      ],
    ];
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack, required this.onOpenSettings});

  final VoidCallback onBack;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          tooltip: 'Retour',
          icon: const Icon(Icons.arrow_back),
          style: IconButton.styleFrom(
            foregroundColor: AppColors.violet,
            backgroundColor: AppColors.violet.withValues(alpha: 0.1),
          ),
        ),
        const Expanded(
          child: Text(
            'Notifications',
            style: AppTextStyles.subtitle,
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          onPressed: onOpenSettings,
          tooltip: 'Réglages des notifications',
          icon: const Icon(Icons.settings_outlined, color: AppColors.violet),
        ),
      ],
    );
  }
}

class _UnreadBanner extends StatelessWidget {
  const _UnreadBanner({required this.count, required this.onMarkAllRead});

  final int count;
  final VoidCallback onMarkAllRead;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.violet.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.notifications_active, color: AppColors.pink),
                const SizedBox(width: AppSpacing.sm + 4),
                Expanded(
                  child: Text(
                    count == 1
                        ? '1 nouvelle notification'
                        : '$count nouvelles notifications',
                    style: AppTextStyles.subtitle,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onMarkAllRead,
                child: const Text('Tout marquer comme lu'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
