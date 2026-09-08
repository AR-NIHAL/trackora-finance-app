import 'package:expense_tracker/features/budget/data/repositories/local_budget_repository.dart';
import 'package:expense_tracker/features/budget/domain/repositories/budget_repository.dart';
import 'package:expense_tracker/shared/models/budget_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'budget_state.dart';

class BudgetNotifier extends Notifier<BudgetState> {
  BudgetRepository get _repository => ref.read(budgetRepositoryProvider);

  @override
  BudgetState build() {
    final stored = _repository.fetchBudgets();
    return BudgetState(budgets: stored);
  }

  void _persist() {
    _repository.saveBudgets(state.budgets);
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
