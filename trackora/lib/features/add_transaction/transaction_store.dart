import 'database_helper.dart';
import 'transaction_model.dart';

class TransactionStore {
  static Future<void> addTransaction(TransactionModel transaction) async {
    final db = await DatabaseHelper.database;
    await db.insert('transactions', transaction.toMap());
  }

  static Future<void> deleteTransaction(String id) async {
    final db = await DatabaseHelper.database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<TransactionModel>> getTransactions() async {
    final db = await DatabaseHelper.database;
    final result = await db.query('transactions', orderBy: 'date DESC');
    return result.map((e) => TransactionModel.fromMap(e)).toList();
  }

  static Future<double> getCurrentMonthIncome() async {
    final items = await getTransactions();
    final now = DateTime.now();

    double total = 0;
    for (final item in items) {
      final sameMonth =
          item.date.year == now.year && item.date.month == now.month;
      if (item.type == 'Income' && sameMonth) {
        total += item.amount;
      }
    }
    return total;
  }
}
