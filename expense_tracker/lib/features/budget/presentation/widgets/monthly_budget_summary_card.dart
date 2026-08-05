import 'package:expense_tracker/core/utils/app_utils.dart';
import 'package:expense_tracker/features/budget/presentation/widgets/budget_overview_card.dart';
import 'package:expense_tracker/features/budget/presentation/widgets/budget_progress_bar.dart';
import 'package:expense_tracker/features/budget/state/budget_provider.dart';
import 'package:expense_tracker/features/settings/state/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MonthlyBudgetSummaryCard extends ConsumerWidget {
  const MonthlyBudgetSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currencyCode = ref.watch(
      settingsProvider.select((settings) => settings.currencyCode),
    );
    final totalBudget = ref.watch(totalMonthlyBudgetLimitProvider);
    final totalSpent = ref.watch(totalMonthlyBudgetSpentProvider);
    final remaining = ref.watch(totalMonthlyBudgetRemainingProvider);

    final progress = totalBudget <= 0
        ? 0.0
        : (totalSpent / totalBudget).clamp(0.0, 1.0);
    final isExceeded = totalSpent > totalBudget;
    final barColor = isExceeded
        ? Colors.redAccent
        : progress >= 0.8
        ? Colors.orange
        : null;

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
            totalBudget == 0
                ? 'No budget set'
                : AppUtils.formatCurrency(totalBudget, currencyCode),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 18),
          BudgetProgressBar(
            progress: progress,
            progressLabel: totalBudget == 0
                ? 'Tap "Add" to set a monthly budget'
                : isExceeded
                ? 'Over budget'
                : '${(progress * 100).toInt()}% used',
            color: barColor,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: BudgetOverviewItem(
                  label: 'Total Spent',
                  value: AppUtils.formatCurrency(totalSpent, currencyCode),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: BudgetOverviewItem(
                  label: 'Remaining',
                  value: AppUtils.formatCurrency(remaining, currencyCode),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
