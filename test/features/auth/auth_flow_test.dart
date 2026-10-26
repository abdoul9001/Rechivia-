import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/core/widgets/app_bottom_nav_bar.dart';

import '../../helpers/pump_rechivia.dart';

Finder get _fields => find.byType(TextFormField);

void main() {
  group('Connexion', () {
    testWidgets('affiche les erreurs quand les champs sont vides', (
      tester,
    ) async {
      await pumpRechivia(tester, initialLocation: AppRoutes.login);

      await tester.tap(find.text('Se connecter'));
      await tester.pumpAndSettle();

      expect(find.text('Saisissez votre adresse e-mail.'), findsOneWidget);
      expect(find.text('Saisissez votre mot de passe.'), findsOneWidget);
    });

    testWidgets('refuse des identifiants inconnus', (tester) async {
      await pumpRechivia(tester, initialLocation: AppRoutes.login);

      await tester.enterText(_fields.at(0), 'inconnu@mail.com');
      await tester.enterText(_fields.at(1), 'motdepasse1');
      await tester.tap(find.text('Se connecter'));
      await tester.pumpAndSettle();

      expect(find.text('E-mail ou mot de passe incorrect.'), findsOneWidget);
      expect(find.byType(AppBottomNavBar), findsNothing);
    });
  });

  group('Inscription', () {
    testWidgets('refuse deux mots de passe différents', (tester) async {
      await pumpRechivia(tester, initialLocation: AppRoutes.register);

      await tester.enterText(_fields.at(0), 'emilie@mail.com');
      await tester.enterText(_fields.at(1), 'Émilie');
      await tester.enterText(_fields.at(2), 'motdepasse1');
      await tester.enterText(_fields.at(3), 'motdepasse2');
      await tester.tap(find.text('S\'inscrire').first);
      await tester.pumpAndSettle();

      expect(
        find.text('Les mots de passe ne correspondent pas.'),
        findsOneWidget,
      );
    });

    testWidgets('crée le compte et ouvre l\'accueil', (tester) async {
      await pumpRechivia(tester, initialLocation: AppRoutes.register);

      await tester.enterText(_fields.at(0), 'emilie@mail.com');
      await tester.enterText(_fields.at(1), 'Émilie');
      await tester.enterText(_fields.at(2), 'motdepasse1');
      await tester.enterText(_fields.at(3), 'motdepasse1');
      await tester.tap(find.text('S\'inscrire').first);
      await tester.pumpAndSettle();

      expect(find.byType(AppBottomNavBar), findsOneWidget);
    });
  });

  group('Mot de passe oublié', () {
    testWidgets('affiche la confirmation après l\'envoi', (tester) async {
      await pumpRechivia(tester, initialLocation: AppRoutes.forgotPassword);

      await tester.enterText(_fields.at(0), 'emilie@mail.com');
      await tester.tap(find.text('Envoyer le lien'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Si cet e-mail est associé'), findsOneWidget);
      expect(find.text('Renvoyer le lien'), findsOneWidget);
    });
  });
}
