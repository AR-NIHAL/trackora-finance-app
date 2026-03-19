import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../data/models/transaction_model.dart';
import 'transaction_state.dart';

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, TransactionState>((ref) {
      return TransactionNotifier();
    });

class TransactionNotifier extends StateNotifier<TransactionState> {
  TransactionNotifier() : super(TransactionState.initial());

  List<TransactionModel> get allTransactions => state.transactions;

  void addTransaction(TransactionModel transaction) {
    state = state.copyWith(transactions: [...state.transactions, transaction]);
  }

  void deleteTransaction(String id) {
    state = state.copyWith(
      transactions: state.transactions.where((tx) => tx.id != id).toList(),
    );
  }

  void updateTransaction(TransactionModel updatedTransaction) {
    state = state.copyWith(
      transactions: state.transactions.map((tx) {
        if (tx.id == updatedTransaction.id) {
          return updatedTransaction;
        }
        return tx;
      }).toList(),
    );
  }

  void clearAllTransactions() {
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
