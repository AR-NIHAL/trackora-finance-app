import 'dart:convert';

import 'package:expense_tracker/shared/models/budget_model.dart';
import 'package:expense_tracker/shared/models/saving_goal_model.dart';
import 'package:expense_tracker/shared/models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService._();

  static final LocalStorageService instance = LocalStorageService._();
  static SharedPreferences? _prefs;

  static const _transactionsKey = 'transactions_v1';
  static const _budgetsKey = 'budgets_v1';
  static const _settingsKey = 'settings_v1';
  static const _goalsKey = 'goals_v1';
  static const _seedFlagKey = 'seeded_v1';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get isSeeded => _prefs?.getBool(_seedFlagKey) ?? false;

  void markSeeded() {
    _prefs?.setBool(_seedFlagKey, true);
  }

  List<TransactionModel> getTransactions() {
    final raw = _prefs?.getString(_transactionsKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((item) => TransactionModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveTransactions(List<TransactionModel> transactions) async {
    final raw = jsonEncode(
      transactions.map((item) => item.toJson()).toList(),
    );
    await _prefs?.setString(_transactionsKey, raw);
  }

  List<BudgetModel> getBudgets() {
    final raw = _prefs?.getString(_budgetsKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((item) => BudgetModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveBudgets(List<BudgetModel> budgets) async {
    final raw = jsonEncode(budgets.map((item) => item.toJson()).toList());
    await _prefs?.setString(_budgetsKey, raw);
  }

  Map<String, dynamic> getSettings() {
    final raw = _prefs?.getString(_settingsKey);
    if (raw == null) return {};
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> saveSettings(Map<String, dynamic> settings) async {
    await _prefs?.setString(_settingsKey, jsonEncode(settings));
  }

  List<SavingGoal> getGoals() {
    final raw = _prefs?.getString(_goalsKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((item) => SavingGoal.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveGoals(List<SavingGoal> goals) async {
    await _prefs?.setString(
      _goalsKey,
      jsonEncode(goals.map((item) => item.toJson()).toList()),
    );
  }
}
