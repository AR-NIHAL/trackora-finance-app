import 'package:hive_ce/hive.dart';
import 'package:trackkora/features/recurring/domain/entities/recurring_transaction.dart';
import 'package:trackkora/features/transactions/domain/entities/transaction_type.dart';

class RecurringTransactionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final int typeIndex;

  @HiveField(4)
  final String categoryId;

  @HiveField(5)
  final int frequencyIndex;

  @HiveField(6)
  final DateTime startDate;

  @HiveField(7)
  final DateTime? endDate;

  @HiveField(8)
  final String? notes;

  RecurringTransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.typeIndex,
    required this.categoryId,
    required this.frequencyIndex,
    required this.startDate,
    this.endDate,
    this.notes,
  });

  TransactionType get type => TransactionType.values[typeIndex];

  RecurringFrequency get frequency => RecurringFrequency.values[frequencyIndex];

  factory RecurringTransactionModel.fromEntity(RecurringTransaction entity) {
    return RecurringTransactionModel(
      id: entity.id,
      title: entity.title,
      amount: entity.amount,
      typeIndex: entity.type.index,
      categoryId: entity.categoryId,
      frequencyIndex: entity.frequency.index,
      startDate: entity.startDate,
      endDate: entity.endDate,
      notes: entity.notes,
    );
  }

  RecurringTransaction toEntity() {
    return RecurringTransaction(
      id: id,
      title: title,
      amount: amount,
      type: type,
      categoryId: categoryId,
      frequency: frequency,
      startDate: startDate,
      endDate: endDate,
      notes: notes,
    );
  }
}
