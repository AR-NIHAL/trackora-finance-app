import 'package:expense_tracker/core/services/local_storage_service.dart';
import 'package:expense_tracker/features/add_transaction/domain/repositories/transaction_repository.dart';
import 'package:expense_tracker/shared/models/transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final storageService = ref.watch(localStorageServiceProvider);
  return LocalTransactionRepository(storageService);
});

class LocalTransactionRepository implements TransactionRepository {
  final LocalStorageService _storageService;

  LocalTransactionRepository(this._storageService);

  @override
  List<TransactionModel> fetchTransactions() {
    return _storageService.getTransactions();
  }

  @override
  Future<void> saveTransactions(List<TransactionModel> transactions) {
    return _storageService.saveTransactions(transactions);
  }
}
