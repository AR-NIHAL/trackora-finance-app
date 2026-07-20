import 'package:hive_ce/hive.dart';
import 'package:trackkora/core/constants/hive_boxes.dart';
import 'package:trackkora/features/transactions/data/models/transaction_model.dart';
import 'package:trackkora/features/transactions/domain/entities/transaction.dart';
import 'package:trackkora/features/transactions/domain/entities/transaction_type.dart';
import 'package:trackkora/features/transactions/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  late Box<TransactionModel> _box;

  TransactionRepositoryImpl() {
    _box = Hive.box<TransactionModel>(HiveBoxes.transactions);
  }

  @override
  Future<List<Transaction>> getAll() async {
    final models = _box.values.toList();
    models.sort((a, b) => b.date.compareTo(a.date));
    return models.map(_toEntity).toList();
  }

  @override
  Future<List<Transaction>> getByDateRange(DateTime start, DateTime end) async {
    final models = _box.values.where((m) {
      return m.date.isAfter(start.subtract(const Duration(days: 1))) &&
          m.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
    models.sort((a, b) => b.date.compareTo(a.date));
    return models.map(_toEntity).toList();
  }

  @override
  Future<List<Transaction>> getByCategory(String categoryId) async {
    final models = _box.values
        .where((m) => m.categoryId == categoryId)
        .toList();
    models.sort((a, b) => b.date.compareTo(a.date));
    return models.map(_toEntity).toList();
  }

  @override
  Future<Transaction?> getById(String id) async {
    final model = _box.values.firstWhere(
      (m) => m.id == id,
      orElse: () => throw Exception('Transaction not found'),
    );
    return _toEntity(model);
  }

  @override
  Future<void> add(Transaction transaction) async {
    final model = TransactionModel.fromEntity(transaction);
    await _box.add(model);
  }

  @override
  Future<void> update(Transaction transaction) async {
    final key = _box.keys.firstWhere(
      (k) => _box.get(k)?.id == transaction.id,
      orElse: () => throw Exception('Transaction not found'),
    );
    final model = TransactionModel.fromEntity(transaction);
    await _box.put(key, model);
  }

  @override
  Future<void> delete(String id) async {
    final key = _box.keys.firstWhere(
      (k) => _box.get(k)?.id == id,
      orElse: () => throw Exception('Transaction not found'),
    );
    await _box.delete(key);
  }

  @override
  Future<double> getTotalIncome({DateTime? start, DateTime? end}) async {
    final transactions = start != null && end != null
        ? await getByDateRange(start, end)
        : await getAll();
    double total = 0;
    for (final t in transactions) {
      if (t.type == TransactionType.income) total += t.amount;
    }
    return total;
  }

  @override
  Future<double> getTotalExpense({DateTime? start, DateTime? end}) async {
    final transactions = start != null && end != null
        ? await getByDateRange(start, end)
        : await getAll();
    double total = 0;
    for (final t in transactions) {
      if (t.type == TransactionType.expense) total += t.amount;
    }
    return total;
  }

  Transaction _toEntity(TransactionModel model) {
    return Transaction(
      id: model.id,
      title: model.title,
      amount: model.amount,
      type: model.type,
      categoryId: model.categoryId,
      date: model.date,
      notes: model.notes,
      isRecurring: model.isRecurring,
      recurringId: model.recurringId,
    );
  }
}
