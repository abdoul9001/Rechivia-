import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_theme.dart';

/// Widget racine de Rechivia.
///
/// Il applique le thème global. La navigation sera ajoutée à la tâche 4.
class RechiviaApp extends StatelessWidget {
  const RechiviaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rechivia',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const Scaffold(body: Center(child: Text('Rechivia'))),
    );
  }
}
