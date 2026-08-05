import 'package:expense_tracker/features/add_transaction/state/transaction_provider.dart';
import 'package:expense_tracker/shared/models/transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionItem {
  final String title;
  final double amount;
  final String categoryId;
  final DateTime lastOccurrence;
  final DateTime nextOccurrence;
  final int occurrenceCount;
  final List<TransactionModel> transactions;

  const SubscriptionItem({
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.lastOccurrence,
    required this.nextOccurrence,
    required this.occurrenceCount,
    required this.transactions,
  });
}

final subscriptionsProvider = Provider<List<SubscriptionItem>>((ref) {
  final state = ref.watch(transactionProvider);
  final now = DateTime.now();

  final grouped = <String, List<TransactionModel>>{};
  for (final item in state.expenses) {
    final key = '${item.title.toLowerCase()}|${item.amount.toStringAsFixed(2)}';
    grouped.putIfAbsent(key, () => []).add(item);
  }

  final subscriptions = <SubscriptionItem>[];

  for (final group in grouped.values) {
    final months =
        group.map((item) => '${item.date.year}-${item.date.month}').toSet();
    final isRecurring =
        group.any((item) => item.isRecurring) || months.length >= 2;

    if (!isRecurring) continue;

    final sorted = [...group]..sort((a, b) => b.date.compareTo(a.date));
    final last = sorted.first;
    final next = DateTime(last.date.year, last.date.month + 1, last.date.day);

    subscriptions.add(
      SubscriptionItem(
        title: last.title,
        amount: last.amount,
        categoryId: last.categoryId,
        lastOccurrence: last.date,
        nextOccurrence: next.isBefore(now) ? now : next,
        occurrenceCount: group.length,
        transactions: sorted,
      ),
    );
  }

  subscriptions.sort((a, b) => a.nextOccurrence.compareTo(b.nextOccurrence));
  return subscriptions;
});

final upcomingRecurringExpenseProvider = Provider<double>((ref) {
  final subscriptions = ref.watch(subscriptionsProvider);
  final now = DateTime.now();
  final endOfMonth = DateTime(now.year, now.month + 1, 1).subtract(
    const Duration(days: 1),
  );

  return subscriptions
      .where((sub) => !sub.nextOccurrence.isAfter(endOfMonth))
      .fold(0.0, (sum, sub) => sum + sub.amount);
});
