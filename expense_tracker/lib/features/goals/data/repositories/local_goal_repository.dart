import 'package:expense_tracker/core/services/local_storage_service.dart';
import 'package:expense_tracker/features/goals/domain/repositories/goal_repository.dart';
import 'package:expense_tracker/shared/models/saving_goal_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  final storageService = ref.watch(localStorageServiceProvider);
  return LocalGoalRepository(storageService);
});

class LocalGoalRepository implements GoalRepository {
  final LocalStorageService _storageService;

  LocalGoalRepository(this._storageService);

  @override
  List<SavingGoal> fetchGoals() {
    return _storageService.getGoals();
  }

  @override
  Future<void> saveGoals(List<SavingGoal> goals) {
    return _storageService.saveGoals(goals);
  }
}
