import 'transaction_model.dart';

class TransactionStore {
  static final List<TransactionModel> transactions = [];

  static void addTransaction(TransactionModel transaction) {
    transactions.add(transaction);
  }

  static void deleteTransaction(String id) {
    transactions.removeWhere((item) => item.id == id);
  }

  static double get totalIncome {
    double total = 0;
    for (final item in transactions) {
      if (item.type == 'Income') {
        total += item.amount;
      }
    }
    return total;
  }

  static double get totalExpense {
    double total = 0;
    for (final item in transactions) {
      if (item.type == 'Expense') {
        total += item.amount;
      }
    }
    return total;
  }

  static double get totalBalance {
    return totalIncome - totalExpense;
  }
}
