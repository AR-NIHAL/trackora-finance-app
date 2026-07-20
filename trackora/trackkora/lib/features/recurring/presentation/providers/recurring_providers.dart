import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackkora/features/recurring/domain/entities/recurring_transaction.dart';
import 'package:trackkora/features/recurring/domain/repositories/recurring_repository.dart';
import 'package:trackkora/features/recurring/data/repositories/recurring_repository_impl.dart';
import 'package:trackkora/features/transactions/domain/entities/transaction.dart';
import 'package:trackkora/features/transactions/presentation/providers/transaction_providers.dart';

final recurringRepositoryProvider = Provider<RecurringRepository>((ref) {
  return RecurringRepositoryImpl();
});

final recurringTransactionsProvider = FutureProvider<List<RecurringTransaction>>((ref) async {
  final repo = ref.watch(recurringRepositoryProvider);
  return repo.getAll();
});

final dueTransactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  final repo = ref.watch(recurringRepositoryProvider);
  return repo.generateDueTransactions();
});

class RecurringActions {
  final RecurringRepository _repo;
  final Ref _ref;

  RecurringActions(this._repo, this._ref);

  Future<void> add(RecurringTransaction recurring) async {
    await _repo.add(recurring);
    _ref.invalidate(recurringTransactionsProvider);
  }

  Future<void> update(RecurringTransaction recurring) async {
    await _repo.update(recurring);
    _ref.invalidate(recurringTransactionsProvider);
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    _ref.invalidate(recurringTransactionsProvider);
  }

  Future<void> processDueTransactions() async {
    final dueTransactions = await _repo.generateDueTransactions();
    if (dueTransactions.isNotEmpty) {
      final transactionRepo = _ref.read(transactionRepositoryProvider);
      for (final t in dueTransactions) {
        await transactionRepo.add(t);
      }
      _ref.invalidate(transactionsProvider);
      _ref.invalidate(monthlyTransactionsProvider);
      _ref.invalidate(monthlyIncomeProvider);
      _ref.invalidate(monthlyExpenseProvider);
    }
  }
}

final recurringActionsProvider = Provider<RecurringActions>((ref) {
  final repo = ref.watch(recurringRepositoryProvider);
  return RecurringActions(repo, ref);
});
