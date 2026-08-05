import 'package:expense_tracker/core/services/local_storage_service.dart';
import 'package:expense_tracker/shared/models/budget_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'budget_state.dart';

class BudgetNotifier extends Notifier<BudgetState> {
  @override
  BudgetState build() {
    final stored = LocalStorageService.instance.getBudgets();
    return BudgetState(budgets: stored);
  }

  void _persist() {
    LocalStorageService.instance.saveBudgets(state.budgets);
  }

  void setBudget(BudgetModel budget) {
    final index = state.budgets.indexWhere((item) => item.id == budget.id);
    final updated = [...state.budgets];
    if (index != -1) {
      updated[index] = budget;
    } else {
      updated.add(budget);
    }
    state = BudgetState(budgets: updated);
    _persist();
  }

  void deleteBudget(String budgetId) {
    state = state.copyWith(
      budgets: state.budgets.where((item) => item.id != budgetId).toList(),
    );
    _persist();
  }

  void reset() {
    state = const BudgetState();
    _persist();
  }

  void replaceAll(List<BudgetModel> budgets) {
    state = BudgetState(budgets: budgets);
    _persist();
  }
}
