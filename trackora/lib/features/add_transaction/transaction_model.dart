import 'package:hive/hive.dart';

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
}

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 0;

  @override
  TransactionModel read(BinaryReader reader) {
    return TransactionModel(
      id: reader.readString(),
      type: reader.readString(),
      amount: reader.readDouble(),
      category: reader.readString(),
      note: reader.readString(),
      date: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.type);
    writer.writeDouble(obj.amount);
    writer.writeString(obj.category);
    writer.writeString(obj.note);
    writer.writeInt(obj.date.millisecondsSinceEpoch);
  }
}
