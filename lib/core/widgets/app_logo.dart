import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_spacing.dart';

/// Logo de Rechivia : cœur et nom en dégradé.
///
/// ATTENTION : version provisoire dessinée en code. Elle sera remplacée par
/// l'image officielle du logo quand elle sera disponible ; seul ce fichier
/// devra changer, car tous les écrans passent par ce widget.
class AppLogo extends StatelessWidget {
  const AppLogo({this.size = 48, this.showName = true, super.key});

  /// Taille du cœur ; le texte s'adapte proportionnellement.
  final double size;

  /// Affiche le nom "Rechivia" sous le cœur.
  final bool showName;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _GradientMask(child: Icon(Icons.favorite, size: size)),
        if (showName) ...[
          const SizedBox(height: AppSpacing.xs),
          _GradientMask(
            child: Text(
              'Rechivia',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: size * 0.6,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
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
