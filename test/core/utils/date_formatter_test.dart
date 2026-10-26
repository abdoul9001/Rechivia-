import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/core/utils/date_formatter.dart';

void main() {
  final now = DateTime(2026, 10, 26, 15, 30);

  group('DateFormatter.relativeDay', () {
    test('aujourd’hui, même tard dans la journée', () {
      expect(
        DateFormatter.relativeDay(DateTime(2026, 10, 26, 0, 5), now: now),
        'Aujourd\'hui',
      );
    });

    test('hier, même si moins de 24 h se sont écoulées', () {
      expect(
        DateFormatter.relativeDay(DateTime(2026, 10, 25, 23, 59), now: now),
        'Hier',
      );
    });

    test('il y a N jours', () {
      expect(
        DateFormatter.relativeDay(DateTime(2026, 10, 21), now: now),
        'Il y a 5 jours',
      );
    });

    test('traverse un changement de mois', () {
      expect(
        DateFormatter.relativeDay(DateTime(2026, 9, 30), now: now),
        'Il y a 26 jours',
      );
    });
  });

  test('shortDate utilise un mois français abrégé', () {
    expect(DateFormatter.shortDate(DateTime(2026, 10, 5)), '5 oct. 2026');
  });
}
