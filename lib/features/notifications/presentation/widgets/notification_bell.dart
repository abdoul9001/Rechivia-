import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/features/notifications/presentation/providers/notification_providers.dart';

/// Cloche de l'en-tête de l'accueil, avec le nombre de notifications non lues.
class NotificationBell extends ConsumerWidget {
  const NotificationBell({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(unreadNotificationCountProvider);

    return IconButton(
      onPressed: onPressed,
      tooltip: 'Notifications',
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        backgroundColor: AppColors.pink,
        child: const Icon(
          Icons.notifications_none,
          color: AppColors.violet,
          size: 28,
        ),
      ),
    );
  }
}
