import 'package:expense_tracker/features/budget/presentation/widgets/budget_overview_card.dart';
import 'package:flutter/material.dart';
import 'budget_progress_bar.dart';

class MonthlyBudgetSummaryCard extends StatelessWidget {
  const MonthlyBudgetSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const totalBudget = '\$5,000.00';
    const totalSpent = '\$3,180.00';
    const remaining = '\$1,820.00';
    const progressValue = 0.64;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: theme.colorScheme.primaryContainer,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Budget',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer.withValues(
                alpha: 0.75,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            totalBudget,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 18),
          const BudgetProgressBar(
            progress: progressValue,
            progressLabel: '64% used',
          ),
          const SizedBox(height: 18),
          const Row(
            children: [
              Expanded(
                child: BudgetOverviewItem(
                  label: 'Total Spent',
                  value: totalSpent,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: BudgetOverviewItem(label: 'Remaining', value: remaining),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
