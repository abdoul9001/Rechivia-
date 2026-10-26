import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';

/// Barre de navigation basse : 4 onglets et un bouton "+" central.
///
/// Ce widget est purement visuel : il ne connaît pas la navigation. Il
/// prévient simplement via [onTabSelected] et [onAddPressed], ce qui le rend
/// réutilisable et facile à tester.
///
/// Les onglets sont numérotés de 0 à 3 (Accueil, Historique, Favoris,
/// Profil) ; le bouton "+" n'est pas un onglet.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    required this.currentIndex,
    required this.onTabSelected,
    required this.onAddPressed,
    super.key,
  });

  /// Onglet actuellement affiché (0 à 3).
  final int currentIndex;

  /// Appelé avec l'index de l'onglet touché.
  final ValueChanged<int> onTabSelected;

  /// Appelé quand on touche le bouton "+" central.
  final VoidCallback onAddPressed;

  static const List<_TabItem> _tabs = [
    _TabItem(
      label: 'Accueil',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
    ),
    _TabItem(
      label: 'Historique',
      icon: Icons.history,
      selectedIcon: Icons.history,
    ),
    _TabItem(
      label: 'Favoris',
      icon: Icons.favorite_border,
      selectedIcon: Icons.favorite,
    ),
    _TabItem(
      label: 'Profil',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.violet.withValues(alpha: 0.10),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Row(
            children: [
              _buildTab(0),
              _buildTab(1),
              Expanded(
                child: Center(child: _AddButton(onPressed: onAddPressed)),
              ),
              _buildTab(2),
              _buildTab(3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(int index) {
    return Expanded(
      child: _NavItem(
        item: _tabs[index],
        isSelected: index == currentIndex,
        onTap: () => onTabSelected(index),
      ),
    );
  }
}

/// Description d'un onglet : son texte et ses deux icônes.
class _TabItem {
  const _TabItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

/// Un onglet : icône et texte, en rose quand il est sélectionné.
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _TabItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.pink : AppColors.textSecondary;

    return InkResponse(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(isSelected ? item.selectedIcon : item.icon, color: color),
          const SizedBox(height: AppSpacing.xs / 2),
          Text(
            item.label,
            style: AppTextStyles.bodySecondary.copyWith(
              fontSize: 11,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Bouton rond "+" en dégradé, au centre de la barre.
class _AddButton extends StatelessWidget {
  const _AddButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Répondre à la question du jour',
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.pink.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: const SizedBox(
              width: 56,
              height: 56,
              child: Icon(Icons.add, color: Colors.white, size: 30),
            ),
          ),
        ),
      ),
    );
  }
}
