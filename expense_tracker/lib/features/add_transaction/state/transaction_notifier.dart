import 'package:expense_tracker/core/services/local_storage_service.dart';
import 'package:expense_tracker/shared/models/app_enums.dart';
import 'package:expense_tracker/shared/models/transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'transaction_state.dart';

class TransactionNotifier extends Notifier<TransactionState> {
  @override
  TransactionState build() {
    final storage = LocalStorageService.instance;
    final stored = storage.getTransactions();

    if (!storage.isSeeded) {
      storage.markSeeded();
      storage.saveTransactions(_dummyTransactions());
      return TransactionState.initial(transactions: _dummyTransactions());
    }

    return TransactionState(transactions: stored);
  }

  void _persist() {
    LocalStorageService.instance.saveTransactions(state.transactions);
  }

  void addTransaction(TransactionModel transaction) {
    state = state.copyWith(transactions: [...state.transactions, transaction]);
    _persist();
  }

  void deleteTransaction(String transactionId) {
    final updatedTransactions = state.transactions
        .where((item) => item.id != transactionId)
        .toList();

    state = state.copyWith(transactions: updatedTransactions);
    _persist();
  }

  void updateTransaction(TransactionModel updatedTransaction) {
    final updatedTransactions = state.transactions.map((item) {
      if (item.id == updatedTransaction.id) {
        return updatedTransaction;
      }
      return item;
    }).toList();

    state = state.copyWith(transactions: updatedTransactions);
    _persist();
  }

  TransactionModel? getById(String transactionId) {
    for (final item in state.transactions) {
      if (item.id == transactionId) return item;
    }
    return null;
  }

  void reset() {
    state = TransactionState.initial(transactions: []);
    _persist();
  }

  void replaceAll(List<TransactionModel> transactions) {
    state = TransactionState(transactions: transactions);
    _persist();
  }
}

List<TransactionModel> _dummyTransactions() {
  final now = DateTime.now();

  TransactionModel tx(
    String id,
    String title,
    double amount,
    TransactionType type,
    String categoryId,
    DateTime date, {
    String note = '',
    bool isRecurring = false,
  }) {
    return TransactionModel(
      id: id,
      title: title,
      amount: amount,
      type: type,
      categoryId: categoryId,
      date: date,
      note: note,
      isRecurring: isRecurring,
    );
  }

  return [
    tx(
      'txn_1',
      'Starbucks Coffee',
      12.50,
      TransactionType.expense,
      'exp_food',
      now.subtract(const Duration(days: 1)),
      note: 'Morning coffee',
    ),
    tx(
      'txn_2',
      'Monthly Salary',
      2800.00,
      TransactionType.income,
      'inc_salary',
      DateTime(now.year, now.month, 1),
      note: 'Company salary',
      isRecurring: true,
    ),
    tx(
      'txn_3',
      'Uber Ride',
      18.20,
      TransactionType.expense,
      'exp_transport',
      now.subtract(const Duration(days: 3)),
      note: 'Client meeting ride',
    ),
    tx(
      'txn_4',
      'Groceries',
      84.75,
      TransactionType.expense,
      'exp_food',
      now.subtract(const Duration(days: 4)),
      note: 'Weekly groceries',
    ),
    tx(
      'txn_5',
      'Freelance Payment',
      450.00,
      TransactionType.income,
      'inc_freelance',
      now.subtract(const Duration(days: 6)),
      note: 'Landing page work',
    ),
    tx(
      'txn_6',
      'Netflix Subscription',
      15.99,
      TransactionType.expense,
      'exp_entertainment',
      DateTime(now.year, now.month - 1, 10),
      note: 'Monthly plan',
      isRecurring: true,
    ),
    tx(
      'txn_7',
      'Electricity Bill',
      62.40,
      TransactionType.expense,
      'exp_bills',
      DateTime(now.year, now.month - 1, 15),
      note: 'Utility bill',
      isRecurring: true,
    ),
  ];
}
