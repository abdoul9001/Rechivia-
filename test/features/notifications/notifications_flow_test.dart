import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/features/daily_question/presentation/screens/daily_session_screen.dart';
import 'package:rechivia/features/notifications/data/fake_notification_repository.dart';
import 'package:rechivia/features/notifications/presentation/screens/notification_settings_screen.dart';
import 'package:rechivia/features/profile/presentation/screens/profile_screen.dart';

import '../../helpers/pump_rechivia.dart';

Finder _chip(String label) => find.byKey(Key('filter-chip-$label'));

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

FakeNotificationRepository _buildRepository() {
  return FakeNotificationRepository(latency: Duration.zero);
}

void main() {
  group('Liste des notifications', () {
    Future<void> openList(
      WidgetTester tester,
      FakeNotificationRepository repository,
    ) {
      return pumpRechivia(
        tester,
        initialLocation: AppRoutes.notifications,
        notificationRepository: repository,
      );
    }

    testWidgets('affiche les notifications groupées par jour', (tester) async {
      await openList(tester, _buildRepository());

      expect(find.text('Aujourd\'hui'), findsOneWidget);
      expect(find.text('Hier'), findsOneWidget);
      expect(find.text('Votre partenaire a répondu'), findsOneWidget);
      expect(find.text('Invitation acceptée'), findsOneWidget);
    });

    testWidgets('annonce le nombre de non lues', (tester) async {
      await openList(tester, _buildRepository());

      expect(find.text('2 nouvelles notifications'), findsOneWidget);
      expect(find.byKey(const Key('unread-dot')), findsNWidgets(2));
    });

    testWidgets('Tout marquer comme lu retire l’encadré et les pastilles', (
      tester,
    ) async {
      await openList(tester, _buildRepository());

      await _tap(tester, find.text('Tout marquer comme lu'));

      expect(find.text('2 nouvelles notifications'), findsNothing);
      expect(find.byKey(const Key('unread-dot')), findsNothing);
    });

    testWidgets('le filtre Système ne garde que les informations de l’app', (
      tester,
    ) async {
      await openList(tester, _buildRepository());

      await _tap(tester, _chip('Système'));

      expect(find.text('Bienvenue sur Rechivia'), findsOneWidget);
      expect(find.text('Votre partenaire a répondu'), findsNothing);
    });

    testWidgets('le filtre Couple ne garde que l’invitation acceptée', (
      tester,
    ) async {
      await openList(tester, _buildRepository());

      await _tap(tester, _chip('Couple'));

      expect(find.text('Invitation acceptée'), findsOneWidget);
      expect(find.text('Bienvenue sur Rechivia'), findsNothing);
    });

    testWidgets('une notification de question ouvre la question du jour', (
      tester,
    ) async {
      final repository = _buildRepository();
      await openList(tester, repository);

      await _tap(tester, find.text('Votre partenaire a répondu'));

      expect(find.byType(DailySessionScreen), findsOneWidget);
      final notifications = await repository.getNotifications();
      expect(
        notifications
            .firstWhere((notification) => notification.id == 'n-2')
            .isRead,
        isTrue,
      );
    });

    testWidgets('une notification système se lit sans changer d’écran', (
      tester,
    ) async {
      final sample = await _buildRepository().getNotifications();
      final repository = FakeNotificationRepository(
        latency: Duration.zero,
        seedNotifications: [
          sample
              .where((notification) => notification.id == 'n-5')
              .map((notification) => notification.copyWith(isRead: false))
              .single,
        ],
      );
      await openList(tester, repository);

      expect(find.byKey(const Key('unread-dot')), findsOneWidget);
      await _tap(tester, find.text('Bienvenue sur Rechivia'));

      expect(find.byKey(const Key('unread-dot')), findsNothing);
      expect(find.byType(DailySessionScreen), findsNothing);
    });

    testWidgets('affiche un état vide sans notification', (tester) async {
      await openList(
        tester,
        FakeNotificationRepository(
          latency: Duration.zero,
          seedNotifications: const [],
        ),
      );

      expect(find.text('Aucune notification'), findsOneWidget);
    });

    testWidgets('Retour ramène au profil', (tester) async {
      await openList(tester, _buildRepository());

      await _tap(tester, find.byTooltip('Retour'));

      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    testWidgets('l’engrenage ouvre les réglages des notifications', (
      tester,
    ) async {
      await openList(tester, _buildRepository());

      await _tap(tester, find.byTooltip('Réglages des notifications'));

      expect(find.byType(NotificationSettingsScreen), findsOneWidget);
    });
  });

  group('Réglages des notifications', () {
    Future<void> openSettings(
      WidgetTester tester,
      FakeNotificationRepository repository,
    ) {
      return pumpRechivia(
        tester,
        initialLocation: AppRoutes.notificationSettings,
        notificationRepository: repository,
      );
    }

    testWidgets('affiche tous les interrupteurs activés par défaut', (
      tester,
    ) async {
      await openSettings(tester, _buildRepository());

      final switches = tester.widgetList<Switch>(find.byType(Switch)).toList();
      expect(switches, hasLength(5));
      expect(switches.take(4).every((item) => item.value), isTrue);
      expect(switches.last.value, isFalse);
    });

    testWidgets('désactiver un type enregistre le réglage', (tester) async {
      final repository = _buildRepository();
      await openSettings(tester, repository);

      await _tap(tester, find.byType(Switch).first);

      final settings = await repository.getSettings();
      expect(settings.dailyQuestion, isFalse);
      expect(settings.partnerAnswers, isTrue);
      expect(tester.widget<Switch>(find.byType(Switch).first).value, isFalse);
    });

    testWidgets('activer le mode silencieux enregistre le réglage', (
      tester,
    ) async {
      final repository = _buildRepository();
      await openSettings(tester, repository);

      await _tap(tester, find.byType(Switch).last);

      expect((await repository.getSettings()).quietMode, isTrue);
    });

    testWidgets('Notifications des paramètres ouvre les réglages', (
      tester,
    ) async {
      await pumpRechivia(
        tester,
        initialLocation: AppRoutes.settings,
        notificationRepository: _buildRepository(),
      );

      await _tap(tester, find.text('Notifications'));

      expect(find.byType(NotificationSettingsScreen), findsOneWidget);
    });

    testWidgets('Retour depuis les réglages revient aux paramètres du compte', (
      tester,
    ) async {
      await openSettings(tester, _buildRepository());

      await _tap(tester, find.byTooltip('Retour'));

      expect(find.text('Changer le mot de passe'), findsOneWidget);
    });
  });
}
