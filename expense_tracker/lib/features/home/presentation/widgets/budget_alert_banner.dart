import 'package:expense_tracker/app/theme/app_colors.dart';
import 'package:expense_tracker/features/add_transaction/state/transaction_provider.dart';
import 'package:expense_tracker/features/budget/state/budget_provider.dart';
import 'package:expense_tracker/shared/models/dummy_categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetAlertBanner extends ConsumerWidget {
  const BudgetAlertBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final budgets = ref.watch(budgetProvider).forMonth(DateTime.now());
    final spentByCategory = ref.watch(spentByCategoryProvider);

    BudgetAlert? firstAlert;
    for (final budget in budgets) {
      final spent = spentByCategory[budget.categoryId] ?? 0.0;
      final progress = budget.limitAmount <= 0
          ? 0.0
          : (spent / budget.limitAmount).clamp(0.0, 1.0);
      final isExceeded = spent > budget.limitAmount;
      if (isExceeded || progress >= 0.8) {
        firstAlert = BudgetAlert(
          categoryId: budget.categoryId,
          progress: progress,
          isExceeded: isExceeded,
        );
        break;
      }
    }

    if (firstAlert == null) return const SizedBox.shrink();

    final category = DummyCategories.findById(firstAlert.categoryId);
    final isExceeded = firstAlert.isExceeded;
    final alertColor = isExceeded ? AppColors.expense(context) : Colors.orange;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: alertColor.withValues(
          alpha: 0.12,
        ),
        border: Border.all(
          color: alertColor.withValues(
            alpha: 0.4,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isExceeded
                ? Icons.error_outline_rounded
                : Icons.warning_amber_rounded,
            color: alertColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isExceeded
                  ? '${category?.name ?? 'A category'} budget is exceeded.'
                  : '${category?.name ?? 'A category'} budget is ${(firstAlert.progress * 100).round()}% used.',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BudgetAlert {
  final String categoryId;
  final double progress;
  final bool isExceeded;

  const BudgetAlert({
    required this.categoryId,
    required this.progress,
    required this.isExceeded,
  });
}