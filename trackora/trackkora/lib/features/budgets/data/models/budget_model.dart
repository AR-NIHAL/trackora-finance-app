import 'package:hive_ce/hive.dart';
import 'package:trackkora/features/budgets/domain/entities/budget.dart';

class BudgetModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String categoryId;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime month;

  BudgetModel({
    required this.id,
    required this.categoryId,
    required this.amount,
    required this.month,
  });

  factory BudgetModel.fromEntity(Budget budget) {
    return BudgetModel(
      id: budget.id,
      categoryId: budget.categoryId,
      amount: budget.amount,
      month: budget.month,
    );
  }

  Budget toEntity() {
    return Budget(
      id: id,
      categoryId: categoryId,
      amount: amount,
      month: month,
    );
  }
}
