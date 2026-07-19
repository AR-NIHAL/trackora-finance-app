import 'package:hive_ce/hive.dart';
import 'package:trackora/core/constants/app_constants.dart';
import 'package:trackora/features/transactions/data/models/transaction_model.dart';
import 'package:trackora/features/transactions/domain/entities/transaction.dart';
import 'package:trackora/features/transactions/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  Box<TransactionModel> get _box =>
      Hive.box<TransactionModel>(AppConstants.transactionsBox);

  Transaction _toEntity(TransactionModel model) {
    return Transaction(
      id: model.id,
      amount: model.amount,
      type: model.type == TransactionTypeModel.income
          ? TransactionType.income
          : TransactionType.expense,
      categoryId: model.categoryId,
      date: model.date,
      note: model.note,
    );
  }

  TransactionModel _toModel(Transaction entity) {
    return TransactionModel(
      id: entity.id,
      amount: entity.amount,
      type: entity.type == TransactionType.income
          ? TransactionTypeModel.income
          : TransactionTypeModel.expense,
      categoryId: entity.categoryId,
      date: entity.date,
      note: entity.note,
    );
  }

  @override
  Future<List<Transaction>> getAll() async {
    final list = _box.values.map(_toEntity).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  Future<Transaction?> getById(String id) async {
    final model = _box.get(id);
    return model != null ? _toEntity(model) : null;
  }

  @override
  Future<void> add(Transaction transaction) async {
    await _box.put(transaction.id, _toModel(transaction));
  }

  @override
  Future<void> update(Transaction transaction) async {
    await _box.put(transaction.id, _toModel(transaction));
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
