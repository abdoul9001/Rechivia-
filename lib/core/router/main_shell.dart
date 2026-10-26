import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/core/widgets/app_bottom_nav_bar.dart';

/// Cadre commun des 4 écrans principaux : affiche l'écran de l'onglet actif
/// avec la barre de navigation en bas.
///
/// [navigationShell] est fourni par go_router : il contient l'écran de
/// l'onglet courant et sait changer d'onglet en conservant l'état des autres.
class MainShell extends StatelessWidget {
  const MainShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTabSelected: _onTabSelected,
        onAddPressed: () => context.push(AppRoutes.answer),
      ),
    );
  }

  void _onTabSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
