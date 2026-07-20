import 'package:trackkora/features/budgets/domain/entities/budget.dart';

abstract class BudgetRepository {
  Future<List<Budget>> getAll();
  Future<List<Budget>> getBudgetsForMonth(DateTime month);
  Future<Budget?> getById(String id);
  Future<void> add(Budget budget);
  Future<void> update(Budget budget);
  Future<void> delete(String id);
}
