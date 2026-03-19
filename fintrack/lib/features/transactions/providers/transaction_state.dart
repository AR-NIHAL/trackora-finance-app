import '../data/models/transaction_model.dart';

class TransactionState {
  final List<TransactionModel> transactions;

  const TransactionState({required this.transactions});

  factory TransactionState.initial() {
    return const TransactionState(transactions: []);
  }

  TransactionState copyWith({List<TransactionModel>? transactions}) {
    return TransactionState(transactions: transactions ?? this.transactions);
  }

  double get totalIncome {
    return transactions
        .where((tx) => tx.type == 'income')
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  double get totalExpense {
    return transactions
        .where((tx) => tx.type == 'expense')
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  double get totalBalance {
    return totalIncome - totalExpense;
  }
}
