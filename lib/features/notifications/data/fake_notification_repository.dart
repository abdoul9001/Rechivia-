import 'package:rechivia/core/data/simulated_latency.dart';
import 'package:rechivia/features/notifications/domain/app_notification.dart';
import 'package:rechivia/features/notifications/domain/notification_exception.dart';
import 'package:rechivia/features/notifications/domain/notification_repository.dart';
import 'package:rechivia/features/notifications/domain/notification_settings.dart';

/// Implémentation factice de [NotificationRepository], gardée en mémoire.
///
/// Les données d'exemple ne sont pas reliées aux autres dépôts. Les
/// notifications réelles et les notifications système seront branchées au
/// backend.
class FakeNotificationRepository implements NotificationRepository {
  FakeNotificationRepository({
    this.latency = const Duration(milliseconds: 400),
    List<AppNotification>? seedNotifications,
    NotificationSettings initialSettings = const NotificationSettings(),
    DateTime Function()? clock,
  }) : _notifications = List.of(
         seedNotifications ?? _defaultNotifications((clock ?? DateTime.now)()),
       ),
       _settings = initialSettings;

  final Duration latency;
  final List<AppNotification> _notifications;
  NotificationSettings _settings;

  @override
  Future<List<AppNotification>> getNotifications() async {
    await simulateLatency(latency);

    final sorted = [..._notifications]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return List.unmodifiable(sorted);
  }

  @override
  Future<void> markAsRead({required String id}) async {
    await simulateLatency(latency);

    final index = _notifications.indexWhere(
      (notification) => notification.id == id,
    );
    if (index == -1) {
      throw const NotificationException(
        NotificationFailure.unknownNotification,
      );
    }
    _notifications[index] = _notifications[index].copyWith(isRead: true);
  }

  @override
  Future<void> markAllAsRead() async {
    await simulateLatency(latency);

    for (var index = 0; index < _notifications.length; index++) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  @override
  Future<NotificationSettings> getSettings() async {
    await simulateLatency(latency);
    return _settings;
  }

  @override
  Future<void> saveSettings(NotificationSettings settings) async {
    await simulateLatency(latency);
    _settings = settings;
  }

  static List<AppNotification> _defaultNotifications(DateTime now) {
    DateTime at(int daysAgo, int hour, int minute) {
      final moment = DateTime(
        now.year,
        now.month,
        now.day - daysAgo,
        hour,
        minute,
      );
      return moment.isAfter(now) ? now : moment;
    }

    return [
      AppNotification(
        id: 'n-1',
        kind: NotificationKind.newQuestion,
        title: 'Nouvelle question du jour',
        body: 'Votre question du jour est disponible.',
        createdAt: at(0, 8, 30),
      ),
      AppNotification(
        id: 'n-2',
        kind: NotificationKind.partnerAnswered,
        title: 'Votre partenaire a répondu',
        body: 'Répondez à la question du jour pour découvrir vos réponses.',
        createdAt: at(0, 9, 42),
      ),
      AppNotification(
        id: 'n-3',
        kind: NotificationKind.invitationAccepted,
        title: 'Invitation acceptée',
        body: 'Votre partenaire a rejoint votre espace de couple.',
        createdAt: at(1, 19, 32),
        isRead: true,
      ),
      AppNotification(
        id: 'n-4',
        kind: NotificationKind.newQuestion,
        title: 'Nouvelle question du jour',
        body: 'Votre question du jour est disponible.',
        createdAt: at(1, 8, 30),
        isRead: true,
      ),
      AppNotification(
        id: 'n-5',
        kind: NotificationKind.system,
        title: 'Bienvenue sur Rechivia',
        body:
            'Un espace privé pour vous deux. Prenez le temps de vous '
            'découvrir.',
        createdAt: at(3, 10, 0),
        isRead: true,
      ),
    ];
  }
}
