import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/core/theme/app_text_styles.dart';

/// Indicateur numéroté de progression des étapes guidées.
class StepProgressIndicator extends StatelessWidget {
  const StepProgressIndicator({
    required this.total,
    required this.currentIndex,
    super.key,
  });

  final int total;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Étape ${currentIndex + 1} sur $total',
      excludeSemantics: true,
      child: Row(
        children: [
          for (var i = 0; i < total; i++) ...[
            _StepDot(number: i + 1, state: _stateOf(i)),
            if (i < total - 1)
              Expanded(
                child: Container(
                  height: 2,
                  color: i < currentIndex ? AppColors.violet : AppColors.border,
                ),
              ),
          ],
        ],
      ),
    );
  }

  _DotState _stateOf(int index) {
    if (index < currentIndex) return _DotState.done;
    if (index == currentIndex) return _DotState.current;
    return _DotState.upcoming;
  }
}

enum _DotState { done, current, upcoming }

class _StepDot extends StatelessWidget {
  const _StepDot({required this.number, required this.state});

  final int number;
  final _DotState state;

  @override
  Widget build(BuildContext context) {
    final isCurrent = state == _DotState.current;
    final isDone = state == _DotState.done;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: isCurrent ? AppColors.primaryGradient : null,
        color: isDone ? AppColors.violet.withValues(alpha: 0.15) : null,
        shape: BoxShape.circle,
        border: state == _DotState.upcoming
            ? Border.all(color: AppColors.border, width: 1.5)
            : null,
      ),
      child: SizedBox(
        width: 32,
        height: 32,
        child: Center(
          child: isDone
              ? const Icon(Icons.check, size: 16, color: AppColors.violet)
              : Text(
                  '$number',
                  style: AppTextStyles.label.copyWith(
                    fontSize: 13,
                    color: isCurrent ? Colors.white : AppColors.textSecondary,
                  ),
                ),
        ),
      ),
    );
  }
}
