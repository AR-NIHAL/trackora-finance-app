import 'dart:convert';

import 'package:expense_tracker/shared/models/budget_model.dart';
import 'package:expense_tracker/shared/models/dummy_categories.dart';
import 'package:expense_tracker/shared/models/saving_goal_model.dart';
import 'package:expense_tracker/shared/models/transaction_model.dart';

class ExportService {
  ExportService._();

  static String buildCsv(List<TransactionModel> transactions) {
    final buffer = StringBuffer();
    buffer.writeln('Title,Amount,Type,Category,Date,Note');

    final sorted = [...transactions]..sort((a, b) => a.date.compareTo(b.date));

    for (final tx in sorted) {
      final category = DummyCategories.findById(tx.categoryId);
      final row = [
        _escapeCsv(tx.title),
        tx.amount.toStringAsFixed(2),
        tx.type.name,
        _escapeCsv(category?.name ?? 'Other'),
        tx.date.toIso8601String(),
        _escapeCsv(tx.note),
      ];
      buffer.writeln(row.join(','));
    }

    return buffer.toString();
  }

  static String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  static String buildBackupJson({
    required List<TransactionModel> transactions,
    required List<BudgetModel> budgets,
    required List<SavingGoal> goals,
  }) {
    return jsonEncode({
      'app': 'trackora',
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'transactions': transactions.map((tx) => tx.toJson()).toList(),
      'budgets': budgets.map((budget) => budget.toJson()).toList(),
      'goals': goals.map((goal) => goal.toJson()).toList(),
    });
  }
}
