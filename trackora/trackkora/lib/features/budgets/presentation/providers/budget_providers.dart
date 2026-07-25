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
  final start = DateTime(budget.month.year, budget.month.month);
  final end = DateTime(budget.month.year, budget.month.month + 1, 0, 23, 59, 59);
  final transactions = await repo.getByDateRange(start, end);
  double spent = 0;
  for (final t in transactions) {
    if (t.categoryId == budget.categoryId &&
        t.type == TransactionType.expense) {
      spent += t.amount;
    }
  }
  return spent;
});

class BudgetSummary {
  final double totalBudgeted;
  final double totalSpent;
  const BudgetSummary({required this.totalBudgeted, required this.totalSpent});
  double get remaining => totalBudgeted - totalSpent;
  double get utilization =>
      totalBudgeted > 0 ? (totalSpent / totalBudgeted).clamp(0.0, 1.5) : 0.0;
}

final monthlyBudgetSummaryProvider =
    FutureProvider.family<BudgetSummary, DateTime>((ref, month) async {
  final repo = ref.watch(budgetRepositoryProvider);
  final budgets = await repo.getBudgetsForMonth(month);
  double totalBudgeted = 0;
  double totalSpent = 0;
  for (final budget in budgets) {
    totalBudgeted += budget.amount;
    final spent = await ref.read(budgetSpentProvider(budget).future);
    totalSpent += spent;
  }
  return BudgetSummary(totalBudgeted: totalBudgeted, totalSpent: totalSpent);
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
    _ref.invalidate(monthlyBudgetSummaryProvider);
  }

  Future<void> update(Budget budget) async {
    await _repo.update(budget);
    _ref.invalidate(budgetsProvider);
    _ref.invalidate(monthlyBudgetsProvider);
    _ref.invalidate(budgetSpentProvider);
    _ref.invalidate(monthlyBudgetSummaryProvider);
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    _ref.invalidate(budgetsProvider);
    _ref.invalidate(monthlyBudgetsProvider);
    _ref.invalidate(budgetSpentProvider);
    _ref.invalidate(monthlyBudgetSummaryProvider);
  }
}

final budgetActionsProvider = Provider<BudgetActions>((ref) {
  final repo = ref.watch(budgetRepositoryProvider);
  return BudgetActions(repo, ref);
});
