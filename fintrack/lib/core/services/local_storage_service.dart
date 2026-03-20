import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../features/budget/data/models/budget_model.dart';
import '../../features/transactions/data/models/transaction_model.dart';

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

class LocalStorageService {
  static const String transactionBoxName = 'transactions_box';
  static const String budgetBoxName = 'budgets_box';

  Box<TransactionModel> get _transactionBox =>
      Hive.box<TransactionModel>(transactionBoxName);

  Box<BudgetModel> get _budgetBox => Hive.box<BudgetModel>(budgetBoxName);

  Future<List<TransactionModel>> getAllTransactions() async {
    return _transactionBox.values.toList();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await _transactionBox.put(transaction.id, transaction);
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await _transactionBox.put(transaction.id, transaction);
  }

  Future<void> deleteTransaction(String id) async {
    await _transactionBox.delete(id);
  }

  Future<void> clearTransactions() async {
    await _transactionBox.clear();
  }

  Future<List<BudgetModel>> getAllBudgets() async {
    return _budgetBox.values.toList();
  }

  Future<void> addBudget(BudgetModel budget) async {
    await _budgetBox.put(budget.id, budget);
  }

  Future<void> updateBudget(BudgetModel budget) async {
    await _budgetBox.put(budget.id, budget);
  }

  Future<void> deleteBudget(String id) async {
    await _budgetBox.delete(id);
  }

  Future<void> clearBudgets() async {
    await _budgetBox.clear();
  }
}
