import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/features/notifications/data/fake_notification_repository.dart';
import 'package:rechivia/features/notifications/presentation/screens/notifications_screen.dart';

import '../../helpers/pump_rechivia.dart';

void main() {
  testWidgets('la cloche affiche le nombre de notifications non lues', (
    tester,
  ) async {
    await pumpRechivia(
      tester,
      initialLocation: AppRoutes.home,
      notificationRepository: FakeNotificationRepository(
        latency: Duration.zero,
      ),
    );

    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('la cloche n’a pas de pastille quand tout est lu', (
    tester,
  ) async {
    final repository = FakeNotificationRepository(latency: Duration.zero);
    await repository.markAllAsRead();

    await pumpRechivia(
      tester,
      initialLocation: AppRoutes.home,
      notificationRepository: repository,
    );

    expect(find.text('2'), findsNothing);
  });

  testWidgets('toucher la cloche ouvre le centre de notifications', (
    tester,
  ) async {
    await pumpRechivia(tester, initialLocation: AppRoutes.home);

    await tester.tap(find.byTooltip('Notifications'));
    await tester.pumpAndSettle();

    expect(find.byType(NotificationsScreen), findsOneWidget);
  });
}
