import 'package:rechivia/features/notifications/domain/notification_exception.dart';

/// Transforme une erreur technique en message compréhensible.
String notificationErrorMessage(Object error) {
  if (error is NotificationException) {
    return switch (error.failure) {
      NotificationFailure.unknownNotification =>
        'Cette notification n\'existe plus. Actualisez la liste.',
      NotificationFailure.network =>
        'Connexion impossible. Vérifiez votre réseau.',
      NotificationFailure.unknown => _genericMessage,
    };
  }
  return _genericMessage;
}

const String _genericMessage = 'Une erreur est survenue. Réessayez.';
