import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';

/// Logo de Rechivia : cœur et nom en dégradé.
///
/// ATTENTION : version provisoire dessinée en code. Elle sera remplacée par
/// l'image officielle du logo quand elle sera disponible ; seul ce fichier
/// devra changer, car tous les écrans passent par ce widget.
class AppLogo extends StatelessWidget {
  const AppLogo({
    this.size = 48,
    this.showName = true,
    this.horizontal = false,
    super.key,
  });

  /// Taille du cœur ; le texte s'adapte proportionnellement.
  final double size;

  /// Affiche le nom "Rechivia" avec le cœur.
  final bool showName;

  /// Place le nom à droite du cœur plutôt qu'en dessous.
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    final heart = _GradientMask(child: Icon(Icons.favorite, size: size));
    final name = _GradientMask(
      child: Text(
        'Rechivia',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: horizontal ? size * 0.8 : size * 0.6,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    if (horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          heart,
          if (showName) ...[const SizedBox(width: AppSpacing.sm), name],
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        heart,
        if (showName) ...[const SizedBox(height: AppSpacing.xs), name],
      ],
    );
  }
}

/// Applique le dégradé de la marque sur un enfant (icône ou texte).
class _GradientMask extends StatelessWidget {
  const _GradientMask({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => AppColors.primaryGradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: child,
    );
  }
}
