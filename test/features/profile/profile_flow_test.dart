import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/core/widgets/app_bottom_nav_bar.dart';
import 'package:rechivia/features/auth/data/fake_auth_repository.dart';
import 'package:rechivia/features/couple/data/fake_couple_repository.dart';
import 'package:rechivia/features/couple/domain/couple_icon.dart';
import 'package:rechivia/features/history/presentation/screens/favorites_screen.dart';
import 'package:rechivia/features/onboarding/presentation/screens/welcome_screen.dart';
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
  testWidgets('affiche le nom et l\'adresse e-mail', (tester) async {
    await pumpRechivia(
      tester,
      initialLocation: AppRoutes.profile,
      authRepository: await _signedInAuth(),
    );

    expect(find.text('Émilie'), findsOneWidget);
    expect(find.text('emilie@mail.com'), findsOneWidget);
  });

  testWidgets('affiche l\'espace de couple quand il existe', (tester) async {
    final couples = FakeCoupleRepository(latency: Duration.zero);
    await couples.createCouple(name: 'Nous deux', icon: CoupleIcon.heart);

    await pumpRechivia(
      tester,
      initialLocation: AppRoutes.profile,
      authRepository: await _signedInAuth(),
      coupleRepository: couples,
    );

    expect(find.text('Nous deux'), findsOneWidget);
  });

  testWidgets('propose de créer un espace quand il n\'y en a pas',
      (tester) async {
    await pumpRechivia(
      tester,
      initialLocation: AppRoutes.profile,
      authRepository: await _signedInAuth(),
    );

    await _tap(tester, find.text('Créer mon espace de couple'));

    expect(find.text('Créez votre espace de couple'), findsOneWidget);
  });

  testWidgets('"Mes souvenirs" ouvre les favoris', (tester) async {
    await pumpRechivia(
      tester,
      initialLocation: AppRoutes.profile,
      authRepository: await _signedInAuth(),
    );

    await _tap(tester, find.text('Mes souvenirs'));

    expect(find.byType(FavoritesScreen), findsOneWidget);
  });

  testWidgets('ouvre les paramètres en gardant la barre de navigation',
      (tester) async {
    await pumpRechivia(
      tester,
      initialLocation: AppRoutes.profile,
      authRepository: await _signedInAuth(),
    );

    await _tap(tester, find.text('Paramètres et confidentialité'));

    expect(find.byType(SettingsScreen), findsOneWidget);
    expect(find.byType(AppBottomNavBar), findsOneWidget);
  });

  testWidgets('"Se déconnecter" ramène à l\'écran de bienvenue',
      (tester) async {
    final auth = await _signedInAuth();
    await pumpRechivia(
      tester,
      initialLocation: AppRoutes.profile,
      authRepository: auth,
    );

    await _tap(tester, find.text('Se déconnecter'));

    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(await auth.getCurrentUser(), isNull);
  });

  testWidgets('propose de se connecter quand personne n\'est connecté',
      (tester) async {
    await pumpRechivia(tester, initialLocation: AppRoutes.profile);

    expect(find.text('Vous n\'êtes pas connecté.'), findsOneWidget);

    await _tap(tester, find.text('Se connecter'));

    expect(find.text('Bon retour !'), findsOneWidget);
  });
}
