import 'package:expense_tracker/shared/models/transaction_model.dart';

abstract class TransactionRepository {
  List<TransactionModel> fetchTransactions();
  Future<void> saveTransactions(List<TransactionModel> transactions);
}
