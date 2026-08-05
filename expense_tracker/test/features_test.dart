import 'package:expense_tracker/core/services/export_service.dart';
import 'package:expense_tracker/core/services/local_storage_service.dart';
import 'package:expense_tracker/features/add_transaction/state/transaction_provider.dart';
import 'package:expense_tracker/features/goals/state/goal_provider.dart';
import 'package:expense_tracker/features/subscriptions/state/subscriptions_provider.dart';
import 'package:expense_tracker/shared/models/app_enums.dart';
import 'package:expense_tracker/shared/models/dummy_categories.dart';
import 'package:expense_tracker/shared/models/saving_goal_model.dart';
import 'package:expense_tracker/shared/models/transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

TransactionModel _expense(String id, String title, double amount, DateTime date) {
  return TransactionModel(
    id: id,
    title: title,
    amount: amount,
    type: TransactionType.expense,
    categoryId: 'exp_food',
    date: date,
  );
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorageService.init();
  });

  test('csv export includes header and rows', () {
    final csv = ExportService.buildCsv([
      _expense('1', 'Lunch, with "deals"', 10.5, DateTime(2026, 8, 1)),
      _expense('2', 'Dinner', 20, DateTime(2026, 8, 2)),
    ]);

    expect(csv, contains('Title,Amount,Type,Category,Date,Note'));
    expect(csv, contains('Food'));
    expect(csv, contains('expense'));
    expect(csv, contains('10.50'));
  });

  test('backup json round trips', () {
    final json = ExportService.buildBackupJson(
      transactions: [_expense('1', 'Lunch', 5, DateTime(2026, 8, 1))],
      budgets: const [],
      goals: const [],
    );

    expect(json, contains('"transactions"'));
    expect(json, contains('Lunch'));
  });

  test('subscriptions detects recurring charges', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(transactionProvider.notifier).replaceAll([
      _expense('1', 'Netflix', 15.99, DateTime(2026, 6, 10)),
      _expense('2', 'Netflix', 15.99, DateTime(2026, 7, 10)),
      _expense('3', 'Netflix', 15.99, DateTime(2026, 8, 10)),
      _expense('4', 'Coffee', 4, DateTime(2026, 8, 1)),
    ]);

    final subs = container.read(subscriptionsProvider);
    expect(subs.length, 1);
    expect(subs.first.title, 'Netflix');
    expect(subs.first.occurrenceCount, 3);
  });

  test('goals provider add and contribute', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final goal = SavingGoal(
      id: 'g1',
      name: 'Emergency fund',
      targetAmount: 1000,
    );
    container.read(goalProvider.notifier).addGoal(goal);
    container.read(goalProvider.notifier).contribute('g1', 250);

    final stored = container.read(goalProvider).goals.first;
    expect(stored.savedAmount, 250);
    expect(stored.remainingAmount, 750);
  });

  test('dummy categories can be looked up', () {
    final food = DummyCategories.findById('exp_food');
    expect(food?.name, 'Food');
    expect(DummyCategories.findById('nope'), isNull);
  });
}