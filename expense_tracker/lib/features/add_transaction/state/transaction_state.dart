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

  List<TransactionModel> get recentTransactions {
    final sorted = [...transactions]..sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  int get totalTransactionCount => transactions.length;
}
