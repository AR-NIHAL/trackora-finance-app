import 'package:expense_tracker/shared/models/budget_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../add_transaction/state/transaction_provider.dart';
import 'budget_notifier.dart';
import 'budget_state.dart';

final budgetProvider =
    NotifierProvider<BudgetNotifier, BudgetState>(BudgetNotifier.new);

final currentMonthBudgetsProvider = Provider<List<BudgetModel>>((ref) {
  return ref.watch(budgetProvider).forMonth(DateTime.now());
});

class BudgetStatusItem {
  final BudgetModel budget;
  final double spentAmount;
  final double remainingAmount;
  final double progress;
  final bool isExceeded;

  const BudgetStatusItem({
    required this.budget,
    required this.spentAmount,
    required this.remainingAmount,
    required this.progress,
    required this.isExceeded,
  });
}

final budgetStatusListProvider = Provider<List<BudgetStatusItem>>((ref) {
  final budgets = ref.watch(currentMonthBudgetsProvider);
  final spentByCategory = ref.watch(spentByCategoryProvider);

  return budgets.map((budget) {
    final spent = spentByCategory[budget.categoryId] ?? 0.0;
    final remaining = budget.limitAmount - spent;
    final progress = budget.limitAmount == 0
        ? 0.0
        : (spent / budget.limitAmount).clamp(0.0, 1.0);

    return BudgetStatusItem(
      budget: budget,
      spentAmount: spent,
      remainingAmount: remaining,
      progress: progress,
      isExceeded: spent > budget.limitAmount,
    );
  }).toList();
});

final totalMonthlyBudgetLimitProvider = Provider<double>((ref) {
  final budgets = ref.watch(currentMonthBudgetsProvider);
  return budgets.fold(0.0, (sum, budget) => sum + budget.limitAmount);
});

final totalMonthlyBudgetSpentProvider = Provider<double>((ref) {
  final statusList = ref.watch(budgetStatusListProvider);
  return statusList.fold(0.0, (sum, item) => sum + item.spentAmount);
});

final totalMonthlyBudgetRemainingProvider = Provider<double>((ref) {
  final limit = ref.watch(totalMonthlyBudgetLimitProvider);
  final spent = ref.watch(totalMonthlyBudgetSpentProvider);
  return limit - spent;
});
