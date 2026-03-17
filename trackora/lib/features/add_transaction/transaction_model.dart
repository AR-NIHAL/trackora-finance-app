class TransactionModel {
  final String id;
  final String type;
  final double amount;
  final String category;
  final String note;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.note,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'category': category,
      'note': note,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as String,
      type: map['type'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      note: map['note'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }
}
