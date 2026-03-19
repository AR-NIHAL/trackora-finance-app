import 'package:flutter/foundation.dart';

@immutable
class BudgetModel {
  final String id;
  final String category;
  final double limitAmount;
  final DateTime createdAt;

  const BudgetModel({
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
