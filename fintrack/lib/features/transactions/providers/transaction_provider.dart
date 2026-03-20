import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/services/local_storage_service.dart';
import '../data/models/transaction_model.dart';
import 'transaction_state.dart';

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, TransactionState>((ref) {
      final storage = ref.read(localStorageServiceProvider);
      return TransactionNotifier(storage);
    });

class TransactionNotifier extends StateNotifier<TransactionState> {
  final LocalStorageService _storage;

  TransactionNotifier(this._storage) : super(TransactionState.initial());

  List<TransactionModel> get allTransactions => state.transactions;

  Future<void> loadTransactions() async {
    final transactions = await _storage.getAllTransactions();

    final sorted = [...transactions]..sort((a, b) => b.date.compareTo(a.date));

    state = state.copyWith(transactions: sorted);
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await _storage.addTransaction(transaction);

    state = state.copyWith(
      transactions: [...state.transactions, transaction]
        ..sort((a, b) => b.date.compareTo(a.date)),
    );
  }

  Future<void> updateTransaction(TransactionModel updatedTransaction) async {
    await _storage.updateTransaction(updatedTransaction);

    state = state.copyWith(
      transactions:
          state.transactions
              .map(
                (tx) =>
                    tx.id == updatedTransaction.id ? updatedTransaction : tx,
              )
              .toList()
            ..sort((a, b) => b.date.compareTo(a.date)),
    );
  }

  Future<void> deleteTransaction(String id) async {
    await _storage.deleteTransaction(id);

    state = state.copyWith(
      transactions: state.transactions.where((tx) => tx.id != id).toList(),
    );
  }

  Future<void> clearAllTransactions() async {
    await _storage.clearTransactions();
    state = state.copyWith(transactions: []);
  }
}

final totalIncomeProvider = Provider<double>((ref) {
  return ref.watch(transactionProvider).totalIncome;
});

final totalExpenseProvider = Provider<double>((ref) {
  return ref.watch(transactionProvider).totalExpense;
});

final totalBalanceProvider = Provider<double>((ref) {
  return ref.watch(transactionProvider).totalBalance;
});

final recentTransactionsProvider = Provider<List<TransactionModel>>((ref) {
  final transactions = ref.watch(transactionProvider).transactions;

  final sorted = [...transactions]..sort((a, b) => b.date.compareTo(a.date));

  return sorted.take(5).toList();
});
