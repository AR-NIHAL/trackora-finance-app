import 'package:expense_tracker/core/services/local_storage_service.dart';
import 'package:expense_tracker/shared/models/app_enums.dart';
import 'package:expense_tracker/shared/models/budget_model.dart';
import 'package:expense_tracker/shared/models/transaction_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorageService.init();
  });

  test('transaction serialization round trip', () {
    final transaction = TransactionModel(
      id: 't1',
      title: 'Lunch',
      amount: 12.5,
      type: TransactionType.expense,
      categoryId: 'exp_food',
      date: DateTime(2026, 8, 1),
      note: 'test note',
      isRecurring: true,
    );

    final restored = TransactionModel.fromJson(transaction.toJson());

    expect(restored.id, transaction.id);
    expect(restored.title, transaction.title);
    expect(restored.amount, transaction.amount);
    expect(restored.type, transaction.type);
    expect(restored.categoryId, transaction.categoryId);
    expect(restored.date, transaction.date);
    expect(restored.note, transaction.note);
    expect(restored.isRecurring, transaction.isRecurring);
  });

  test('budget serialization round trip', () {
    final budget = BudgetModel(
      id: 'exp_food_2026_8',
      categoryId: 'exp_food',
      limitAmount: 300,
      month: DateTime(2026, 8),
    );

    final restored = BudgetModel.fromJson(budget.toJson());

    expect(restored.id, budget.id);
    expect(restored.categoryId, budget.categoryId);
    expect(restored.limitAmount, budget.limitAmount);
    expect(restored.month, budget.month);
  });

  test('storage persists and reads transactions', () async {
    final storage = LocalStorageService.instance;

    await storage.saveTransactions([
      TransactionModel(
        id: 't1',
        title: 'Test',
        amount: 5,
        type: TransactionType.expense,
        categoryId: 'exp_food',
        date: DateTime(2026, 8, 1),
      ),
    ]);

    final restored = storage.getTransactions();
    expect(restored.length, 1);
    expect(restored.first.title, 'Test');
  });

  test('storage seeds flag', () {
    final storage = LocalStorageService.instance;
    expect(storage.isSeeded, isFalse);
    storage.markSeeded();
    expect(storage.isSeeded, isTrue);
  });
}
