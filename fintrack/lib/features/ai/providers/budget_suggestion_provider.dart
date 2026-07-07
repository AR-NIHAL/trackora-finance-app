import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../transactions/data/models/transaction_model.dart';
import '../../transactions/providers/transaction_provider.dart';

final budgetSuggestionProvider = Provider<Map<String, double>>((ref) {
  final transactions = ref.watch(transactionProvider).transactions;

  return _suggestBudgets(transactions);
});

Map<String, double> _suggestBudgets(List<TransactionModel> transactions) {
  final expenseTransactions = transactions.where((tx) => tx.type == 'expense').toList();

  if (expenseTransactions.isEmpty) {
    return {};
  }

  final dates = expenseTransactions.map((tx) => tx.date).toList()..sort();
  final oldest = dates.first;
  final now = DateTime.now();

  final totalMonths = _monthsBetween(oldest, now).clamp(1, 3);

  final Map<String, double> categoryTotals = {};

  for (final tx in expenseTransactions) {
    categoryTotals[tx.category] = (categoryTotals[tx.category] ?? 0) + tx.amount;
  }

  final Map<String, double> suggestions = {};

  for (final entry in categoryTotals.entries) {
    final avgMonthly = entry.value / totalMonths;
    final suggested = avgMonthly * 1.15;
    final rounded = ((suggested / 100).round() * 100).toDouble();
    final finalAmount = rounded < 100
        ? suggested.clamp(50, double.infinity).toDouble()
        : rounded;
    suggestions[entry.key] = finalAmount;
  }

  final sortedEntries = suggestions.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  return {for (final entry in sortedEntries) entry.key: entry.value};
}

int _monthsBetween(DateTime start, DateTime end) {
  return (end.year - start.year) * 12 + (end.month - start.month) + 1;
}
