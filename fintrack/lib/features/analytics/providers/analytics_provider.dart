import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../transactions/data/models/transaction_model.dart';
import '../../transactions/providers/transaction_provider.dart';

final analyticsFilterProvider = StateProvider<String>((ref) => 'all');

final filteredAnalyticsTransactionsProvider = Provider<List<TransactionModel>>((
  ref,
) {
  final transactions = ref.watch(transactionProvider).transactions;
  final filter = ref.watch(analyticsFilterProvider);

  final now = DateTime.now();

  if (filter == 'all') {
    return transactions;
  }

  if (filter == 'monthly') {
    return transactions.where((tx) {
      return tx.date.year == now.year && tx.date.month == now.month;
    }).toList();
  }

  if (filter == 'weekly') {
    final weekAgo = now.subtract(const Duration(days: 7));
    return transactions.where((tx) {
      return tx.date.isAfter(weekAgo) || tx.date.isAtSameMomentAs(weekAgo);
    }).toList();
  }

  return transactions;
});

final analyticsIncomeProvider = Provider<double>((ref) {
  final transactions = ref.watch(filteredAnalyticsTransactionsProvider);

  return transactions
      .where((tx) => tx.type == 'income')
      .fold(0.0, (sum, tx) => sum + tx.amount);
});

final analyticsExpenseProvider = Provider<double>((ref) {
  final transactions = ref.watch(filteredAnalyticsTransactionsProvider);

  return transactions
      .where((tx) => tx.type == 'expense')
      .fold(0.0, (sum, tx) => sum + tx.amount);
});

final analyticsBalanceProvider = Provider<double>((ref) {
  final income = ref.watch(analyticsIncomeProvider);
  final expense = ref.watch(analyticsExpenseProvider);
  return income - expense;
});

final analyticsCategoryTotalsProvider = Provider<Map<String, double>>((ref) {
  final transactions = ref.watch(filteredAnalyticsTransactionsProvider);

  final Map<String, double> totals = {};

  for (final transaction in transactions) {
    if (transaction.type == 'expense') {
      totals[transaction.category] =
          (totals[transaction.category] ?? 0) + transaction.amount;
    }
  }

  final entries = totals.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  return {for (final entry in entries) entry.key: entry.value};
});

final analyticsTopCategoryProvider = Provider<String>((ref) {
  final categoryTotals = ref.watch(analyticsCategoryTotalsProvider);

  if (categoryTotals.isEmpty) {
    return 'No expense data';
  }

  return categoryTotals.entries.first.key;
});

final analyticsTransactionCountProvider = Provider<int>((ref) {
  return ref.watch(filteredAnalyticsTransactionsProvider).length;
});
