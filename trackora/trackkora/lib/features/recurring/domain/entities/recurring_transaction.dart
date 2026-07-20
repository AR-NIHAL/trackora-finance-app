import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackkora/features/transactions/domain/entities/transaction_type.dart';

part 'recurring_transaction.freezed.dart';

@freezed
abstract class RecurringTransaction with _$RecurringTransaction {
  const factory RecurringTransaction({
    required String id,
    required String title,
    required double amount,
    required TransactionType type,
    required String categoryId,
    required RecurringFrequency frequency,
    required DateTime startDate,
    DateTime? endDate,
    String? notes,
  }) = _RecurringTransaction;
}

enum RecurringFrequency { daily, weekly, monthly, yearly }
