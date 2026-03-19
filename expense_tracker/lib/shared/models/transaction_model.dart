import 'app_enums.dart';

class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final String categoryId;
  final DateTime date;
  final String note;
  final bool isRecurring;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
    this.note = '',
    this.isRecurring = false,
  });

  TransactionModel copyWith({
    String? id,
    String? title,
    double? amount,
    TransactionType? type,
    String? categoryId,
    DateTime? date,
    String? note,
    bool? isRecurring,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      note: note ?? this.note,
      isRecurring: isRecurring ?? this.isRecurring,
    );
  }

  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;

  @override
  String toString() {
    return 'TransactionModel(id: $id, title: $title, amount: $amount, type: $type, categoryId: $categoryId, date: $date, note: $note, isRecurring: $isRecurring)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionModel &&
        other.id == id &&
        other.title == title &&
        other.amount == amount &&
        other.type == type &&
        other.categoryId == categoryId &&
        other.date == date &&
        other.note == note &&
        other.isRecurring == isRecurring;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        amount.hashCode ^
        type.hashCode ^
        categoryId.hashCode ^
        date.hashCode ^
        note.hashCode ^
        isRecurring.hashCode;
  }
}
