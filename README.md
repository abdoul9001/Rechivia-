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
├── core/         # thème, navigation, widgets communs (à venir)
└── features/     # une fonctionnalité = domain / data / presentation (à venir)
```

Les dossiers sont créés au fur et à mesure des tâches, pas avant.

## Conventions

- Un commit par tâche, avec un message qui explique la modification.
- Aucun secret dans le dépôt (clés, mots de passe) ni de contenu intime dans les journaux.
