import 'package:expense_tracker/features/add_transaction/state/transaction_provider.dart';
import 'package:expense_tracker/shared/models/transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AnalyticsRange { week, month, year }

class SpendingPoint {
  final String label;
  final double value;

  const SpendingPoint({required this.label, required this.value});
}

final analyticsRangeProvider = NotifierProvider<AnalyticsRangeNotifier, AnalyticsRange>(
  AnalyticsRangeNotifier.new,
);

class AnalyticsRangeNotifier extends Notifier<AnalyticsRange> {
  @override
  AnalyticsRange build() => AnalyticsRange.month;

  void setRange(AnalyticsRange range) => state = range;
}

final filteredExpenseTransactionsProvider =
    Provider<List<TransactionModel>>((ref) {
      final transactions = ref.watch(transactionProvider).transactions;
      final range = ref.watch(analyticsRangeProvider);
      final now = DateTime.now();

      return transactions.where((tx) {
        if (!tx.isExpense) return false;
        return switch (range) {
          AnalyticsRange.week => !tx.date.isBefore(
            now.subtract(const Duration(days: 7)),
          ),
          AnalyticsRange.month =>
            tx.date.year == now.year && tx.date.month == now.month,
          AnalyticsRange.year => tx.date.year == now.year,
        };
      }).toList();
    });

final rangeTotalExpenseProvider = Provider<double>((ref) {
  final transactions = ref.watch(filteredExpenseTransactionsProvider);
  return transactions.fold(0.0, (sum, tx) => sum + tx.amount);
});

final rangeTransactionCountProvider = Provider<int>((ref) {
  return ref.watch(filteredExpenseTransactionsProvider).length;
});

final rangeCategoryTotalsProvider = Provider<Map<String, double>>((ref) {
  final transactions = ref.watch(filteredExpenseTransactionsProvider);
  final totals = <String, double>{};
  for (final tx in transactions) {
    totals[tx.categoryId] = (totals[tx.categoryId] ?? 0) + tx.amount;
  }
  final entries = totals.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  return {for (final entry in entries) entry.key: entry.value};
});

final rangeTopCategoryProvider = Provider<String?>((ref) {
  final totals = ref.watch(rangeCategoryTotalsProvider);
  return totals.isEmpty ? null : totals.keys.first;
});

final spendingTrendProvider = Provider<List<SpendingPoint>>((ref) {
  final transactions = ref.watch(filteredExpenseTransactionsProvider);
  final range = ref.watch(analyticsRangeProvider);
  final now = DateTime.now();
  final points = switch (range) {
    AnalyticsRange.week => <SpendingPoint>[
      for (int i = 6; i >= 0; i--)
        _spendingPoint(
          transactions,
          now.subtract(Duration(days: i)),
          _dayLabel,
          granularity: _Granularity.day,
        ),
    ],
    AnalyticsRange.month => <SpendingPoint>[
      for (int week = 3; week >= 0; week--)
        _weekPoint(transactions, now, week),
    ],
    AnalyticsRange.year => <SpendingPoint>[
      for (int i = 11; i >= 0; i--)
        _spendingPoint(
          transactions,
          DateTime(now.year, now.month - i),
          _monthLabel,
          granularity: _Granularity.month,
        ),
    ],
  };
  return points;
});

enum _Granularity { day, month }

String _dayLabel(DateTime day) {
  return const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][day.weekday - 1];
}

String _monthLabel(DateTime month) {
  return const [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ][month.month - 1];
}

SpendingPoint _spendingPoint(
  List<TransactionModel> transactions,
  DateTime date,
  String Function(DateTime) label, {
  _Granularity granularity = _Granularity.day,
}) {
  final total = transactions.where((tx) {
    if (tx.date.year != date.year || tx.date.month != date.month) return false;
    if (granularity == _Granularity.day) return tx.date.day == date.day;
    return true;
  }).fold(0.0, (sum, tx) => sum + tx.amount);
  return SpendingPoint(label: label(date), value: total);
}

SpendingPoint _weekPoint(
  List<TransactionModel> transactions,
  DateTime now,
  int week,
) {
  final end = now.subtract(Duration(days: week * 7));
  final start = end.subtract(const Duration(days: 6));
  final total = transactions
      .where((tx) => !tx.date.isBefore(start) && !tx.date.isAfter(end))
      .fold(0.0, (sum, tx) => sum + tx.amount);
  return SpendingPoint(label: 'W${4 - week}', value: total);
}
