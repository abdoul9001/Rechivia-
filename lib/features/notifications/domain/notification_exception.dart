/// Raisons pour lesquelles une opération sur les notifications peut échouer.
enum NotificationFailure {
  /// La notification demandée n'existe pas (ou plus).
  unknownNotification,

  network,
  unknown,
}

/// Erreur levée par un `NotificationRepository` quand une opération échoue.
class NotificationException implements Exception {
  const NotificationException(this.failure);

  final NotificationFailure failure;

  @override
  String toString() => 'NotificationException(${failure.name})';
}
