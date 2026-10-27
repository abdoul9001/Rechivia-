import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/features/notifications/data/fake_notification_repository.dart';
import 'package:rechivia/features/notifications/domain/notification_exception.dart';
import 'package:rechivia/features/notifications/domain/notification_settings.dart';

FakeNotificationRepository _buildRepository() {
  return FakeNotificationRepository(
    latency: Duration.zero,
    clock: () => DateTime(2026, 10, 26, 12),
  );
}

void main() {
  test(
    'trie les notifications de la plus récente à la plus ancienne',
    () async {
      final notifications = await _buildRepository().getNotifications();

      expect(notifications.map((notification) => notification.id), [
        'n-2',
        'n-1',
        'n-3',
        'n-4',
        'n-5',
      ]);
    },
  );

  test('démarre avec 2 notifications non lues', () async {
    final notifications = await _buildRepository().getNotifications();

    expect(
      notifications.where((notification) => !notification.isRead),
      hasLength(2),
    );
  });

  test('ne contient jamais le contenu d’une réponse privée', () async {
    final notifications = await _buildRepository().getNotifications();

    for (final notification in notifications) {
      expect(notification.body, isNot(contains('«')));
      expect(notification.body, isNot(contains('"')));
    }
  });

  group('markAsRead', () {
    test('marque une seule notification comme lue', () async {
      final repository = _buildRepository();

      await repository.markAsRead(id: 'n-1');

      final notifications = await repository.getNotifications();
      expect(
        notifications
            .firstWhere((notification) => notification.id == 'n-1')
            .isRead,
        isTrue,
      );
      expect(
        notifications
            .firstWhere((notification) => notification.id == 'n-2')
            .isRead,
        isFalse,
      );
    });

    test('refuse une notification inconnue', () async {
      await expectLater(
        _buildRepository().markAsRead(id: 'inconnue'),
        throwsA(
          isA<NotificationException>().having(
            (error) => error.failure,
            'failure',
            NotificationFailure.unknownNotification,
          ),
        ),
      );
    });
  });

  test('markAllAsRead marque toutes les notifications comme lues', () async {
    final repository = _buildRepository();

    await repository.markAllAsRead();

    final notifications = await repository.getNotifications();
    expect(notifications.every((notification) => notification.isRead), isTrue);
  });

  group('réglages', () {
    test('utilise les réglages par défaut au départ', () async {
      expect(
        await _buildRepository().getSettings(),
        const NotificationSettings(),
      );
    });

    test('conserve les réglages enregistrés', () async {
      final repository = _buildRepository();

      await repository.saveSettings(
        const NotificationSettings(partnerAnswers: false, quietMode: true),
      );

      final settings = await repository.getSettings();
      expect(settings.partnerAnswers, isFalse);
      expect(settings.quietMode, isTrue);
      expect(settings.dailyQuestion, isTrue);
    });
  });
}
