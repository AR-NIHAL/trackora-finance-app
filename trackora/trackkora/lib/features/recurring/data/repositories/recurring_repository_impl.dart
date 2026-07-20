import 'package:hive_ce/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:trackkora/core/constants/hive_boxes.dart';
import 'package:trackkora/features/recurring/data/models/recurring_transaction_model.dart';
import 'package:trackkora/features/recurring/domain/entities/recurring_transaction.dart';
import 'package:trackkora/features/recurring/domain/repositories/recurring_repository.dart';
import 'package:trackkora/features/transactions/domain/entities/transaction.dart';

class RecurringRepositoryImpl implements RecurringRepository {
  late Box<RecurringTransactionModel> _box;

  RecurringRepositoryImpl() {
    _box = Hive.box<RecurringTransactionModel>(HiveBoxes.recurring);
  }

  @override
  Future<List<RecurringTransaction>> getAll() async {
    return _box.values.map((m) => m.toEntity()).toList();
  }

  @override
  Future<RecurringTransaction?> getById(String id) async {
    final model = _box.values.firstWhere(
      (m) => m.id == id,
      orElse: () => throw Exception('Recurring transaction not found'),
    );
    return model.toEntity();
  }

  @override
  Future<void> add(RecurringTransaction recurring) async {
    final model = RecurringTransactionModel.fromEntity(recurring);
    await _box.put(recurring.id, model);
  }

  @override
  Future<void> update(RecurringTransaction recurring) async {
    final model = RecurringTransactionModel.fromEntity(recurring);
    await _box.put(recurring.id, model);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Future<List<Transaction>> generateDueTransactions() async {
    final now = DateTime.now();
    final all = _box.values.map((m) => m.toEntity()).toList();
    final dueTransactions = <Transaction>[];

    for (final recurring in all) {
      if (recurring.endDate != null && recurring.endDate!.isBefore(now)) {
        continue;
      }

      var nextDate = _getNextDate(recurring.startDate, recurring.frequency);

      while (nextDate.isBefore(now) || nextDate.isAtSameMomentAs(now)) {
        if (nextDate.isAfter(now)) break;

        dueTransactions.add(Transaction(
          id: const Uuid().v4(),
          title: recurring.title,
          amount: recurring.amount,
          type: recurring.type,
          categoryId: recurring.categoryId,
          date: nextDate,
          notes: recurring.notes,
          isRecurring: true,
          recurringId: recurring.id,
        ));

        nextDate = _getNextDate(nextDate.add(const Duration(days: 1)), recurring.frequency);
      }
    }

    return dueTransactions;
  }

  DateTime _getNextDate(DateTime from, RecurringFrequency frequency) {
    switch (frequency) {
      case RecurringFrequency.daily:
        return DateTime(from.year, from.month, from.day);
      case RecurringFrequency.weekly:
        return DateTime(from.year, from.month, from.day);
      case RecurringFrequency.monthly:
        return DateTime(from.year, from.month);
      case RecurringFrequency.yearly:
        return DateTime(from.year);
    }
  }
}
