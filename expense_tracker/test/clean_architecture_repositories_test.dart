import 'package:expense_tracker/core/services/local_storage_service.dart';
import 'package:expense_tracker/features/add_transaction/data/repositories/local_transaction_repository.dart';
import 'package:expense_tracker/features/add_transaction/domain/repositories/transaction_repository.dart';
import 'package:expense_tracker/features/add_transaction/state/transaction_provider.dart';
import 'package:expense_tracker/features/budget/data/repositories/local_budget_repository.dart';
import 'package:expense_tracker/features/budget/domain/repositories/budget_repository.dart';
import 'package:expense_tracker/features/budget/state/budget_provider.dart';
import 'package:expense_tracker/features/goals/data/repositories/local_goal_repository.dart';
import 'package:expense_tracker/features/goals/domain/repositories/goal_repository.dart';
import 'package:expense_tracker/features/goals/state/goal_provider.dart';
import 'package:expense_tracker/features/settings/data/repositories/local_settings_repository.dart';
import 'package:expense_tracker/features/settings/domain/repositories/settings_repository.dart';
import 'package:expense_tracker/features/settings/state/settings_provider.dart';
import 'package:expense_tracker/shared/models/app_enums.dart';
import 'package:expense_tracker/shared/models/budget_model.dart';
import 'package:expense_tracker/shared/models/saving_goal_model.dart';
import 'package:expense_tracker/shared/models/transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InMemoryTransactionRepository implements TransactionRepository {
  List<TransactionModel> _items = [];

  @override
  List<TransactionModel> fetchTransactions() => List.unmodifiable(_items);

  @override
  Future<void> saveTransactions(List<TransactionModel> transactions) async {
    _items = List.from(transactions);
  }
}

class InMemoryBudgetRepository implements BudgetRepository {
  List<BudgetModel> _items = [];

  @override
  List<BudgetModel> fetchBudgets() => List.unmodifiable(_items);

  @override
  Future<void> saveBudgets(List<BudgetModel> budgets) async {
    _items = List.from(budgets);
  }
}

class InMemoryGoalRepository implements GoalRepository {
  List<SavingGoal> _items = [];

  @override
  List<SavingGoal> fetchGoals() => List.unmodifiable(_items);

  @override
  Future<void> saveGoals(List<SavingGoal> goals) async {
    _items = List.from(goals);
  }
}

class InMemorySettingsRepository implements SettingsRepository {
  Map<String, dynamic> _data = {};

  @override
  Map<String, dynamic> fetchSettings() => Map.unmodifiable(_data);

  @override
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    _data = Map.from(settings);
  }
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorageService.init();
  });

  group('Clean Architecture - TransactionRepository', () {
    test('LocalTransactionRepository reads and writes through storage service', () async {
      final repo = LocalTransactionRepository(LocalStorageService.instance);
      expect(repo.fetchTransactions(), isEmpty);

      final tx = TransactionModel(
        id: 'clean_tx_1',
        title: 'Architecture Review Coffee',
        amount: 4.75,
        type: TransactionType.expense,
        categoryId: 'exp_food',
        date: DateTime(2026, 9, 1),
      );

      await repo.saveTransactions([tx]);
      final fetched = repo.fetchTransactions();
      expect(fetched.length, 1);
      expect(fetched.first.title, 'Architecture Review Coffee');
    });

    test('TransactionNotifier accepts injected mock repository without touching storage', () {
      final mockRepo = InMemoryTransactionRepository();
      mockRepo.saveTransactions([
        TransactionModel(
          id: 'mock_1',
          title: 'Mock Salary',
          amount: 5000,
          type: TransactionType.income,
          categoryId: 'inc_salary',
          date: DateTime(2026, 9, 1),
        ),
      ]);

      final container = ProviderContainer(
        overrides: [
          transactionRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      final state = container.read(transactionProvider);
      expect(state.transactions.length, 1);
      expect(state.transactions.first.title, 'Mock Salary');

      container.read(transactionProvider.notifier).addTransaction(
            TransactionModel(
              id: 'mock_2',
              title: 'Mock Grocery',
              amount: 120,
              type: TransactionType.expense,
              categoryId: 'exp_food',
              date: DateTime(2026, 9, 2),
            ),
          );

      expect(mockRepo.fetchTransactions().length, 2);
    });
  });

  group('Clean Architecture - Budget, Goal, and Settings Repositories', () {
    test('BudgetNotifier uses injected BudgetRepository', () {
      final mockRepo = InMemoryBudgetRepository();
      mockRepo.saveBudgets([
        BudgetModel(
          id: 'b1',
          categoryId: 'exp_food',
          limitAmount: 500,
          month: DateTime(2026, 9),
        ),
      ]);

      final container = ProviderContainer(
        overrides: [
          budgetRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(budgetProvider).budgets.length, 1);
      expect(container.read(budgetProvider).budgets.first.limitAmount, 500);
    });

    test('GoalNotifier uses injected GoalRepository', () {
      final mockRepo = InMemoryGoalRepository();
      mockRepo.saveGoals([
        SavingGoal(
          id: 'g1',
          name: 'Emergency Fund',
          targetAmount: 3000,
          savedAmount: 1000,
        ),
      ]);

      final container = ProviderContainer(
        overrides: [
          goalRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(goalProvider).goals.length, 1);
      expect(container.read(goalProvider).goals.first.savedAmount, 1000);
    });

    test('SettingsNotifier uses injected SettingsRepository', () {
      final mockRepo = InMemorySettingsRepository();
      mockRepo.saveSettings({
        'isDarkMode': true,
        'currencyCode': 'EUR',
        'notificationsEnabled': false,
      });

      final container = ProviderContainer(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      final settings = container.read(settingsProvider);
      expect(settings.isDarkMode, true);
      expect(settings.currencyCode, 'EUR');
      expect(settings.notificationsEnabled, false);
    });

    test('LocalBudgetRepository saves and fetches budgets', () async {
      final repo = LocalBudgetRepository(LocalStorageService.instance);
      expect(repo.fetchBudgets(), isEmpty);

      final budget = BudgetModel(
        id: 'b1',
        categoryId: 'exp_food',
        limitAmount: 400,
        month: DateTime(2026, 9),
      );

      await repo.saveBudgets([budget]);
      final fetched = repo.fetchBudgets();
      expect(fetched.length, 1);
      expect(fetched.first.limitAmount, 400);
    });

    test('LocalGoalRepository saves and fetches goals', () async {
      final repo = LocalGoalRepository(LocalStorageService.instance);
      expect(repo.fetchGoals(), isEmpty);

      final goal = SavingGoal(
        id: 'g1',
        name: 'Vacation',
        targetAmount: 2000,
        savedAmount: 500,
      );

      await repo.saveGoals([goal]);
      final fetched = repo.fetchGoals();
      expect(fetched.length, 1);
      expect(fetched.first.savedAmount, 500);
    });

    test('LocalSettingsRepository saves and fetches settings', () async {
      final repo = LocalSettingsRepository(LocalStorageService.instance);
      final initial = repo.fetchSettings();
      expect(initial, isEmpty);

      await repo.saveSettings({'isDarkMode': true, 'currencyCode': 'EUR'});
      final updated = repo.fetchSettings();
      expect(updated['isDarkMode'], true);
      expect(updated['currencyCode'], 'EUR');
    });
  });

  group('Resilience & Safe Storage Decoding', () {
    test('corrupted transactions json does not crash the app', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('transactions_v2', 'NOT_VALID_JSON{[');

      final repo = LocalTransactionRepository(LocalStorageService.instance);
      final items = repo.fetchTransactions();
      expect(items, isEmpty);
    });
  });
}
