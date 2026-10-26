import 'package:go_router/go_router.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/core/router/main_shell.dart';
import 'package:rechivia/core/widgets/placeholder_screen.dart';

/// Construit le routeur de l'application.
///
/// On passe par une fonction (et non une variable globale) pour que chaque
/// test puisse obtenir un routeur neuf, sans état partagé.
///
/// Structure :
/// - 4 onglets regroupés dans [MainShell] (avec la barre de navigation) ;
/// - des écrans plein écran, placés à côté, qui recouvrent la barre.
GoRouter createAppRouter({String initialLocation = AppRoutes.home}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
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
