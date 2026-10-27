import 'package:rechivia/features/notifications/domain/app_notification.dart';

/// Filtres de l'écran Notifications.
enum NotificationFilter {
  all,
  questions,
  couple,
  system;

  bool matches(AppNotification notification) {
    return switch (this) {
      NotificationFilter.all => true,
      NotificationFilter.questions =>
        notification.kind == NotificationKind.newQuestion ||
            notification.kind == NotificationKind.partnerAnswered,
      NotificationFilter.couple =>
        notification.kind == NotificationKind.invitationAccepted,
      NotificationFilter.system => notification.kind == NotificationKind.system,
    };
  }
}
