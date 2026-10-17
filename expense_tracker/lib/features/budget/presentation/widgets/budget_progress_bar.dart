import 'package:expense_tracker/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BudgetProgressBar extends StatelessWidget {
  final double progress;
  final String progressLabel;
  final Color? color;

  const BudgetProgressBar({
    super.key,
    required this.progress,
    required this.progressLabel,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final safeProgress = progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          progressLabel,
          style: theme.textTheme.bodySmall?.copyWith(
            color: color ?? AppColors.textMuted(context),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: safeProgress,
            minHeight: 10,
            color: color ?? theme.colorScheme.primary,
            backgroundColor: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : const Color(0xFFE2E8E4),
          ),
        ),
      ],
    );
  }
}
