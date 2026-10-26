import 'package:flutter/material.dart';

/// Affichage uniforme des petits messages en bas d'écran.
abstract final class AppSnackBar {
  /// Affiche [message] en remplaçant celui éventuellement déjà visible.
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
