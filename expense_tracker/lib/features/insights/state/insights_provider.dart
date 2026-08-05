import 'package:expense_tracker/features/add_transaction/state/transaction_provider.dart';
import 'package:expense_tracker/shared/models/dummy_categories.dart';
import 'package:expense_tracker/shared/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Insight {
  final IconData icon;
  final Color color;
  final String title;
  final String message;

  const Insight({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
  });
}

final insightsProvider = Provider<List<Insight>>((ref) {
  final state = ref.watch(transactionProvider);
  final insights = <Insight>[];

  final now = DateTime.now();
  final spentByCategory = state.spentByCategory;

  if (spentByCategory.isNotEmpty) {
    final topEntry = spentByCategory.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );
    final category = DummyCategories.findById(topEntry.key);
    insights.add(
      Insight(
        icon: DummyCategories.iconFor(category?.iconName),
        color: category?.color ?? Colors.blue,
        title: 'Top spending category',
        message:
            '${category?.name ?? 'Other'} is your biggest expense this month.',
      ),
    );
  }

  final thisMonth = state.expenseInMonth(now);
  final lastMonth = state.expenseInMonth(
    DateTime(now.year, now.month - 1),
  );
  if (lastMonth > 0) {
    final percent = ((thisMonth - lastMonth) / lastMonth * 100).round();
    insights.add(
      Insight(
        icon: percent >= 0
            ? Icons.trending_up_rounded
            : Icons.trending_down_rounded,
        color: percent >= 0 ? Colors.orange : Colors.green,
        title: 'vs last month',
        message: percent >= 0
            ? 'You spent $percent% more than last month.'
            : 'Good job - you spent ${percent.abs()}% less than last month.',
      ),
    );
  }

  final biggest = state.expenses
      .reduceOrNull((a, b) => a.amount > b.amount ? a : b);
  if (biggest != null) {
    final category = DummyCategories.findById(biggest.categoryId);
    insights.add(
      Insight(
        icon: Icons.bolt_rounded,
        color: Colors.deepPurple,
        title: 'Biggest expense',
        message:
            '${biggest.title} (${category?.name ?? 'Other'}) is your largest recorded expense.',
      ),
    );
  }

  final streak = _noSpendStreak(state.expenses, now);
  if (streak >= 2) {
    insights.add(
      Insight(
        icon: Icons.local_fire_department_rounded,
        color: Colors.redAccent,
        title: '$streak-day no-spend streak',
        message: 'No expenses for $streak consecutive days. Keep it up!',
      ),
    );
  }

  final thisMonthIncome = state.incomeInMonth(now);
  if (thisMonthIncome > 0) {
    final savedPercent = ((thisMonthIncome - thisMonth) / thisMonthIncome * 100)
        .clamp(0, 100)
        .round();
    insights.add(
      Insight(
        icon: Icons.savings_rounded,
        color: Colors.teal,
        title: 'Savings rate',
        message: 'You kept $savedPercent% of your income this month.',
      ),
    );
  }

  if (state.recurringCandidates.isNotEmpty) {
    insights.add(
      Insight(
        icon: Icons.autorenew_rounded,
        color: Colors.indigo,
        title: 'Recurring charges found',
        message:
            '${state.recurringCandidates.length} transactions look like recurring subscriptions. Check the Subscriptions tab.',
      ),
    );
  }

  return insights;
});

int _noSpendStreak(List<TransactionModel> expenses, DateTime now) {
  int streak = 0;
  final expenseDays = expenses
      .map((tx) => DateTime(tx.date.year, tx.date.month, tx.date.day))
      .toSet();

  for (int i = 1; i <= 30; i++) {
    final day = now.subtract(Duration(days: i));
    if (!expenseDays.contains(DateTime(day.year, day.month, day.day))) {
      streak++;
    } else {
      break;
    }
  }
  return streak;
}

extension _ReduceOrNull<T> on List<T> {
  T? reduceOrNull(T Function(T, T) combine) {
    if (isEmpty) return null;
    return reduce(combine);
  }
}
