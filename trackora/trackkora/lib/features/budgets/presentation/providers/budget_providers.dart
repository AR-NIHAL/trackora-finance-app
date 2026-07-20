import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackkora/features/budgets/domain/entities/budget.dart';
import 'package:trackkora/features/budgets/domain/repositories/budget_repository.dart';
import 'package:trackkora/features/budgets/data/repositories/budget_repository_impl.dart';
import 'package:trackkora/features/transactions/presentation/providers/transaction_providers.dart';
import 'package:trackkora/features/transactions/domain/entities/transaction_type.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepositoryImpl();
});

final budgetsProvider = FutureProvider<List<Budget>>((ref) async {
  final repo = ref.watch(budgetRepositoryProvider);
  return repo.getAll();
});

final monthlyBudgetsProvider =
    FutureProvider.family<List<Budget>, DateTime>((ref, month) async {
  final repo = ref.watch(budgetRepositoryProvider);
  return repo.getBudgetsForMonth(month);
});

final budgetSpentProvider =
    FutureProvider.family<double, Budget>((ref, budget) async {
  final repo = ref.watch(transactionRepositoryProvider);
  final transactions = await repo.getAll();
  double spent = 0;
  for (final t in transactions) {
    if (t.categoryId == budget.categoryId &&
        t.type == TransactionType.expense &&
        t.date.year == budget.month.year &&
        t.date.month == budget.month.month) {
      spent += t.amount;
    }
  }
  return spent;
});

class BudgetActions {
  final BudgetRepository _repo;
  final Ref _ref;

  BudgetActions(this._repo, this._ref);

  Future<void> add(Budget budget) async {
    await _repo.add(budget);
    _ref.invalidate(budgetsProvider);
    _ref.invalidate(monthlyBudgetsProvider);
    _ref.invalidate(budgetSpentProvider);
  }

  Future<void> update(Budget budget) async {
    await _repo.update(budget);
    _ref.invalidate(budgetsProvider);
    _ref.invalidate(monthlyBudgetsProvider);
    _ref.invalidate(budgetSpentProvider);
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    _ref.invalidate(budgetsProvider);
    _ref.invalidate(monthlyBudgetsProvider);
    _ref.invalidate(budgetSpentProvider);
  }
}

final budgetActionsProvider = Provider<BudgetActions>((ref) {
  final repo = ref.watch(budgetRepositoryProvider);
  return BudgetActions(repo, ref);
});
