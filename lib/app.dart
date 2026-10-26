import 'package:flutter/material.dart';

/// Widget racine de Rechivia.
///
/// Pour l'instant il affiche un simple écran temporaire. Il sera enrichi
/// dans les prochaines tâches : thème (tâche 2) puis navigation (tâche 4).
class RechiviaApp extends StatelessWidget {
  const RechiviaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Rechivia',
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: Text('Rechivia'))),
    );
  }
}
