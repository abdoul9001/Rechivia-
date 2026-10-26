import 'package:go_router/go_router.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/core/router/main_shell.dart';
import 'package:rechivia/core/widgets/placeholder_screen.dart';
import 'package:rechivia/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:rechivia/features/auth/presentation/screens/login_screen.dart';
import 'package:rechivia/features/auth/presentation/screens/register_screen.dart';
import 'package:rechivia/features/couple/presentation/screens/create_couple_screen.dart';
import 'package:rechivia/features/couple/presentation/screens/invite_partner_screen.dart';
import 'package:rechivia/features/couple/presentation/screens/join_couple_screen.dart';
import 'package:rechivia/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:rechivia/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:rechivia/features/preferences/presentation/screens/theme_selection_screen.dart';

/// Construit le routeur de l'application.
///
/// On passe par une fonction (et non une variable globale) pour que chaque
/// test puisse obtenir un routeur neuf, sans état partagé.
///
/// Structure :
/// - le parcours d'entrée (introduction, bienvenue, authentification) ;
/// - 4 onglets regroupés dans [MainShell] (avec la barre de navigation) ;
/// - des écrans plein écran, placés à côté, qui recouvrent la barre.
///
/// L'application démarre sur l'introduction ; plus tard, la redirection
/// selon l'état de connexion enverra un utilisateur connecté à l'accueil.
GoRouter createAppRouter({String initialLocation = AppRoutes.onboarding}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.themes,
        builder: (context, state) => const ThemeSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.createCouple,
        builder: (context, state) => const CreateCoupleScreen(),
      ),
      GoRoute(
        path: AppRoutes.invitePartner,
        builder: (context, state) => const InvitePartnerScreen(),
      ),
      GoRoute(
        path: AppRoutes.joinCouple,
        builder: (context, state) => const JoinCoupleScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          _tabBranch(AppRoutes.home, 'Accueil'),
          _tabBranch(AppRoutes.history, 'Historique'),
          _tabBranch(AppRoutes.favorites, 'Favoris'),
          _tabBranch(AppRoutes.profile, 'Profil'),
        ],
      ),
      GoRoute(
        path: AppRoutes.answer,
        builder: (context, state) {
          return const PlaceholderScreen(title: 'Répondre à la question');
        },
      ),
    ],
  );
}

/// Crée la branche d'un onglet. Les écrans réels remplaceront les
/// placeholders au fil des tâches.
StatefulShellBranch _tabBranch(String path, String title) {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: path,
        builder: (context, state) => PlaceholderScreen(title: title),
      ),
    ],
  );
}
