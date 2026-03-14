import 'package:hive/hive.dart';
import 'transaction_model.dart';

class TransactionStore {
  static Box<TransactionModel> get _box =>
      Hive.box<TransactionModel>('transactionsBox');

  static List<TransactionModel> get transactions =>
      _box.values.toList()..sort((a, b) => b.date.compareTo(a.date));

  static Future<void> addTransaction(TransactionModel transaction) async {
    await _box.put(transaction.id, transaction);
  }

  static Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
  }

  static bool _isSameMonth(DateTime date, DateTime now) {
    return date.year == now.year && date.month == now.month;
  }

  static bool _isSameDay(DateTime date, DateTime now) {
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static double get totalIncome {
    double total = 0;
    for (final item in transactions) {
      if (item.type == 'Income') total += item.amount;
    }
    return total;
  }

  static double get totalExpense {
    double total = 0;
    for (final item in transactions) {
      if (item.type == 'Expense') total += item.amount;
    }
    return total;
  }

  static double get totalBalance => totalIncome - totalExpense;

  static double get currentMonthIncome {
    final now = DateTime.now();
    double total = 0;
    for (final item in transactions) {
      if (item.type == 'Income' && _isSameMonth(item.date, now)) {
        total += item.amount;
      }
    }
    return total;
  }

  static double get currentMonthExpense {
    final now = DateTime.now();
    double total = 0;
    for (final item in transactions) {
      if (item.type == 'Expense' && _isSameMonth(item.date, now)) {
        total += item.amount;
      }
    }
    return total;
  }

  static double get todayExpense {
    final now = DateTime.now();
    double total = 0;
    for (final item in transactions) {
      if (item.type == 'Expense' && _isSameDay(item.date, now)) {
        total += item.amount;
      }
    }
    return total;
  }

  static Map<String, double> get currentMonthCategoryExpenseMap {
    final now = DateTime.now();
    final Map<String, double> data = {};
    for (final item in transactions) {
      if (item.type == 'Expense' && _isSameMonth(item.date, now)) {
        data[item.category] = (data[item.category] ?? 0) + item.amount;
      }
    }
    return data;
  }

  static String get topExpenseCategory {
    final map = currentMonthCategoryExpenseMap;
    if (map.isEmpty) return 'No data';
    final sorted = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }

  static List<TransactionModel> filteredTransactions({
    String query = '',
    String type = 'All',
    String category = 'All',
  }) {
    return transactions.where((item) {
      final matchesQuery =
          query.isEmpty ||
          item.note.toLowerCase().contains(query.toLowerCase()) ||
          item.category.toLowerCase().contains(query.toLowerCase());

      final matchesType = type == 'All' || item.type == type;
      final matchesCategory = category == 'All' || item.category == category;

      return matchesQuery && matchesType && matchesCategory;
    }).toList();
  }

  static List<String> get allCategories {
    final set = <String>{};
    for (final item in transactions) {
      set.add(item.category);
    }
    return set.toList()..sort();
  }

  static List<double> get last7DaysExpenses {
    final now = DateTime.now();
    final List<double> data = List.filled(7, 0);

    for (int i = 0; i < 7; i++) {
      final day = DateTime(now.year, now.month, now.day - (6 - i));
      double total = 0;
      for (final item in transactions) {
        if (item.type == 'Expense' &&
            item.date.year == day.year &&
            item.date.month == day.month &&
            item.date.day == day.day) {
          total += item.amount;
        }
      }
      data[i] = total;
    }

    return data;
  }
}
