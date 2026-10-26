import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/features/auth/data/fake_auth_repository.dart';
import 'package:rechivia/features/auth/domain/auth_exception.dart';
import 'package:rechivia/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:rechivia/features/profile/presentation/screens/profile_screen.dart';
import 'package:rechivia/features/profile/presentation/screens/settings_screen.dart';

import '../../helpers/pump_rechivia.dart';

Future<FakeAuthRepository> _signedInAuth() async {
  final auth = FakeAuthRepository(latency: Duration.zero);
  await auth.signUp(
    email: 'emilie@mail.com',
    username: 'Émilie',
    password: 'motdepasse1',
  );
  return auth;
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('affiche les réglages du compte', (tester) async {
    await pumpRechivia(
      tester,
      initialLocation: AppRoutes.settings,
      authRepository: await _signedInAuth(),
    );

    expect(find.byType(SettingsScreen), findsOneWidget);
    expect(find.text('Changer le mot de passe'), findsOneWidget);
    expect(find.text('Supprimer mon compte'), findsOneWidget);
  });

  testWidgets('"Retour" ramène au profil', (tester) async {
    await pumpRechivia(
      tester,
      initialLocation: AppRoutes.settings,
      authRepository: await _signedInAuth(),
    );

    await _tap(tester, find.byTooltip('Retour'));

    expect(find.byType(ProfileScreen), findsOneWidget);
  });

  group('Changer le mot de passe', () {
    testWidgets('confirme l\'envoi du lien', (tester) async {
      await pumpRechivia(
        tester,
        initialLocation: AppRoutes.settings,
        authRepository: await _signedInAuth(),
      );

      await _tap(tester, find.text('Changer le mot de passe'));

      expect(find.textContaining('lien de réinitialisation'), findsOneWidget);
    });

    testWidgets('signale une adresse introuvable quand personne n\'est '
        'connecté', (tester) async {
      await pumpRechivia(tester, initialLocation: AppRoutes.settings);

      await _tap(tester, find.text('Changer le mot de passe'));

      expect(find.textContaining('Impossible de retrouver'), findsOneWidget);
    });
  });

  group('Supprimer mon compte', () {
    testWidgets('demande confirmation', (tester) async {
      await pumpRechivia(
        tester,
        initialLocation: AppRoutes.settings,
        authRepository: await _signedInAuth(),
      );

      await _tap(tester, find.text('Supprimer mon compte'));

      expect(find.text('Supprimer votre compte ?'), findsOneWidget);
    });

    testWidgets('annuler garde le compte', (tester) async {
      final auth = await _signedInAuth();
      await pumpRechivia(
        tester,
        initialLocation: AppRoutes.settings,
        authRepository: auth,
      );

      await _tap(tester, find.text('Supprimer mon compte'));
      await tester.tap(find.text('Annuler'));
      await tester.pumpAndSettle();

      expect(find.text('Supprimer votre compte ?'), findsNothing);
      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(await auth.getCurrentUser(), isNotNull);
    });

    testWidgets('confirmer supprime le compte et ouvre la bienvenue',
        (tester) async {
      final auth = await _signedInAuth();
      await pumpRechivia(
        tester,
        initialLocation: AppRoutes.settings,
        authRepository: auth,
      );

      await _tap(tester, find.text('Supprimer mon compte'));
      await tester.tap(find.text('Supprimer'));
      await tester.pumpAndSettle();

      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(await auth.getCurrentUser(), isNull);
      await expectLater(
        auth.signIn(email: 'emilie@mail.com', password: 'motdepasse1'),
        throwsA(isA<AuthException>()),
      );
    });
  });
}
