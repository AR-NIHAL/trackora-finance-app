import 'package:hive_ce/hive.dart';
import 'package:trackkora/core/constants/hive_boxes.dart';
import 'package:trackkora/features/budgets/data/models/budget_model.dart';
import 'package:trackkora/features/budgets/domain/entities/budget.dart';
import 'package:trackkora/features/budgets/domain/repositories/budget_repository.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  late Box<BudgetModel> _box;

  BudgetRepositoryImpl() {
    _box = Hive.box<BudgetModel>(HiveBoxes.budgets);
  }

  @override
  Future<List<Budget>> getAll() async {
    return _box.values.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Budget>> getBudgetsForMonth(DateTime month) async {
    final start = DateTime(month.year, month.month);
    final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
    return _box.values
        .where((m) =>
            m.month.isAfter(start.subtract(const Duration(days: 1))) &&
            m.month.isBefore(end.add(const Duration(days: 1))))
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<Budget?> getById(String id) async {
    final model = _box.values.cast<BudgetModel?>().firstWhere(
          (m) => m?.id == id,
          orElse: () => null,
        );
    return model?.toEntity();
  }

  @override
  Future<void> add(Budget budget) async {
    final model = BudgetModel.fromEntity(budget);
    await _box.put(budget.id, model);
  }

  @override
  Future<void> update(Budget budget) async {
    final model = BudgetModel.fromEntity(budget);
    await _box.put(budget.id, model);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
