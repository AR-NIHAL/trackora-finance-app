import 'package:expense_tracker/shared/models/budget_model.dart';

class BudgetState {
  final List<BudgetModel> budgets;

  const BudgetState({this.budgets = const []});

  BudgetState copyWith({List<BudgetModel>? budgets}) {
    return BudgetState(budgets: budgets ?? this.budgets);
  }

  List<BudgetModel> forMonth(DateTime month) {
    return budgets.where((budget) {
      return budget.month.year == month.year && budget.month.month == month.month;
    }).toList();
  }

  double get totalLimit {
    return budgets.fold(0.0, (sum, budget) => sum + budget.limitAmount);
  }
}
