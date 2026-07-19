import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackora/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:trackora/features/transactions/domain/entities/transaction.dart';
import 'package:trackora/features/transactions/domain/repositories/transaction_repository.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepositoryImpl();
});

final transactionListProvider =
    StateNotifierProvider<TransactionListNotifier, AsyncValue<List<Transaction>>>(
  (ref) => TransactionListNotifier(ref.read(transactionRepositoryProvider)),
);

class TransactionListNotifier
    extends StateNotifier<AsyncValue<List<Transaction>>> {
  final TransactionRepository _repository;

  TransactionListNotifier(this._repository)
      : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getAll());
  }

  Future<void> add(Transaction transaction) async {
    await _repository.add(transaction);
    await _load();
  }

  Future<void> update(Transaction transaction) async {
    await _repository.update(transaction);
    await _load();
  }

  Future<void> delete(String id) async {
    await _repository.delete(id);
    await _load();
  }

  Future<void> refresh() async => _load();
}
