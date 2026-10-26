import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/app.dart';
import 'package:rechivia/core/widgets/app_bottom_nav_bar.dart';
import 'package:rechivia/core/widgets/placeholder_screen.dart';

Finder _screenText(String text) {
  return find.descendant(
    of: find.byType(PlaceholderScreen),
    matching: find.text(text),
  );
}

void main() {
  testWidgets('démarre sur l\'accueil avec la barre de navigation', (
    tester,
  ) async {
    await tester.pumpWidget(const RechiviaApp());
    await tester.pumpAndSettle();

    expect(find.byType(AppBottomNavBar), findsOneWidget);
    expect(_screenText('Accueil'), findsOneWidget);
  });

  testWidgets('change d\'écran en touchant un onglet', (tester) async {
    await tester.pumpWidget(const RechiviaApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    expect(_screenText('Profil'), findsOneWidget);
  });

  testWidgets('le bouton + ouvre l\'écran de réponse', (tester) async {
    await tester.pumpWidget(const RechiviaApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(_screenText('Répondre à la question'), findsOneWidget);
    expect(find.byType(AppBottomNavBar), findsNothing);
  });
}
