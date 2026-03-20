import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'budget_model.g.dart';

@HiveType(typeId: 1)
@immutable
class BudgetModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final double limitAmount;

  @HiveField(3)
  final DateTime createdAt;

  BudgetModel({
    required this.id,
    required this.category,
    required this.limitAmount,
    required this.createdAt,
  });

  BudgetModel copyWith({
    String? id,
    String? category,
    double? limitAmount,
    DateTime? createdAt,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      category: category ?? this.category,
      limitAmount: limitAmount ?? this.limitAmount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
