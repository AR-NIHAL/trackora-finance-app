import 'package:expense_tracker/features/add_transaction/state/transaction_provider.dart';
import 'package:expense_tracker/features/subscriptions/state/subscriptions_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForecastPoint {
  final DateTime date;
  final double balance;

  const ForecastPoint({required this.date, required this.balance});
}

final forecastProvider = Provider<List<ForecastPoint>>((ref) {
  final balance = ref.watch(totalBalanceProvider);
  final subscriptions = ref.watch(subscriptionsProvider);
  final transactions = ref.watch(transactionProvider).transactions;
  final now = DateTime.now();

  final recurringIncome = transactions
      .where((tx) => tx.isIncome && tx.isRecurring)
      .toList();
  final recurringExpense = subscriptions
      .map((sub) => (sub.title, sub.amount, sub.nextOccurrence))
      .toList();

  final points = <ForecastPoint>[];
  var projected = balance;
  final startDay = DateTime(now.year, now.month, now.day);

  for (int day = 0; day <= 90; day++) {
    final date = startDay.add(Duration(days: day));

    for (final tx in recurringIncome) {
      if (date.day == tx.date.day && date.month != tx.date.month) {
        projected += tx.amount;
      }
    }
    for (final (_, amount, next) in recurringExpense) {
      if (date.day == next.day && date.month != next.month) {
        projected -= amount;
      }
    }

    points.add(ForecastPoint(date: date, balance: projected));
  }

  return points;
});

final forecastSummaryProvider = Provider<(double, double, double)>((ref) {
  final points = ref.watch(forecastProvider);
  if (points.length < 30) return (0, 0, 0);
  return (
    points[30].balance,
    points[60].balance,
    points.last.balance,
  );
});
