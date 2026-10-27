/// Type d'une notification.
enum NotificationKind {
  /// Une nouvelle question du jour est disponible.
  newQuestion,

  /// Le partenaire a répondu à la question du jour.
  partnerAnswered,

  /// Le partenaire a accepté l'invitation à rejoindre l'espace de couple.
  invitationAccepted,

  /// Information de l'application (bienvenue, mises à jour...).
  system,
}

/// Une notification affichée dans le centre de notifications.
///
/// Le titre et le texte sont neutres : ils ne contiennent jamais le contenu
/// d'une réponse ni d'une question privée, car ils peuvent apparaître sur
/// l'écran verrouillé.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
  });

  final String id;
  final NotificationKind kind;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      kind: kind,
      title: title,
      body: body,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
