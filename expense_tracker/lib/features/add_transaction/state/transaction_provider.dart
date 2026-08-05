import 'package:expense_tracker/shared/models/transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'transaction_notifier.dart';
import 'transaction_state.dart';

final transactionProvider =
    NotifierProvider<TransactionNotifier, TransactionState>(
      TransactionNotifier.new,
    );

final totalBalanceProvider = Provider<double>((ref) {
  return ref.watch(transactionProvider).totalBalance;
});

final totalIncomeProvider = Provider<double>((ref) {
  return ref.watch(transactionProvider).totalIncome;
});

final totalExpenseProvider = Provider<double>((ref) {
  return ref.watch(transactionProvider).totalExpense;
});

final recentTransactionsProvider = Provider<List<TransactionModel>>((ref) {
  return ref.watch(transactionProvider).recentTransactions;
});

final spentByCategoryProvider = Provider<Map<String, double>>((ref) {
  return ref.watch(transactionProvider).spentByCategory;
});

final currentMonthIncomeProvider = Provider<double>((ref) {
  return ref.watch(transactionProvider).incomeInMonth(DateTime.now());
});

final currentMonthExpenseProvider = Provider<double>((ref) {
  return ref.watch(transactionProvider).expenseInMonth(DateTime.now());
});

final recurringCandidatesProvider = Provider<List<TransactionModel>>((ref) {
  return ref.watch(transactionProvider).recurringCandidates;
});
