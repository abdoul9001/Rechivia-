import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/core/utils/date_formatter.dart';
import 'package:rechivia/core/widgets/app_card.dart';
import 'package:rechivia/features/notifications/domain/app_notification.dart';
import 'package:rechivia/features/notifications/presentation/notification_presentation.dart';

/// Notification avec son type, son texte, son heure et son état de lecture.
class NotificationTile extends StatelessWidget {
  const NotificationTile({
    required this.notification,
    required this.onTap,
    super.key,
  });

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final kind = notification.kind;

    return Semantics(
      value: notification.isRead ? 'Lue' : 'Non lue',
      child: AppCard(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: kind.color.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(kind.icon, color: kind.color, size: 20),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm + 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: AppTextStyles.subtitle.copyWith(
                      fontSize: 15,
                      fontWeight: notification.isRead
                          ? FontWeight.w500
                          : FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs / 2),
                  Text(notification.body, style: AppTextStyles.bodySecondary),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormatter.time(notification.createdAt),
                  style: AppTextStyles.bodySecondary.copyWith(fontSize: 12),
                ),
                const SizedBox(height: AppSpacing.xs),
                if (!notification.isRead)
                  const ExcludeSemantics(
                    child: DecoratedBox(
                      key: Key('unread-dot'),
                      decoration: BoxDecoration(
                        color: AppColors.pink,
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox(width: 8, height: 8),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
