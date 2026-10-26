import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/widgets/app_logo.dart';

/// Barre du haut des écrans plein écran : bouton retour et logo centré.
class ScreenTopBar extends StatelessWidget {
  const ScreenTopBar({required this.onBack, this.trailing, super.key});

  final VoidCallback onBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          tooltip: 'Retour',
          icon: const Icon(Icons.arrow_back),
          style: IconButton.styleFrom(
            foregroundColor: AppColors.violet,
            backgroundColor: AppColors.violet.withValues(alpha: 0.1),
          ),
        ),
        const Expanded(
          child: Center(child: AppLogo(size: 28, horizontal: true)),
        ),
        SizedBox(width: 48, child: trailing),
      ],
    );
  }
}
