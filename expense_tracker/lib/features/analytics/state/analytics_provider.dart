import 'package:expense_tracker/features/add_transaction/state/transaction_provider.dart';
import 'package:expense_tracker/shared/models/transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AnalyticsRange { week, month, year }

enum AnalyticsChartType { bar, line, donut }

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

final analyticsChartTypeProvider =
    NotifierProvider<AnalyticsChartTypeNotifier, AnalyticsChartType>(
      AnalyticsChartTypeNotifier.new,
    );

class AnalyticsChartTypeNotifier extends Notifier<AnalyticsChartType> {
  @override
  AnalyticsChartType build() => AnalyticsChartType.bar;

  void setType(AnalyticsChartType type) => state = type;
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

final filteredIncomeTransactionsProvider =
    Provider<List<TransactionModel>>((ref) {
      final transactions = ref.watch(transactionProvider).transactions;
      final range = ref.watch(analyticsRangeProvider);
      final now = DateTime.now();

      return transactions.where((tx) {
        if (!tx.isIncome) return false;
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

final rangeTotalIncomeProvider = Provider<double>((ref) {
  final transactions = ref.watch(filteredIncomeTransactionsProvider);
  return transactions.fold(0.0, (sum, tx) => sum + tx.amount);
});

final rangeNetSavingsProvider = Provider<double>((ref) {
  final income = ref.watch(rangeTotalIncomeProvider);
  final expense = ref.watch(rangeTotalExpenseProvider);
  return income - expense;
});

final rangeSavingsRateProvider = Provider<double>((ref) {
  final income = ref.watch(rangeTotalIncomeProvider);
  final expense = ref.watch(rangeTotalExpenseProvider);
  if (income <= 0) return 0.0;
  return (((income - expense) / income) * 100).clamp(-100.0, 100.0);
});

final rangeDailyAverageProvider = Provider<double>((ref) {
  final totalExpense = ref.watch(rangeTotalExpenseProvider);
  final range = ref.watch(analyticsRangeProvider);
  final now = DateTime.now();

  final days = switch (range) {
    AnalyticsRange.week => 7,
    AnalyticsRange.month => now.day > 0 ? now.day : 1,
    AnalyticsRange.year =>
      DateTime(now.year, now.month, now.day)
          .difference(DateTime(now.year, 1, 1))
          .inDays + 1,
  };

  return days > 0 ? totalExpense / days : 0.0;
});

final rangePreviousPeriodExpenseProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionProvider).transactions;
  final range = ref.watch(analyticsRangeProvider);
  final now = DateTime.now();

  return transactions.where((tx) {
    if (!tx.isExpense) return false;
    return switch (range) {
      AnalyticsRange.week =>
        tx.date.isBefore(now.subtract(const Duration(days: 7))) &&
        !tx.date.isBefore(now.subtract(const Duration(days: 14))),
      AnalyticsRange.month => () {
        final prevMonth = DateTime(now.year, now.month - 1);
        return tx.date.year == prevMonth.year && tx.date.month == prevMonth.month;
      }(),
      AnalyticsRange.year => tx.date.year == (now.year - 1),
    };
  }).fold(0.0, (sum, tx) => sum + tx.amount);
});

final rangeExpenseDeltaPercentProvider = Provider<double?>((ref) {
  final current = ref.watch(rangeTotalExpenseProvider);
  final previous = ref.watch(rangePreviousPeriodExpenseProvider);
  if (previous <= 0) return null;
  return ((current - previous) / previous) * 100;
});

final rangePeakSpendingProvider = Provider<SpendingPoint?>((ref) {
  final points = ref.watch(spendingTrendProvider);
  final nonZero = points.where((p) => p.value > 0).toList();
  if (nonZero.isEmpty) return null;
  return nonZero.reduce((a, b) => a.value > b.value ? a : b);
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
