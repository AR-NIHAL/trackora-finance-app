import 'package:expense_tracker/features/add_transaction/data/repositories/local_transaction_repository.dart';
import 'package:expense_tracker/features/add_transaction/domain/repositories/transaction_repository.dart';
import 'package:expense_tracker/shared/models/transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'transaction_state.dart';

class TransactionNotifier extends Notifier<TransactionState> {
  TransactionRepository get _repository => ref.read(transactionRepositoryProvider);

  @override
  TransactionState build() {
    final stored = _repository.fetchTransactions();
    return TransactionState(transactions: stored);
  }

  void _persist() {
    _repository.saveTransactions(state.transactions);
  }

  void addTransaction(TransactionModel transaction) {
    state = state.copyWith(transactions: [...state.transactions, transaction]);
    _persist();
  }

  void deleteTransaction(String transactionId) {
    final updatedTransactions = state.transactions
        .where((item) => item.id != transactionId)
        .toList();

    state = state.copyWith(transactions: updatedTransactions);
    _persist();
  }

  void updateTransaction(TransactionModel updatedTransaction) {
    final updatedTransactions = state.transactions.map((item) {
      if (item.id == updatedTransaction.id) {
        return updatedTransaction;
      }
      return item;
    }).toList();

    state = state.copyWith(transactions: updatedTransactions);
    _persist();
  }

  TransactionModel? getById(String transactionId) {
    for (final item in state.transactions) {
      if (item.id == transactionId) return item;
    }
    return null;
  }

  void reset() {
    state = TransactionState.initial(transactions: []);
    _persist();
  }

  void replaceAll(List<TransactionModel> transactions) {
    state = TransactionState(transactions: transactions);
    _persist();
  }
}
