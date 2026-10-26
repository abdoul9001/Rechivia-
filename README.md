# Rechivia

Application mobile pour couples : une question par jour, des réponses privées
dévoilées quand les deux partenaires ont répondu.

## Prérequis

- Flutter 3.41.x (Dart 3.11.x)
- Android Studio ou VS Code avec les extensions Flutter et Dart

## Installation

```bash
flutter pub get
```

## Lancement

```bash
flutter run
```

## Vérifications avant chaque commit

```bash
dart format .
flutter analyze
flutter test
```

## Structure

```text
lib/
├── main.dart     # point d'entrée
├── app.dart      # widget racine
├── core/
│   ├── router/   # routes et navigation principale
│   ├── theme/    # couleurs, espacements, styles de texte et thème global
│   └── widgets/  # composants partagés : boutons, champ, carte, logo et barre
├── features/
│   ├── auth/
│   │   ├── domain/       # contrat, utilisateur, erreurs et validations
│   │   ├── data/         # dépôt d'authentification factice en mémoire
│   │   └── presentation/ # formulaires et état Riverpod
│   └── onboarding/
│       └── presentation/
│           ├── screens/ # carrousel et écran de bienvenue
│           └── widgets/ # diapositives et indicateur de page

assets/
└── fonts/        # polices Poppins embarquées
```

Les comptes d'authentification sont conservés en mémoire uniquement et
disparaissent à la fermeture de l'application. La connexion Google et Apple
affiche « Bientôt disponible » en attendant son intégration au backend.

## Conventions

- Un commit par tâche, avec un message qui explique la modification.
- Aucun secret dans le dépôt (clés, mots de passe) ni de contenu intime dans les journaux.
