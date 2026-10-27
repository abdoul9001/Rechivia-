import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rechivia/features/notifications/data/fake_notification_repository.dart';
import 'package:rechivia/features/notifications/domain/app_notification.dart';
import 'package:rechivia/features/notifications/domain/notification_repository.dart';
import 'package:rechivia/features/notifications/domain/notification_settings.dart';

/// Fournit le dépôt des notifications à toute l'application.
final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => FakeNotificationRepository(),
);

/// Source partagée entre la liste, la cloche et le compteur de non lues.
final notificationsProvider = FutureProvider.autoDispose<List<AppNotification>>(
  (ref) => ref.watch(notificationRepositoryProvider).getNotifications(),
);

/// Nombre de notifications non lues ; la pastille est absente pendant le
/// chargement ou en cas d'erreur.
final unreadNotificationCountProvider = Provider.autoDispose<int>((ref) {
  final notifications = ref.watch(notificationsProvider).value;
  if (notifications == null) return 0;
  return notifications.where((notification) => !notification.isRead).length;
});

final notificationSettingsProvider =
    FutureProvider.autoDispose<NotificationSettings>(
      (ref) => ref.watch(notificationRepositoryProvider).getSettings(),
    );

/// Pilote les actions de notification partagées entre les écrans.
class NotificationController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> markAsRead(String id) {
    return _run(
      () => ref.read(notificationRepositoryProvider).markAsRead(id: id),
      onSuccess: () => ref.invalidate(notificationsProvider),
    );
  }

  Future<bool> markAllAsRead() {
    return _run(
      () => ref.read(notificationRepositoryProvider).markAllAsRead(),
      onSuccess: () => ref.invalidate(notificationsProvider),
    );
  }

  Future<bool> saveSettings(NotificationSettings settings) {
    return _run(
      () => ref.read(notificationRepositoryProvider).saveSettings(settings),
      onSuccess: () => ref.invalidate(notificationSettingsProvider),
    );
  }

  Future<bool> _run(
    Future<void> Function() action, {
    required void Function() onSuccess,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(action);
    if (!ref.mounted) return false;

    if (result.hasError) {
      state = AsyncError<void>(result.error!, result.stackTrace!);
      return false;
    }

    onSuccess();
    state = const AsyncData<void>(null);
    return true;
  }
}

final notificationControllerProvider =
    AsyncNotifierProvider<NotificationController, void>(
      NotificationController.new,
    );
