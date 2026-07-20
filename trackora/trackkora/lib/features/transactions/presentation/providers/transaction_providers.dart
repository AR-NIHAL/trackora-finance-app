import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackkora/features/transactions/domain/entities/transaction.dart';
import 'package:trackkora/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:trackkora/features/transactions/data/repositories/transaction_repository_impl.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepositoryImpl();
});

final transactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  final repo = ref.watch(transactionRepositoryProvider);
  return repo.getAll();
});

final monthlyTransactionsProvider =
    FutureProvider.family<List<Transaction>, DateTime>((ref, month) async {
  final repo = ref.watch(transactionRepositoryProvider);
  final start = DateTime(month.year, month.month);
  final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
  return repo.getByDateRange(start, end);
});

final monthlyIncomeProvider =
    FutureProvider.family<double, DateTime>((ref, month) async {
  final repo = ref.watch(transactionRepositoryProvider);
  final start = DateTime(month.year, month.month);
  final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
  return repo.getTotalIncome(start: start, end: end);
});

final monthlyExpenseProvider =
    FutureProvider.family<double, DateTime>((ref, month) async {
  final repo = ref.watch(transactionRepositoryProvider);
  final start = DateTime(month.year, month.month);
  final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
  return repo.getTotalExpense(start: start, end: end);
});

class TransactionActions {
  final TransactionRepository _repo;
  final Ref _ref;

  TransactionActions(this._repo, this._ref);

  Future<void> add(Transaction transaction) async {
    await _repo.add(transaction);
    _ref.invalidate(transactionsProvider);
    _ref.invalidate(monthlyTransactionsProvider);
    _ref.invalidate(monthlyIncomeProvider);
    _ref.invalidate(monthlyExpenseProvider);
  }

  Future<void> update(Transaction transaction) async {
    await _repo.update(transaction);
    _ref.invalidate(transactionsProvider);
    _ref.invalidate(monthlyTransactionsProvider);
    _ref.invalidate(monthlyIncomeProvider);
    _ref.invalidate(monthlyExpenseProvider);
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    _ref.invalidate(transactionsProvider);
    _ref.invalidate(monthlyTransactionsProvider);
    _ref.invalidate(monthlyIncomeProvider);
    _ref.invalidate(monthlyExpenseProvider);
  }
}

final transactionActionsProvider = Provider<TransactionActions>((ref) {
  final repo = ref.watch(transactionRepositoryProvider);
  return TransactionActions(repo, ref);
});
