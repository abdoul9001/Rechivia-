/// Catégories de questions que les utilisateurs peuvent activer.
///
/// Ce sont les thèmes de la maquette 6. Le nom de chaque valeur (`name`)
/// sert d'identifiant stable lors de l'enregistrement.
enum ThemeCategory {
  loveRomance,

  /// Catégorie sensible à réévaluer avant un lancement public.
  intimacyDesire,

  gamesChallenges,
  futureProjects,
  personalityDiscovery,
  wellbeingBalance,
  travelAdventure,

  /// Les questions écrites par les partenaires sont prévues en V2.
  other,
}
