import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';

/// Avatar rond en dégradé affichant l'initiale du nom.
///
/// Version provisoire : les photos de profil ne sont pas prévues dans le plan
/// du MVP. Le widget est décoratif (le nom est affiché à côté), donc il est
/// exclu de l'accessibilité.
class UserAvatar extends StatelessWidget {
  const UserAvatar({required this.name, this.size = 88, super.key});

  final String name;

  /// Diamètre du cercle ; la lettre s'adapte proportionnellement.
  final double size;

  String get _initial {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    return String.fromCharCode(trimmed.runes.first).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
        ),
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Text(
              _initial,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: size * 0.4,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
