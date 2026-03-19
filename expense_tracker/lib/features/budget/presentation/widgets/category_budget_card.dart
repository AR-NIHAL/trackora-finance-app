import 'package:flutter/material.dart';
import 'budget_progress_bar.dart';

class CategoryBudgetCard extends StatelessWidget {
  final String title;
  final String spentAmount;
  final String limitAmount;
  final double progress;
  final IconData icon;

  const CategoryBudgetCard({
    super.key,
    required this.title,
    required this.spentAmount,
    required this.limitAmount,
    required this.progress,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: theme.colorScheme.secondaryContainer,
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$spentAmount / $limitAmount',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          BudgetProgressBar(
            progress: progress,
            progressLabel: '${(progress * 100).toInt()}% used',
          ),
        ],
      ),
    );
  }
}
