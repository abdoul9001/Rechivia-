import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rechivia/app.dart';

/// Point d'entrée de l'application.
///
/// Ce fichier reste volontairement minimal : il ne fait que démarrer l'app.
/// Toute la configuration (thème, navigation) vit dans [RechiviaApp].
void main() {
  runApp(const ProviderScope(child: RechiviaApp()));
}
