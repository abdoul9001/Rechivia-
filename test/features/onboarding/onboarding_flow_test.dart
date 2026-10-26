import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/app.dart';
import 'package:rechivia/features/onboarding/presentation/onboarding_slide.dart';

void main() {
  testWidgets('"Suivant" affiche la diapositive suivante', (tester) async {
    await tester.pumpWidget(const RechiviaApp());
    await tester.pumpAndSettle();

    expect(find.text(onboardingSlides[0].title), findsOneWidget);

    await tester.tap(find.text('Suivant'));
    await tester.pumpAndSettle();

    expect(find.text(onboardingSlides[1].title), findsOneWidget);
  });

  testWidgets('"Passer" mène à l\'écran de bienvenue', (tester) async {
    await tester.pumpWidget(const RechiviaApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Passer'));
    await tester.pumpAndSettle();

    expect(find.text('Créer un compte'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
  });

  testWidgets('la dernière diapositive propose "Commencer"', (tester) async {
    await tester.pumpWidget(const RechiviaApp());
    await tester.pumpAndSettle();

    for (var i = 0; i < onboardingSlides.length - 1; i++) {
      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();
    }

    await tester.tap(find.text('Commencer'));
    await tester.pumpAndSettle();

    expect(find.text('Créer un compte'), findsOneWidget);
  });

  testWidgets('"Créer un compte" ouvre l\'inscription', (tester) async {
    await tester.pumpWidget(const RechiviaApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Passer'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Créer un compte'));
    await tester.pumpAndSettle();

    expect(find.text('Inscription'), findsOneWidget);
  });
}
