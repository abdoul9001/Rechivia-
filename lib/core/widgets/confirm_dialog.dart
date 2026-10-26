import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';

/// Affiche une boîte de confirmation et retourne `true` si l'utilisateur
/// confirme, `false` s'il annule ou ferme la boîte.
///
/// [isDestructive] colore le bouton de confirmation en rouge : à utiliser
/// pour les actions irréversibles (suppression...).
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool isDestructive = false,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: isDestructive
                ? TextButton.styleFrom(foregroundColor: AppColors.error)
                : null,
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );
  return confirmed ?? false;
}
