import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_theme.dart';

void main() {
  group('AppTheme.light', () {
    test('utilise la couleur de fond et la police des maquettes', () {
      final theme = AppTheme.light;

      expect(theme.scaffoldBackgroundColor, AppColors.background);
      expect(theme.textTheme.bodyLarge?.fontFamily, 'Poppins');
    });

    test('utilise le violet comme couleur principale', () {
      expect(AppTheme.light.colorScheme.primary, AppColors.violet);
    });
  });
}
