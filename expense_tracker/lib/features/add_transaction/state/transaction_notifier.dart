import 'package:expense_tracker/core/services/local_storage_service.dart';
import 'package:expense_tracker/shared/models/transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'transaction_state.dart';

class TransactionNotifier extends Notifier<TransactionState> {
  @override
  TransactionState build() {
    final storage = LocalStorageService.instance;
    final stored = storage.getTransactions();
    return TransactionState(transactions: stored);
  }

  void _persist() {
    LocalStorageService.instance.saveTransactions(state.transactions);
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
