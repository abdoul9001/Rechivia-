import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_text_styles.dart';
import 'package:rechivia/features/history/domain/history_entry.dart';
import 'package:rechivia/features/history/presentation/history_presentation.dart';

class HistoryKindIcon extends StatelessWidget {
  const HistoryKindIcon({required this.kind, super.key});

  final HistoryKind kind;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: kind.color.withValues(alpha: 0.14),
          shape: BoxShape.circle,
        ),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(kind.icon, color: kind.color, size: 20),
        ),
      ),
    );
  }
}

class HistoryStatusChip extends StatelessWidget {
  const HistoryStatusChip({required this.status, super.key});

  final HistoryStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status.color;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(
          status.label,
          style: AppTextStyles.label.copyWith(fontSize: 12, color: color),
        ),
      ),
    );
  }
}
