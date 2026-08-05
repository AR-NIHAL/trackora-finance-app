import 'package:expense_tracker/shared/models/transaction_model.dart';

class TransactionState {
  final List<TransactionModel> transactions;

  const TransactionState({required this.transactions});

  factory TransactionState.initial({
    List<TransactionModel> transactions = const [],
  }) {
    return TransactionState(transactions: transactions);
  }

  TransactionState copyWith({List<TransactionModel>? transactions}) {
    return TransactionState(transactions: transactions ?? this.transactions);
  }

  double get totalIncome {
    return transactions
        .where((item) => item.isIncome)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get totalExpense {
    return transactions
        .where((item) => item.isExpense)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get totalBalance {
    return totalIncome - totalExpense;
  }

  int get totalTransactionCount => transactions.length;

  List<TransactionModel> get sortedByDateDesc {
    final sorted = [...transactions]..sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  List<TransactionModel> get recentTransactions {
    return sortedByDateDesc.take(5).toList();
  }

  List<TransactionModel> get expenses {
    return transactions.where((item) => item.isExpense).toList();
  }

  bool isInMonth(TransactionModel item, DateTime month) {
    return item.date.year == month.year && item.date.month == month.month;
  }

  double incomeInMonth(DateTime month) {
    return transactions
        .where((item) => item.isIncome && isInMonth(item, month))
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double expenseInMonth(DateTime month) {
    return transactions
        .where((item) => item.isExpense && isInMonth(item, month))
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  Map<String, double> get spentByCategory {
    final map = <String, double>{};
    for (final item in expenses) {
      map[item.categoryId] = (map[item.categoryId] ?? 0) + item.amount;
    }
    return map;
  }

  Map<String, double> incomeByCategory() {
    final map = <String, double>{};
    for (final item in transactions.where((item) => item.isIncome)) {
      map[item.categoryId] = (map[item.categoryId] ?? 0) + item.amount;
    }
    return map;
  }

  List<TransactionModel> get recurringCandidates {
    final grouped = <String, List<TransactionModel>>{};
    for (final item in expenses) {
      final key = '${item.title.toLowerCase()}|${item.amount.toStringAsFixed(2)}';
      grouped.putIfAbsent(key, () => []).add(item);
    }

    final candidates = <TransactionModel>[];
    for (final group in grouped.values) {
      if (group.length >= 2) {
        final months =
            group.map((item) => '${item.date.year}-${item.date.month}').toSet();
        if (months.length >= 2) {
          candidates.addAll(group);
        }
      }
    }
    return candidates;
  }
}
