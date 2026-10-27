import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/features/notifications/domain/app_notification.dart';
import 'package:rechivia/features/notifications/domain/notification_filter.dart';
import 'package:rechivia/features/notifications/domain/notification_grouping.dart';
import 'package:rechivia/features/notifications/domain/notification_settings.dart';

AppNotification _notification(
  String id,
  DateTime createdAt, {
  NotificationKind kind = NotificationKind.system,
}) {
  return AppNotification(
    id: id,
    kind: kind,
    title: 'Titre $id',
    body: 'Texte',
    createdAt: createdAt,
  );
}

void main() {
  group('NotificationFilter', () {
    test(
      'Questions inclut la question du jour et la réponse du partenaire',
      () {
        final question = _notification(
          'a',
          DateTime(2026),
          kind: NotificationKind.newQuestion,
        );
        final response = _notification(
          'b',
          DateTime(2026),
          kind: NotificationKind.partnerAnswered,
        );

        expect(NotificationFilter.questions.matches(question), isTrue);
        expect(NotificationFilter.questions.matches(response), isTrue);
        expect(
          NotificationFilter.questions.matches(
            _notification('c', DateTime(2026)),
          ),
          isFalse,
        );
      },
    );

    test('Couple ne garde que les invitations acceptées', () {
      final invitation = _notification(
        'a',
        DateTime(2026),
        kind: NotificationKind.invitationAccepted,
      );

      expect(NotificationFilter.couple.matches(invitation), isTrue);
      expect(
        NotificationFilter.couple.matches(_notification('b', DateTime(2026))),
        isFalse,
      );
    });

    test('Système ne garde que les informations de l’application', () {
      expect(
        NotificationFilter.system.matches(_notification('a', DateTime(2026))),
        isTrue,
      );
      expect(
        NotificationFilter.system.matches(
          _notification(
            'b',
            DateTime(2026),
            kind: NotificationKind.newQuestion,
          ),
        ),
        isFalse,
      );
    });

    test('Toutes garde tout', () {
      expect(
        NotificationFilter.all.matches(_notification('a', DateTime(2026))),
        isTrue,
      );
    });
  });

  group('groupNotificationsByDay', () {
    test('regroupe les notifications, les plus récentes en premier', () {
      final groups = groupNotificationsByDay([
        _notification('ancienne', DateTime(2026, 10, 24, 10)),
        _notification('matin', DateTime(2026, 10, 26, 8)),
        _notification('hier', DateTime(2026, 10, 25, 19)),
        _notification('soir', DateTime(2026, 10, 26, 21)),
      ]);

      expect(groups.map((group) => group.day), [
        DateTime(2026, 10, 26),
        DateTime(2026, 10, 25),
        DateTime(2026, 10, 24),
      ]);
      expect(
        groups.first.notifications.map((notification) => notification.id),
        ['soir', 'matin'],
      );
    });

    test('retourne une liste vide sans notification', () {
      expect(groupNotificationsByDay(const []), isEmpty);
    });
  });

  group('NotificationSettings', () {
    test('tout est activé par défaut, sauf le mode silencieux', () {
      const settings = NotificationSettings();

      expect(settings.dailyQuestion, isTrue);
      expect(settings.partnerAnswers, isTrue);
      expect(settings.coupleEvents, isTrue);
      expect(settings.system, isTrue);
      expect(settings.quietMode, isFalse);
    });

    test('copyWith ne change que le champ demandé', () {
      final settings = const NotificationSettings().copyWith(system: false);

      expect(settings.system, isFalse);
      expect(settings.dailyQuestion, isTrue);
    });

    test('deux réglages identiques sont égaux', () {
      expect(const NotificationSettings(), const NotificationSettings());
      expect(
        const NotificationSettings(quietMode: true),
        isNot(const NotificationSettings()),
      );
    });
  });
}
