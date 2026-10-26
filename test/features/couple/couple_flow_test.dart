import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/core/widgets/app_bottom_nav_bar.dart';
import 'package:rechivia/features/couple/presentation/screens/create_couple_screen.dart';
import 'package:rechivia/features/couple/presentation/screens/invite_partner_screen.dart';
import 'package:rechivia/features/couple/presentation/screens/join_couple_screen.dart';
import 'package:rechivia/features/couple/presentation/widgets/sent_invitation_card.dart';

import '../../helpers/pump_rechivia.dart';

void main() {
  testWidgets('creates a couple then creates and displays an invitation', (
    tester,
  ) async {
    await pumpRechivia(tester, initialLocation: AppRoutes.createCouple);

    await tester.enterText(find.byType(TextFormField).first, 'Nous deux');
    await tester.tap(find.text('Créer mon espace'));
    await tester.pumpAndSettle();

    expect(find.byType(InvitePartnerScreen), findsOneWidget);
    await tester.enterText(
      find.byType(TextFormField).first,
      'partner@example.com',
    );
    await tester.tap(find.text('Créer une invitation'));
    await tester.pumpAndSettle();

    expect(find.text('Votre invitation est prête'), findsOneWidget);
    expect(find.byType(SentInvitationCard), findsOneWidget);
    expect(find.text('Copier le code'), findsOneWidget);
  });

  testWidgets('joins with the development code and opens the home tabs', (
    tester,
  ) async {
    await pumpRechivia(tester, initialLocation: AppRoutes.joinCouple);

    await tester.enterText(find.byType(TextFormField).first, ' k7m2pq ');
    await tester.tap(find.text('Rejoindre'));
    await tester.pumpAndSettle();

    expect(find.byType(AppBottomNavBar), findsOneWidget);
  });

  testWidgets('does not expose details for an invalid invitation', (
    tester,
  ) async {
    await pumpRechivia(tester, initialLocation: AppRoutes.joinCouple);

    await tester.enterText(find.byType(TextFormField).first, 'XXXXXX');
    await tester.tap(find.text('Rejoindre'));
    await tester.pumpAndSettle();

    expect(find.byType(JoinCoupleScreen), findsOneWidget);
    expect(
      find.text(
        'Ce code est invalide ou a expiré. Vérifiez-le puis réessayez.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('validates a couple name before submitting', (tester) async {
    await pumpRechivia(tester, initialLocation: AppRoutes.createCouple);

    await tester.tap(find.text('Créer mon espace'));
    await tester.pumpAndSettle();

    expect(find.byType(CreateCoupleScreen), findsOneWidget);
    expect(find.text('Donnez un nom à votre espace.'), findsOneWidget);
  });
}
