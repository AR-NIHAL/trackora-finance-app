import 'package:expense_tracker/shared/models/saving_goal_model.dart';

class GoalState {
  final List<SavingGoal> goals;

  const GoalState({this.goals = const []});

  GoalState copyWith({List<SavingGoal>? goals}) {
    return GoalState(goals: goals ?? this.goals);
  }
}
