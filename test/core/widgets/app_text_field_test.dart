import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/core/theme/app_theme.dart';
import 'package:rechivia/core/widgets/app_text_field.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(body: child),
  );
}

void main() {
  group('AppTextField', () {
    testWidgets("masque le mot de passe puis le révèle avec l'œil", (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const AppTextField(
            hintText: 'Mot de passe',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
          ),
        ),
      );

      // Au départ, la saisie est masquée.
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isTrue,
      );

      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      // Après le clic sur l'œil, elle est visible.
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isFalse,
      );
    });

    testWidgets("n'affiche pas d'œil pour un champ normal", (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AppTextField(
            hintText: 'Adresse e-mail',
            prefixIcon: Icons.mail_outline,
          ),
        ),
      );

      expect(find.byIcon(Icons.visibility_outlined), findsNothing);
    });
  });
}
