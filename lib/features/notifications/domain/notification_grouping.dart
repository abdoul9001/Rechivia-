import 'package:rechivia/features/notifications/domain/app_notification.dart';

/// Notifications d'un même jour calendaire.
class NotificationDayGroup {
  NotificationDayGroup({required this.day, required this.notifications});

  /// Jour concerné (sans heure), dans le fuseau de l'utilisateur.
  final DateTime day;

  /// Notifications de ce jour, de la plus récente à la plus ancienne.
  final List<AppNotification> notifications;
}

/// Regroupe les notifications par jour, du plus récent au plus ancien.
List<NotificationDayGroup> groupNotificationsByDay(
  List<AppNotification> notifications,
) {
  final sorted = [...notifications]
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  final groups = <NotificationDayGroup>[];
  for (final notification in sorted) {
    final local = notification.createdAt.toLocal();
    final day = DateTime(local.year, local.month, local.day);

    if (groups.isNotEmpty && groups.last.day == day) {
      groups.last.notifications.add(notification);
    } else {
      groups.add(NotificationDayGroup(day: day, notifications: [notification]));
    }
  }
  return groups;
}
