import 'package:flutter/material.dart';

/// Contenu d'une diapositive du carrousel d'introduction.
class OnboardingSlide {
  const OnboardingSlide({
    required this.icon,
    required this.title,
    required this.description,
  });

  /// Icône illustrant la diapositive.
  final IconData icon;

  final String title;
  final String description;
}

/// Les diapositives affichées, dans l'ordre (maquette 0, cartes 2 à 4).
///
/// Pour ajouter ou modifier une diapositive, il suffit de changer cette liste :
/// l'écran s'adapte tout seul (nombre de points, bouton "Commencer").
const List<OnboardingSlide> onboardingSlides = [
  OnboardingSlide(
    icon: Icons.forum_outlined,
    title: 'Parlez, partagez, ressentez',
    description:
        'Des questions, des défis et des moments de complicité '
        'pour mieux vous connaître et vous rapprocher.',
  ),
  OnboardingSlide(
    icon: Icons.grid_view_rounded,
    title: 'Des thèmes pour tous vos moments',
    description:
        'Amour, jeux et défis, projets d\'avenir, découverte de soi, '
        'voyages... Choisissez les thèmes qui vous ressemblent.',
  ),
  OnboardingSlide(
    icon: Icons.favorite_border,
    title: 'Une connexion unique',
    description:
        'Créez un espace privé pour votre couple et vivez une '
        'expérience personnalisée, à votre rythme.',
  ),
];
