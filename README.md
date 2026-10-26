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
│   ├── preferences/
│   │   ├── domain/       # catégories et contrat de préférences
│   │   ├── data/         # dépôt factice en mémoire
│   │   └── presentation/ # sélection des thèmes
│   ├── couple/
│   │   ├── domain/       # espace, icônes, invitations et validations
│   │   ├── data/         # dépôt factice en mémoire
│   │   └── presentation/ # création, invitation et jonction d'un espace
│   ├── daily_question/
│   │   ├── domain/       # question du jour et contrat de données
│   │   ├── data/         # catalogue factice déterminé par la date
│   │   └── presentation/ # fournisseur de question
│   ├── home/
│   │   └── presentation/ # accueil et cartes de contenu
│   └── onboarding/
│       └── presentation/
│           ├── screens/ # carrousel et écran de bienvenue
│           └── widgets/ # diapositives et indicateur de page

assets/
└── fonts/        # polices Poppins embarquées
```

Les comptes d'authentification sont conservés en mémoire uniquement et
disparaissent à la fermeture de l'application. Les préférences de thèmes sont
également factices et non persistées. La connexion Google et Apple affiche
« Bientôt disponible » en attendant son intégration au backend.
Les espaces de couple et invitations sont simulés en mémoire ; les invitations
expirent après sept jours et ne sont utilisables qu'une fois. Le code de
démonstration `K7M2PQ` permet de tester le parcours de jonction.
La question du jour et les informations de session sont également simulées ;
elles ne sont pas synchronisées entre appareils ni persistées après fermeture.

## Conventions

- Un commit par tâche, avec un message qui explique la modification.
- Aucun secret dans le dépôt (clés, mots de passe) ni de contenu intime dans les journaux.
