import 'package:rechivia/features/notifications/domain/app_notification.dart';
import 'package:rechivia/features/notifications/domain/notification_settings.dart';

/// Contrat d'accès aux notifications et à leurs réglages.
abstract interface class NotificationRepository {
  /// Toutes les notifications, de la plus récente à la plus ancienne.
  Future<List<AppNotification>> getNotifications();

  /// Marque une notification comme lue. Sans effet si elle l'est déjà.
  Future<void> markAsRead({required String id});

  /// Marque toutes les notifications comme lues.
  Future<void> markAllAsRead();

  Future<NotificationSettings> getSettings();

  /// Enregistre les réglages, en remplaçant les précédents.
  Future<void> saveSettings(NotificationSettings settings);
}
