import 'package:flutter/material.dart';

import 'package:rechivia/core/widgets/app_card.dart';

/// Rappelle les bénéfices privés de l'espace à créer.
class CoupleBenefitsCard extends StatelessWidget {
  const CoupleBenefitsCard({super.key});

  static const List<(IconData, String)> _benefits = [
    (Icons.lock_outline, 'Vos réponses restent privées'),
    (Icons.favorite_outline, 'Un espace rien qu’à vous deux'),
    (Icons.calendar_today_outlined, 'Une question pour vous rapprocher'),
  ];

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (icon, text) in _benefits)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(width: 12),
                  Expanded(child: Text(text)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
