import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/features/notifications/domain/app_notification.dart';

/// Apparence d'un [NotificationKind] : icône et couleur.
extension NotificationKindPresentation on NotificationKind {
  IconData get icon => switch (this) {
    NotificationKind.newQuestion => Icons.help_outline,
    NotificationKind.partnerAnswered => Icons.favorite_border,
    NotificationKind.invitationAccepted => Icons.group_outlined,
    NotificationKind.system => Icons.info_outline,
  };

  Color get color => switch (this) {
    NotificationKind.newQuestion => AppColors.violet,
    NotificationKind.partnerAnswered => AppColors.pink,
    NotificationKind.invitationAccepted => AppColors.categoryGreen,
    NotificationKind.system => AppColors.textSecondary,
  };

  bool get opensDailyQuestion =>
      this == NotificationKind.newQuestion ||
      this == NotificationKind.partnerAnswered;
}
