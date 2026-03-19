class BudgetModel {
  final String id;
  final String categoryId;
  final double limitAmount;
  final DateTime month;
  final double spentAmount;

  const BudgetModel({
    required this.id,
    required this.categoryId,
    required this.limitAmount,
    required this.month,
    this.spentAmount = 0,
  });

  BudgetModel copyWith({
    String? id,
    String? categoryId,
    double? limitAmount,
    DateTime? month,
    double? spentAmount,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      limitAmount: limitAmount ?? this.limitAmount,
      month: month ?? this.month,
      spentAmount: spentAmount ?? this.spentAmount,
    );
  }

  double get remainingAmount => limitAmount - spentAmount;

  bool get isExceeded => spentAmount > limitAmount;

  double get progress {
    if (limitAmount <= 0) return 0;
    final value = spentAmount / limitAmount;
    return value.clamp(0, 1);
  }

  @override
  String toString() {
    return 'BudgetModel(id: $id, categoryId: $categoryId, limitAmount: $limitAmount, month: $month, spentAmount: $spentAmount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BudgetModel &&
        other.id == id &&
        other.categoryId == categoryId &&
        other.limitAmount == limitAmount &&
        other.month == month &&
        other.spentAmount == spentAmount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        categoryId.hashCode ^
        limitAmount.hashCode ^
        month.hashCode ^
        spentAmount.hashCode;
  }
}
