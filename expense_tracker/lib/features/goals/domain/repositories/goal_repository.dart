import 'package:expense_tracker/shared/models/saving_goal_model.dart';

abstract class GoalRepository {
  List<SavingGoal> fetchGoals();
  Future<void> saveGoals(List<SavingGoal> goals);
}
