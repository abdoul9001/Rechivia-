import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/core/theme/app_theme.dart';
import 'package:rechivia/core/widgets/primary_button.dart';

/// Affiche un widget dans une mini-app avec le thème de Rechivia.
Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(body: child),
  );
}

void main() {
  group('PrimaryButton', () {
    testWidgets('appelle onPressed quand on appuie', (tester) async {
      var pressed = 0;
      await tester.pumpWidget(
        _wrap(PrimaryButton(label: 'Envoyer', onPressed: () => pressed++)),
      );

      await tester.tap(find.text('Envoyer'));

      expect(pressed, 1);
    });

    testWidgets('ignore les appuis pendant le chargement', (tester) async {
      var pressed = 0;
      await tester.pumpWidget(
        _wrap(
          PrimaryButton(
            label: 'Envoyer',
            isLoading: true,
            onPressed: () => pressed++,
          ),
        ),
      );

      await tester.tap(find.byType(PrimaryButton));

      expect(pressed, 0);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('est inactif quand onPressed est null', (tester) async {
      await tester.pumpWidget(
        _wrap(const PrimaryButton(label: 'Envoyer', onPressed: null)),
      );

      final inkWell = tester.widget<InkWell>(find.byType(InkWell));

      expect(inkWell.onTap, isNull);
    });
  });
}
