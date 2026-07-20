import 'package:trackkora/features/recurring/domain/entities/recurring_transaction.dart';
import 'package:trackkora/features/transactions/domain/entities/transaction.dart';

abstract class RecurringRepository {
  Future<List<RecurringTransaction>> getAll();
  Future<RecurringTransaction?> getById(String id);
  Future<void> add(RecurringTransaction recurring);
  Future<void> update(RecurringTransaction recurring);
  Future<void> delete(String id);
  Future<List<Transaction>> generateDueTransactions();
}
