import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/core/widgets/app_bottom_nav_bar.dart';
import 'package:rechivia/core/widgets/primary_button.dart';
import 'package:rechivia/features/preferences/data/fake_preferences_repository.dart';
import 'package:rechivia/features/preferences/domain/theme_category.dart';
import 'package:rechivia/features/preferences/presentation/theme_category_style.dart';

import '../../helpers/pump_rechivia.dart';

String _title(ThemeCategory category) => category.style.title;

void main() {
  testWidgets('affiche les catégories sans en pré-sélectionner aucune', (
    tester,
  ) async {
    await pumpRechivia(tester, initialLocation: AppRoutes.themes);

    expect(find.text(_title(ThemeCategory.loveRomance)), findsOneWidget);
    expect(find.text(_title(ThemeCategory.gamesChallenges)), findsOneWidget);
    expect(find.byIcon(Icons.check), findsNothing);
  });

  testWidgets('"Continuer" est désactivé tant qu\'aucun thème n\'est choisi', (
    tester,
  ) async {
    await pumpRechivia(tester, initialLocation: AppRoutes.themes);

    final button = tester.widget<PrimaryButton>(find.byType(PrimaryButton));

    expect(button.onPressed, isNull);
  });

  testWidgets('toucher une carte la coche, puis la décoche', (tester) async {
    await pumpRechivia(tester, initialLocation: AppRoutes.themes);

    await tester.tap(find.text(_title(ThemeCategory.loveRomance)));
    await tester.pump();
    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(find.text(_title(ThemeCategory.loveRomance)));
    await tester.pump();
    expect(find.byIcon(Icons.check), findsNothing);
  });

  testWidgets('"Continuer" enregistre les thèmes puis ouvre l\'accueil', (
    tester,
  ) async {
    final repository = FakePreferencesRepository(latency: Duration.zero);
    await pumpRechivia(
      tester,
      initialLocation: AppRoutes.themes,
      preferencesRepository: repository,
    );

    await tester.tap(find.text(_title(ThemeCategory.loveRomance)));
    await tester.tap(find.text(_title(ThemeCategory.gamesChallenges)));
    await tester.pump();
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();

    expect(repository.savedThemes, {
      ThemeCategory.loveRomance,
      ThemeCategory.gamesChallenges,
    });
    expect(find.byType(AppBottomNavBar), findsOneWidget);
  });

  testWidgets('"Plus tard" ouvre l\'accueil sans rien enregistrer', (
    tester,
  ) async {
    final repository = FakePreferencesRepository(latency: Duration.zero);
    await pumpRechivia(
      tester,
      initialLocation: AppRoutes.themes,
      preferencesRepository: repository,
    );

    await tester.tap(find.text('Plus tard'));
    await tester.pumpAndSettle();

    expect(repository.savedThemes, isEmpty);
    expect(find.byType(AppBottomNavBar), findsOneWidget);
  });
}
