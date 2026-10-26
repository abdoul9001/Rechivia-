import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/app.dart';

void main() {
  // Test de fumée : vérifie que l'application démarre sans erreur.
  testWidgets('RechiviaApp affiche le nom de l\'application', (tester) async {
    await tester.pumpWidget(const RechiviaApp());

    expect(find.text('Rechivia'), findsOneWidget);
  });
}
