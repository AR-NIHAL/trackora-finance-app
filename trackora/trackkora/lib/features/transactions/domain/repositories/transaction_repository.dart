import 'package:trackkora/features/transactions/domain/entities/transaction.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getAll();
  Future<List<Transaction>> getByDateRange(DateTime start, DateTime end);
  Future<List<Transaction>> getByCategory(String categoryId);
  Future<Transaction?> getById(String id);
  Future<void> add(Transaction transaction);
  Future<void> update(Transaction transaction);
  Future<void> delete(String id);
  Future<double> getTotalIncome({DateTime? start, DateTime? end});
  Future<double> getTotalExpense({DateTime? start, DateTime? end});
}
