import 'package:expense_tracker/shared/models/budget_model.dart';

abstract class BudgetRepository {
  List<BudgetModel> fetchBudgets();
  Future<void> saveBudgets(List<BudgetModel> budgets);
}
