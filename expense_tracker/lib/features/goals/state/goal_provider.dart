import 'package:expense_tracker/features/goals/data/repositories/local_goal_repository.dart';
import 'package:expense_tracker/features/goals/domain/repositories/goal_repository.dart';
import 'package:expense_tracker/shared/models/saving_goal_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'goal_state.dart';

class GoalNotifier extends Notifier<GoalState> {
  GoalRepository get _repository => ref.read(goalRepositoryProvider);

  @override
  GoalState build() {
    final stored = _repository.fetchGoals();
    return GoalState(goals: stored);
  }

  void _persist() {
    _repository.saveGoals(state.goals);
  }

  void addGoal(SavingGoal goal) {
    state = state.copyWith(goals: [...state.goals, goal]);
    _persist();
  }

  void updateGoal(SavingGoal goal) {
    state = state.copyWith(
      goals: state.goals.map((item) => item.id == goal.id ? goal : item).toList(),
    );
    _persist();
  }

  void deleteGoal(String id) {
    state = state.copyWith(
      goals: state.goals.where((item) => item.id != id).toList(),
    );
    _persist();
  }

  void contribute(String id, double amount) {
    final index = state.goals.indexWhere((item) => item.id == id);
    if (index == -1) return;
    final updated = [...state.goals];
    updated[index] = updated[index].copyWith(
      savedAmount: updated[index].savedAmount + amount,
    );
    state = state.copyWith(goals: updated);
    _persist();
  }

  void withdraw(String id, double amount) {
    final index = state.goals.indexWhere((item) => item.id == id);
    if (index == -1) return;
    final updated = [...state.goals];
    updated[index] = updated[index].copyWith(
      savedAmount: updated[index].savedAmount - amount < 0
          ? 0
          : updated[index].savedAmount - amount,
    );
    state = state.copyWith(goals: updated);
    _persist();
  }

  void replaceAll(List<SavingGoal> goals) {
    state = GoalState(goals: goals);
    _persist();
  }

  void reset() {
    state = const GoalState();
    _persist();
  }
}

final goalProvider = NotifierProvider<GoalNotifier, GoalState>(GoalNotifier.new);

final totalSavedInGoalsProvider = Provider<double>((ref) {
  return ref
      .watch(goalProvider)
      .goals
      .fold(0.0, (sum, goal) => sum + goal.savedAmount);
});
