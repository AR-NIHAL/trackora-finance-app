import 'package:hive_ce/hive.dart';
import 'package:trackkora/features/transactions/domain/entities/transaction_type.dart';

class TransactionModel extends HiveObject {
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
  final DateTime date;

  @HiveField(6)
  final String? notes;

  @HiveField(7)
  final bool isRecurring;

  @HiveField(8)
  final String? recurringId;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.typeIndex,
    required this.categoryId,
    required this.date,
    this.notes,
    this.isRecurring = false,
    this.recurringId,
  });

  TransactionType get type => TransactionType.values[typeIndex];

  factory TransactionModel.fromEntity(dynamic entity) {
    return TransactionModel(
      id: entity.id,
      title: entity.title,
      amount: entity.amount,
      typeIndex: entity.type.index,
      categoryId: entity.categoryId,
      date: entity.date,
      notes: entity.notes,
      isRecurring: entity.isRecurring,
      recurringId: entity.recurringId,
    );
  }
}
