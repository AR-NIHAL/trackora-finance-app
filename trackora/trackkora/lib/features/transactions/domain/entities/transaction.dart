import 'package:freezed_annotation/freezed_annotation.dart';
import 'transaction_type.dart';

part 'transaction.freezed.dart';

@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String title,
    required double amount,
    required TransactionType type,
    required String categoryId,
    required DateTime date,
    String? notes,
    @Default(false) bool isRecurring,
    String? recurringId,
  }) = _Transaction;
}
