import 'package:expense_tracker/core/services/local_storage_service.dart';
import 'package:expense_tracker/features/budget/domain/repositories/budget_repository.dart';
import 'package:expense_tracker/shared/models/budget_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  final storageService = ref.watch(localStorageServiceProvider);
  return LocalBudgetRepository(storageService);
});

class LocalBudgetRepository implements BudgetRepository {
  final LocalStorageService _storageService;

  LocalBudgetRepository(this._storageService);

  @override
  List<BudgetModel> fetchBudgets() {
    return _storageService.getBudgets();
  }

  @override
  Future<void> saveBudgets(List<BudgetModel> budgets) {
    return _storageService.saveBudgets(budgets);
  }
}
