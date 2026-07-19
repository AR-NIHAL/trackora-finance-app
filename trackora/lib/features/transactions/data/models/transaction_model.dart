import 'package:hive_ce/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 2)
enum TransactionTypeModel {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}

@HiveType(typeId: 3)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final TransactionTypeModel type;

  @HiveField(3)
  final String categoryId;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final String note;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
    required this.note,
  });
}
