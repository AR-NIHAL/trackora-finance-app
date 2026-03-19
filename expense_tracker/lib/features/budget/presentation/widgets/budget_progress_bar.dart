import 'package:flutter/material.dart';

class BudgetProgressBar extends StatelessWidget {
  final double progress;
  final String progressLabel;

  const BudgetProgressBar({
    super.key,
    required this.progress,
    required this.progressLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final safeProgress = progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          progressLabel,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.75),
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: safeProgress,
            minHeight: 10,
            backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.55),
          ),
        ),
      ],
    );
  }
}
