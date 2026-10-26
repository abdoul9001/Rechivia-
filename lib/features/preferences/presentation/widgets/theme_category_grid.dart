import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/features/preferences/domain/theme_category.dart';
import 'package:rechivia/features/preferences/presentation/widgets/theme_category_card.dart';

/// Grille de cartes sur deux colonnes, avec des lignes à hauteur intrinsèque.
class ThemeCategoryGrid extends StatelessWidget {
  const ThemeCategoryGrid({
    required this.categories,
    required this.selected,
    required this.onToggle,
    super.key,
  });

  final List<ThemeCategory> categories;
  final Set<ThemeCategory> selected;
  final ValueChanged<ThemeCategory> onToggle;

  static const int _columns = 2;
  static const double _gap = AppSpacing.sm + 4;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];

    for (var start = 0; start < categories.length; start += _columns) {
      final rowItems = categories.skip(start).take(_columns).toList();

      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < _columns; i++) ...[
                if (i > 0) const SizedBox(width: _gap),
                Expanded(
                  child: i < rowItems.length
                      ? ThemeCategoryCard(
                          category: rowItems[i],
                          isSelected: selected.contains(rowItems[i]),
                          onTap: () => onToggle(rowItems[i]),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ],
          ),
        ),
      );
      rows.add(const SizedBox(height: _gap));
    }

    return Column(children: rows);
  }
}
