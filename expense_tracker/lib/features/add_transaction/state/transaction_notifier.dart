import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/shared/models/app_enums.dart';
import 'package:expense_tracker/shared/models/transaction_model.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'transaction_state.dart';

class TransactionNotifier extends StateNotifier<TransactionState> {
  TransactionNotifier()
    : super(TransactionState.initial(transactions: _dummyTransactions));

  void addTransaction(TransactionModel transaction) {
    state = state.copyWith(transactions: [...state.transactions, transaction]);
  }

  void deleteTransaction(String transactionId) {
    final updatedTransactions = state.transactions
        .where((item) => item.id != transactionId)
        .toList();

    state = state.copyWith(transactions: updatedTransactions);
  }

  void updateTransaction(TransactionModel updatedTransaction) {
    final updatedTransactions = state.transactions.map((item) {
      if (item.id == updatedTransaction.id) {
        return updatedTransaction;
      }
      return item;
    }).toList();

    state = state.copyWith(transactions: updatedTransactions);
  }

  TransactionModel? getById(String transactionId) {
    try {
      return state.transactions.firstWhere((item) => item.id == transactionId);
    } catch (_) {
      return null;
    }
  }
}

final List<TransactionModel> _dummyTransactions = [
  TransactionModel(
    id: 'txn_1',
    title: 'Starbucks Coffee',
    amount: 12.50,
    type: TransactionType.expense,
    categoryId: 'exp_food',
    date: DateTime(2026, 3, 19),
    note: 'Morning coffee',
  ),
  TransactionModel(
    id: 'txn_2',
    title: 'Monthly Salary',
    amount: 2800.00,
    type: TransactionType.income,
    categoryId: 'inc_salary',
    date: DateTime(2026, 3, 18),
    note: 'Company salary',
  ),
  TransactionModel(
    id: 'txn_3',
    title: 'Uber Ride',
    amount: 18.20,
    type: TransactionType.expense,
    categoryId: 'exp_transport',
    date: DateTime(2026, 3, 17),
    note: 'Client meeting ride',
  ),
  TransactionModel(
    id: 'txn_4',
    title: 'Groceries',
    amount: 84.75,
    type: TransactionType.expense,
    categoryId: 'exp_food',
    date: DateTime(2026, 3, 16),
    note: 'Weekly groceries',
  ),
  TransactionModel(
    id: 'txn_5',
    title: 'Freelance Payment',
    amount: 450.00,
    type: TransactionType.income,
    categoryId: 'inc_freelance',
    date: DateTime(2026, 3, 14),
    note: 'Landing page work',
  ),
];
