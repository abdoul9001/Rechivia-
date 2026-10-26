import 'package:go_router/go_router.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/core/router/main_shell.dart';
import 'package:rechivia/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:rechivia/features/auth/presentation/screens/login_screen.dart';
import 'package:rechivia/features/auth/presentation/screens/register_screen.dart';
import 'package:rechivia/features/couple/presentation/screens/create_couple_screen.dart';
import 'package:rechivia/features/couple/presentation/screens/invite_partner_screen.dart';
import 'package:rechivia/features/couple/presentation/screens/join_couple_screen.dart';
import 'package:rechivia/features/daily_question/presentation/screens/daily_session_screen.dart';
import 'package:rechivia/features/guided_conversation/presentation/screens/guided_conversation_screen.dart';
import 'package:rechivia/features/history/presentation/screens/favorites_screen.dart';
import 'package:rechivia/features/history/presentation/screens/history_screen.dart';
import 'package:rechivia/features/home/presentation/screens/home_screen.dart';
import 'package:rechivia/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:rechivia/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:rechivia/features/preferences/presentation/screens/theme_selection_screen.dart';
import 'package:rechivia/features/profile/presentation/screens/profile_screen.dart';
import 'package:rechivia/features/profile/presentation/screens/settings_screen.dart';

/// Construit le routeur de l'application.
///
/// On passe par une fonction (et non une variable globale) pour que chaque
/// test puisse obtenir un routeur neuf, sans état partagé.
///
/// Structure :
/// - le parcours d'entrée (introduction, bienvenue, authentification) ;
/// - 4 onglets regroupés dans [MainShell] (avec l'accueil et la barre de navigation) ;
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
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.history,
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.favorites,
                builder: (context, state) => const FavoritesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: AppRoutes.settingsSegment,
                    builder: (context, state) => const SettingsScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.answer,
        builder: (context, state) => const DailySessionScreen(),
      ),
      GoRoute(
        path: AppRoutes.guidedConversation,
        builder: (context, state) => const GuidedConversationScreen(),
      ),
    ],
  );
}
