import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../transactions/providers/transaction_provider.dart';
import '../data/models/budget_model.dart';

final budgetProvider = StateNotifierProvider<BudgetNotifier, List<BudgetModel>>(
  (ref) {
    return BudgetNotifier();
  },
);

class BudgetNotifier extends StateNotifier<List<BudgetModel>> {
  BudgetNotifier() : super(const []);

  void addBudget(BudgetModel budget) {
    final existingIndex = state.indexWhere(
      (item) => item.category == budget.category,
    );

    if (existingIndex != -1) {
      final updated = [...state];
      updated[existingIndex] = budget;
      state = updated;
      return;
    }

    state = [...state, budget];
  }

  void deleteBudget(String id) {
    state = state.where((budget) => budget.id != id).toList();
  }

  void updateBudget(BudgetModel updatedBudget) {
    state = state.map((budget) {
      if (budget.id == updatedBudget.id) {
        return updatedBudget;
      }
      return budget;
    }).toList();
  }

  void clearBudgets() {
    state = [];
  }
}

final budgetExpenseByCategoryProvider = Provider<Map<String, double>>((ref) {
  final transactions = ref.watch(transactionProvider).transactions;

  final Map<String, double> expenseMap = {};

  for (final tx in transactions) {
    if (tx.type == 'expense') {
      expenseMap[tx.category] = (expenseMap[tx.category] ?? 0) + tx.amount;
    }
  }

  return expenseMap;
});

final totalBudgetLimitProvider = Provider<double>((ref) {
  final budgets = ref.watch(budgetProvider);
  return budgets.fold(0.0, (sum, budget) => sum + budget.limitAmount);
});

final totalBudgetSpentProvider = Provider<double>((ref) {
  final budgets = ref.watch(budgetProvider);
  final expenseMap = ref.watch(budgetExpenseByCategoryProvider);

  double totalSpent = 0.0;

  for (final budget in budgets) {
    totalSpent += expenseMap[budget.category] ?? 0.0;
  }

  return totalSpent;
});

final totalBudgetRemainingProvider = Provider<double>((ref) {
  final totalLimit = ref.watch(totalBudgetLimitProvider);
  final totalSpent = ref.watch(totalBudgetSpentProvider);
  return totalLimit - totalSpent;
});

final budgetStatusListProvider = Provider<List<BudgetStatusItem>>((ref) {
  final budgets = ref.watch(budgetProvider);
  final expenseMap = ref.watch(budgetExpenseByCategoryProvider);

  return budgets.map((budget) {
    final spent = expenseMap[budget.category] ?? 0.0;
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
