import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/core/widgets/app_bottom_nav_bar.dart';
import 'package:rechivia/features/daily_question/presentation/screens/daily_session_screen.dart';
import 'package:rechivia/features/home/presentation/screens/home_screen.dart';
import 'package:rechivia/features/profile/presentation/screens/profile_screen.dart';

import 'helpers/pump_rechivia.dart';

void main() {
  testWidgets('affiche l\'accueil avec la barre de navigation', (tester) async {
    await pumpRechivia(tester, initialLocation: AppRoutes.home);

    expect(find.byType(AppBottomNavBar), findsOneWidget);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('change d\'écran en touchant un onglet', (tester) async {
    await pumpRechivia(tester, initialLocation: AppRoutes.home);

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
  });

  testWidgets('le bouton + ouvre l\'écran de la question du jour', (
    tester,
  ) async {
    await pumpRechivia(tester, initialLocation: AppRoutes.home);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.byType(DailySessionScreen), findsOneWidget);
  });
}
